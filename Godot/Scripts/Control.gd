extends Control
#class_name NakamaMultiplayer

var session: NakamaSession
var client: NakamaClient
var socket: NakamaSocket

var createdMatch
var multiplayerBridge: NakamaMultiplayerBridge

@onready var question_text = $Panel5/question_text
@onready var option_1 = $Panel5/option_1
@onready var option_2 = $Panel5/option_2
@onready var option_3 = $Panel5/option_3
@onready var option_4 = $Panel5/option_4
@onready var correct_answer = $Panel5/correct_answer
@onready var submit_button = $Panel5/submit_button

@onready var question_text2=$Panel4/LineEdit3


@onready var question_text1 = $Panel3/LineEdit
@onready var keyword=$Panel3/LineEdit2

@export var rich_text_label : RichTextLabel

static var Players = {}
var torf=false

signal onStartGame()

func _ready():
	submit_button.connect("pressed", Callable(self,"_on_submit_button_pressed"))
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")

func updateUserInfo(username, displayname, avatarurl="", language="en", location="US", timezone="GMT+8"):
	await client.update_account_async(session, username, displayname, avatarurl, language, location, timezone)

func onMatchPresence(presence: NakamaRTAPI.MatchPresenceEvent):
	print(presence)

func onMatchState(state: NakamaRTAPI.MatchData):
	print(state)

func onSocketConnected():
	print("Socket Connected")

func onSocketClosed():
	print("Socket Closed")

func onSocketReceivedError(err):
	print("Error: " + str(err))

func _process(delta):
	pass

func _on_login_button_pressed():
	session = await client.authenticate_email_async($Panel2/EmailInput.text, $Panel2/PasswordInput.text)
	socket = Nakama.create_socket_from(client)
	await socket.connect_async(session)

	socket.connected.connect(onSocketConnected)
	socket.closed.connect(onSocketClosed)
	socket.received_error.connect(onSocketReceivedError)
	socket.received_match_presence.connect(onMatchPresence)
	socket.received_match_state.connect(onMatchState)

	var account = await client.get_account_async(session)
	$Panel/UserAccountText.text = account.user.username
	$Panel/DisplayNameText.text = account.user.display_name

	setupMultiplayerBridge()
	

func setupMultiplayerBridge():
	multiplayerBridge = NakamaMultiplayerBridge.new(socket)
	multiplayerBridge.match_join_error.connect(onMatchJoinError)

	var multiplayer = get_tree().get_multiplayer()
	multiplayer.set_multiplayer_peer(multiplayerBridge.multiplayer_peer)

	multiplayer.peer_connected.connect(onPeerConnected)
	multiplayer.peer_disconnected.connect(onPeerDisconnected)

func onPeerConnected(id):
	print("Peer connected, ID: " + str(id))
	if !Players.has(id):
		Players[id] = {
			"name": id,
			"ready": 0
		}

	if !Players.has(multiplayer.get_unique_id()):
		Players[multiplayer.get_unique_id()] = {
			"name": multiplayer.get_unique_id(),
			"ready": 0
		}

func onPeerDisconnected(id):
	print("Peer disconnected, ID: " + str(id))

func onMatchJoinError(error):
	print("Unable to join: " + error.message)

func onMatchJoin():
	print("Joined match")

func _on_join_pressed():
	multiplayerBridge.join_named_match($Panel3/LineEdit.text)

func _on_ping_pressed():
	pass

func _on_matchmaking_button_down():
	var query = "+properties.region:U +properties.rank:>=4 +properties.rank:<=10"
	var stringP = {"region": "mn"}
	var numberP = {"rank": 6}
	var ticket = await socket.add_matchmaker_async(query, 2, 4, stringP, numberP)

	if ticket.is_exception():
		print("Failed to matchmake: " + str(ticket))
		return

	print("Match ticket number: " + str(ticket))
	socket.received_matchmaker_matched.connect(onMatchMakerMatched)

func onMatchMakerMatched(matched: NakamaRTAPI.MatchmakerMatched):
	var joinedMatch = await socket.join_matched_async(matched)
	createdMatch = joinedMatch
	print("Match joined: " + str(createdMatch.match_id))

func _on_add_friend_button_down():
	var id = [$Panel4/addFriendText.text]
	var result = await client.add_friends_async(session, null, id)

func _on_get_friend_button_down():
	var result = await client.list_friends_async(session)

	for i in result.friends:
		var currentLabel = Label.new()
		currentLabel.text = i.user.display_name
		$Panel4/Panel5/VBoxContainer.add_child(currentLabel)

func _on_get_friend_2_button_down():
	var result = await client.delete_friends_async(session, [], [$Panel4/addFriendText.text])

func _on_start_button_down():
	Ready.rpc(multiplayer.get_unique_id())
	pass

@rpc("any_peer", "call_local")
func Ready(id):
	Players[id].ready = 1

	if multiplayer.is_server():
		var readyPlayers = 0
		for i in Players:
			if Players[i].ready == 1:
				readyPlayers += 1
				print(Players)
		if readyPlayers == Players.size():
			StartGame.rpc()

@rpc("any_peer", "call_local")
func StartGame():
	onStartGame.emit()
	hide()
func _on_submit_button_pressed():
	
	var dataList = await client.list_storage_objects_async(session, "Question", session.user_id, 5)
	var objects = dataList.objects  # Access the objects property
	var json_parser = JSON.new()
	var questions_list = []  # List to hold all questions

	for obj in objects:
		var parse_result = json_parser.parse(obj.value)
		if parse_result == OK:
			var data = json_parser.data  # Parsed data from the storage
			if data.has("questions"):
				questions_list = data["questions"]  # Get existing questions

	# Create the new question
	var new_question = {
		"question_text": question_text.text,
		"options": [option_1.text, option_2.text, option_3.text, option_4.text],
		"correct_answer": correct_answer.text
	}

	questions_list.append(new_question)

	var json_data = {
		"questions": questions_list
	}

	var data_to_save = JSON.stringify(json_data)

	var write_result = await client.write_storage_objects_async(session, [
		NakamaWriteStorageObject.new("Question", "Question", 1, 1, data_to_save, "")
	])

	# Clear the input fields
	question_text.text = ""
	option_1.text = ""
	option_2.text = ""
	option_3.text = ""
	option_4.text = ""
	correct_answer.text = ""

	print("Successfully stored")
func _on_submit_button_2_pressed():
	var dataList1 = await client.list_storage_objects_async(session, "Question1", session.user_id, 5)
	var objects1 = dataList1.objects  # Access the objects property
	var json_parser1 = JSON.new()
	var questions_list1 = []  
	
	for obj1 in objects1:
		var parse_result1 = json_parser1.parse(obj1.value)
		if parse_result1 == OK:
			var data1 = json_parser1.data  # Parsed data from the storage
			if data1.has("questions"):
				questions_list1 = data1["questions"]  # Get existing questions
	var question1 = {
		"question_text1": question_text1.text,
		"keyword": keyword.text
	}
	questions_list1.append(question1)

	var json_data1 = {
		"questions": questions_list1
	}

	var data_to_save1 = JSON.stringify(json_data1)

	# Save the updated list back to Nakama
	var write_result = await client.write_storage_objects_async(session, [
		NakamaWriteStorageObject.new("Question1", "Question1", 1, 1, data_to_save1, "")
	])

	print("Succesfully stored")
	question_text1.text = ""
	keyword.text = ""
func _on_button_pressed():
	var dataList2 = await client.list_storage_objects_async(session, "Question2", session.user_id, 5)
	var objects2 = dataList2.objects  # Access the objects property
	var json_parser2 = JSON.new()
	var questions_list2 = []  
	
	for obj2 in objects2:
		var parse_result2 = json_parser2.parse(obj2.value)
		if parse_result2 == OK:
			var data2 = json_parser2.data  # Parsed data from the storage
			if data2.has("questions"):
				questions_list2 = data2["questions"]  # Get existing questions
	
	
	var question2 = {
		"question_text2": question_text2.text,
		"True or False": torf
	}
	questions_list2.append(question2)

	var json_data2 = {
		"questions": questions_list2
	}

	var data_to_save2 = JSON.stringify(json_data2)

	# Save the updated list back to Nakama
	var write_result = await client.write_storage_objects_async(session, [
		NakamaWriteStorageObject.new("Question2", "Question2", 1, 1, data_to_save2, "")
	])
	print("Succesfully stored")
	question_text2.text = ""
func _on_check_button_toggled(checked: bool):
	if checked:
		torf=true
	else:
		torf=false


func _on_done_pressed():
	$".".visible = false


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/options/options.tscn")
