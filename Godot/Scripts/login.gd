extends Control

@onready var trans = $Transition

var session : NakamaSession
var client : NakamaClient
var socket : NakamaSocket

func _ready():
	trans.play("fade_in")
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")

func updateUserInfo(username, displayname, avatarurl = "", language = "en", location = "us", timezone = "est"):
	await client.update_account_async(session, username, displayname, avatarurl, language, location, timezone)

func onMatchPresence(presence : NakamaRTAPI.MatchPresenceEvent):
	print(presence)

func onMatchState(state : NakamaRTAPI.MatchData):
	print("data is : " + str(state.data))

# Socket events
func onSocketConnected():
	print("Socket Connected")

func onSocketClosed():
	print("Socket Closed")

func onSocketReceivedError(err):
	print("Socket Error:" + str(err))

func _on_login_button_pressed():
	session = await client.authenticate_email_async($EmailInput.text, $PasswordInput.text)
	socket = Nakama.create_socket_from(client)
	await socket.connect_async(session)
	socket.connected.connect(onSocketConnected)
	socket.closed.connect(onSocketClosed)
	socket.received_error.connect(onSocketReceivedError)
	socket.received_match_presence.connect(onMatchPresence)
	socket.received_match_state.connect(onMatchState)

	updateUserInfo("test", "testDisplay")
	var account = await client.get_account_async(session)
	NakamaManager.initialize_nakama(client ,session,socket)
	NakamaManager.initialize_email($EmailInput.text, $PasswordInput.text)
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_login_button_2_pressed():
	var google_token = "RETRIEVE_GOOGLE_TOKEN_HERE" 
	session = await client.authenticate_google_async(google_token)
	
	socket = Nakama.create_socket_from(client)
	await socket.connect_async(session)
	
	socket.connected.connect(onSocketConnected)
	socket.closed.connect(onSocketClosed)
	socket.received_error.connect(onSocketReceivedError)
	socket.received_match_presence.connect(onMatchPresence)
	socket.received_match_state.connect(onMatchState)

	updateUserInfo("googleUser", "GoogleDisplayName")
	var account = await client.get_account_async(session)

	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_login_fb_pressed():
	var oauth_token = "<token>"
	var import_friends = true
	var session : NakamaSession = await client.authenticate_facebook_async(oauth_token, import_friends)
	if session.is_exception():
		print("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
