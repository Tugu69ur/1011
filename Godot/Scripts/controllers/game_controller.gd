extends Node

var client: NakamaClient
var socket: NakamaSocket
var session: NakamaSession
var questions: Array = []
var current_question_index: int = 0  
var score: int = 0  

const COLLECTION_ID = "Status"

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button] = []
var index: int = 0
var correct: int = 0

@onready var question_text: Label = $Control/qInfo/QuestionText

func _ready():
	buttons.append($Control/qHolder/Option1)
	buttons.append($Control/qHolder/Option2)
	buttons.append($Control/qHolder/Option3)
	buttons.append($Control/qHolder/Option4)
	
	for button in buttons:
		button.visible = true
		button.disabled = false  # Ensure buttons are enabled
	get_tree().paused = false
	$Timer.start()
	fetch_questions()  

func _on_timer_timeout():
	get_tree().paused = true
	$Control.visible = true
	for button in buttons:
		button.visible = true
		button.disabled = false
	correct = 0
	load_quiz()

func fetch_questions() -> void:
	if NakamaManager.client == null:
		print("Nakama client is not initialized!")
		return

	session = await NakamaManager.client.authenticate_email_async(NakamaManager.email, NakamaManager.password)
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	socket = Nakama.create_socket_from(NakamaManager.client)
	await socket.connect_async(session)
	
	var result = await client.list_storage_objects_async(session, "Levels", session.user_id, 5)
	if result.objects.size() == 0:
		print("No levels found.")
		return
		
	var json_parser = JSON.new()
	for obj in result.objects:
		var parse_result = json_parser.parse(obj.value)  
		if parse_result == OK and json_parser.data.has("Levels"):
			for level in json_parser.data["Levels"]:
				if level.has("map_name") and level["map_name"] == NakamaManager.map_name:
					questions = level["questions"]
					break

	if questions.size() >= 0:
		_display_question(questions[current_question_index])  
		print(questions[current_question_index])
		load_quiz()  

func _display_question(question_data: Dictionary) -> void:
	# Check if it's a keyword question
	if question_data.has("keyword"):
		question_text.text = question_data["question_text1"]  # For fill-in-the-blank questions
		$Control/qHolder/Option1.visible = false  # Hide options for fill-in-the-blank
		$Control/qHolder/Option2.visible = false
		$Control/qHolder/Option3.visible = false
		$Control/qHolder/Option4.visible = false
		$Control/LineEdit.visible = true
		$Control/Button.visible = true
	elif question_data.has("options"):  # It's a multiple-choice question
		question_text.text = question_data["question_text"]
		$Control/qHolder/Option1.text = question_data["options"][0]
		$Control/qHolder/Option2.text = question_data["options"][1]
		$Control/qHolder/Option3.text = question_data["options"][2]
		$Control/qHolder/Option4.text = question_data["options"][3]
		
		for button in buttons:
			button.visible = true  # Show option buttons
			button.disabled = false  # Ensure buttons are enabled
	elif question_data.has("True or False"):  # It's a true/false question
		question_text.text = question_data["question_text2"]
		$Control/qHolder/Option1.text = "true"  
		$Control/qHolder/Option2.text = "false"
		
		$Control/qHolder/Option3.visible = false
		$Control/qHolder/Option3.visible = false
		$Control/qHolder/Option4.disabled = true
		$Control/qHolder/Option4.disabled = true
		#$Control/qHolder/Option3.visible = false
		#$Control/qHolder/Option3.visible = false
		#$Control/qHolder/Option4.disabled = true
		#$Control/qHolder/Option4.disabled = true

	# Reset button color for all types
	for button in buttons:
		button.modulate = Color(1, 1, 1)  # Reset button color

func load_quiz() -> void:
	if index > questions.size():  
		$Control.visible = false
		get_tree().paused = false
		print("Score: ", correct)  
		return
	_display_question(questions[index])
	current_question_index = index 
	
func _next_quiz() -> void:
	await get_tree().create_timer(2).timeout
	$Control/LineEdit.text = ""
	$Control/Button.modulate = Color.WHITE
	$Control/LineEdit.visible = false
	$Control/Button.visible = false
	for bt in buttons:
		bt.modulate = Color.WHITE 
	index += 1
	load_quiz() 

func _on_option_1_pressed():
	if questions[current_question_index].has("True or False"):
		if ($Control/qHolder/Option1.text == str(questions[current_question_index]["True or False"])):
			$Control/qHolder/Option1.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option1.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()
	else:
		# Existing multiple-choice logic
		if $Control/qHolder/Option1.text == questions[current_question_index]["correct_answer"]:
			$Control/qHolder/Option1.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option1.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()

func _on_option_2_pressed():
	if questions[current_question_index].has("True or False"):
		if $Control/qHolder/Option2.text == str(questions[current_question_index]["True or False"]):
			$Control/qHolder/Option2.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option2.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()
	else:
		# Existing multiple-choice logic
		if $Control/qHolder/Option2.text == questions[current_question_index]["correct_answer"]:
			$Control/qHolder/Option2.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option2.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()

func _on_option_3_pressed():
	if questions[current_question_index].has("True or False"):
		if $Control/qHolder/Option3.text == (questions[current_question_index]["True or False"]):
			$Control/qHolder/Option3.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option3.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()
	else:
		# Existing multiple-choice logic
		if $Control/qHolder/Option3.text == questions[current_question_index]["correct_answer"]:
			$Control/qHolder/Option3.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option3.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()

func _on_option_4_pressed():
	if questions[current_question_index].has("True or False"):
		if $Control/qHolder/Option4.text == (questions[current_question_index]["True or False"]):
			$Control/qHolder/Option4.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option4.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()
	else:
		# Existing multiple-choice logic
		if $Control/qHolder/Option4.text == questions[current_question_index]["correct_answer"]:
			$Control/qHolder/Option4.modulate = color_right
			$Correct.play()
			correct += 1
		else:
			$Control/qHolder/Option4.modulate = color_wrong
			$Incorrect.play()
		_next_quiz()

func _on_button_pressed():
	if($Control/LineEdit.text == str(questions[current_question_index]["keyword"])):
		$Control/Button.modulate = color_right
		correct += 1
		$Correct.play()
	else:
		$Control/Button.modulate = color_wrong
		$Incorrect.play()
	_next_quiz()
