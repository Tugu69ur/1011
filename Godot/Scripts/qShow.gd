extends Control

var session: NakamaSession
var client: NakamaClient
var socket: NakamaSocket

func _ready():
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	session = await client.authenticate_email_async("t@gmail.com", "password69")
	socket = Nakama.create_socket_from(client)
	await socket.connect_async(session)

	#socket.connected.connect(onSocketConnected)
	#socket.closed.connect(onSocketClosed)
	#socket.received_error.connect(onSocketReceivedError)
	#socket.received_match_presence.connect(onMatchPresence)
	#socket.received_match_state.connect(onMatchState)

	var account = await client.get_account_async(session)
	fetch_questions()
	
func fetch_questions():
	var dataList = await client.list_storage_objects_async(session, "Question2", session.user_id, 5)
	var dataList1 = await client.list_storage_objects_async(session, "Question", session.user_id, 5)
	var dataList2 = await client.list_storage_objects_async(session, "Question1", session.user_id, 5)
	
	if dataList:
		display_questions(dataList)
	if dataList1:
		display_questions1(dataList1)
	if dataList2:
		display_questions2(dataList2)
	

func display_questions(dataList):
	var vbox = $Panel3/VBoxContainer
	var vvbox3 = $Panel3/VBoxContainer5
	var json_instance = JSON.new()
	var objects = dataList.objects
	
	for obj in objects:
		var parse_result = json_instance.parse(obj.value)
		if parse_result == OK:
			var data = json_instance.get_data()
			if data.has("questions"):
				var questions = data["questions"]
				for question in questions:
					
					var question_label = Label.new()
					question_label.text = question["question_text2"]
					
					var answer_label = Label.new()
					answer_label.text = "答え: " + ("はい" if question["True or False"] else "いいえ")

					var check3 = CheckBox.new()
						
					check3.set_meta("question", question)

					vvbox3.add_child(check3)
					vbox.add_child(question_label)
					vbox.add_child(answer_label)
					vbox.add_child(Control.new())
		$Done.connect("pressed", Callable(self, "_on_done_pressed"))
		
func _on_done_pressed():
	var checked_questions = []
	var vvbox3 = $Panel3/VBoxContainer5
	var vvbox2 = $Panel2/VBoxContainer4
	var vvbox1 = $Panel/VBoxContainer3
	for child in vvbox3.get_children():
		if child is CheckBox and child.is_pressed():
			var question = child.get_meta("question") 
			checked_questions.append(question)
	for child in vvbox2.get_children():
		if child is CheckBox and child.is_pressed():
			var question = child.get_meta("question") 
			checked_questions.append(question)
	for child in vvbox1.get_children():
		if child is CheckBox and child.is_pressed():
			var question = child.get_meta("question") 
			checked_questions.append(question)
	NakamaManager.level_custom_data["questions"] = checked_questions
	$".".visible = false
	
func display_questions1(dataList1):
	var vbox1 = $Panel/VBoxContainer1
	var vvbox1 = $Panel/VBoxContainer3
	var json_instance1 = JSON.new()
	var objects1 = dataList1.objects 
	for obj1 in objects1:
		var parse_result1 = json_instance1.parse(obj1.value) 
		if parse_result1 == OK:  
			var data1 = json_instance1.get_data()  
			if data1.has("questions"):
				var questions1 = data1["questions"]
				for question1 in questions1:
					var question_label1 = Label.new()
					var check = CheckBox.new()
					check.set_meta("question", question1)
					question_label1.text = question1["question_text"]
					vbox1.add_child(question_label1)   
					vvbox1.add_child(check)
					vbox1.add_child(Control.new())   
					
func display_questions2(dataList2):
	var vbox2 =$Panel2/VBoxContainer2
	var vvbox2 =$Panel2/VBoxContainer4
	var json_instance2 = JSON.new()
	var objects2 = dataList2.objects 
	for obj2 in objects2:
		var parse_result2 = json_instance2.parse(obj2.value) 
		if parse_result2 == OK:  
			var data2 = json_instance2.get_data()  
			if data2.has("questions"):
				var questions2 = data2["questions"]
				for question2 in questions2:
					var question_label2 = Label.new()
					var check2 = CheckBox.new()
					check2.set_meta("question", question2)
					question_label2.text = question2["question_text1"]  
					var answer_label2 = Label.new()
					answer_label2.text = "キーワード: " + (question2["keyword"]) 
					vbox2.add_child(question_label2) 
					vbox2.add_child(answer_label2)  
					vvbox2.add_child(check2)  
					vbox2.add_child(Control.new())   

