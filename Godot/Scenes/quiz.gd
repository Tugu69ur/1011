extends Control

var client: NakamaClient
var socket: NakamaSocket
var session: NakamaSession
var questions: Array = []  
var current_question_index: int = 0  
var score: int = 0  

@onready var question_text = $VBoxContainer/Label
@onready var option_1 = $VBoxContainer/Button
@onready var option_2 = $VBoxContainer/Button2
@onready var option_3 = $VBoxContainer/Button3
@onready var option_4 = $VBoxContainer/Button4

func _ready():
	_authenticate_and_fetch_data()

func _authenticate_and_fetch_data():
	if NakamaManager.client == null:
		print("Nakama client is not initialized!")
		return

	NakamaManager.session = await NakamaManager.client.authenticate_email_async(NakamaManager.email, NakamaManager.password)
	session = NakamaManager.session
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	socket = Nakama.create_socket_from(NakamaManager.client)
	await socket.connect_async(NakamaManager.session)

	var result = await client.list_storage_objects_async(session, "Levels", session.user_id, 5)

	if result.objects.size() == 0:
		print("No levels found.")
		return

	# Create a JSON instance
	var json_parser = JSON.new()

	# Store questions in an array
	for obj in result.objects:
		var parse_result = json_parser.parse(obj.value)  # Parse the JSON
		if parse_result == OK and json_parser.data.has("Levels"):
			questions = json_parser.data["Levels"][0]["questions"]  # Accessing the first level's questions
			break

	if questions.size() > 0:
		_display_question(questions[current_question_index])
		

func _display_question(question_data: Dictionary):
	question_text.text = question_data["question_text"]
	option_1.text = question_data["options"][0]
	option_2.text = question_data["options"][1]
	option_3.text = question_data["options"][2]
	option_4.text = question_data["options"][3]
	
	
	#$VBoxContainer/Button.modulate = Color.hex(0x0021262e)
	#$VBoxContainer/Button2.modulate =Color.hex(0x0021262e)
	#$VBoxContainer/Button3.modulate =Color.hex(0x0021262e)
	#$VBoxContainer/Button4.modulate =Color.hex(0x0021262e)
	
	$VBoxContainer/Button.modulate = Color(1,1,1)
	$VBoxContainer/Button2.modulate =Color(1,1,1)
	$VBoxContainer/Button3.modulate =Color(1,1,1)
	$VBoxContainer/Button4.modulate =Color(1,1,1)
	
	#$VBoxContainer/Button4.add_color_override("font_color", Color(1,1,1))
	#$VBoxContainer/Button3.add_color_override("font_color", Color(1,1,1))
	#$VBoxContainer/Button2.add_color_override("font_color", Color(1,1,1))
	#$VBoxContainer/Button.add_color_override("font_color", Color(1,1,1))
func _on_button_pressed():
	var current_question = questions[current_question_index]
	var correct_answer = current_question["correct_answer"]
	var selected_answer = $VBoxContainer/Button.text

	if selected_answer == correct_answer:
		score += 1  # Increment score for correct answer
		$VBoxContainer/Button.modulate = Color(0, 1, 0)  # Set button color to green
		print("Correct answer!")
	else:
		$VBoxContainer/Button.modulate = Color(1, 0, 0)  # Set button color to red
		print("Incorrect answer. The correct answer was: ", correct_answer)

	# Move to the next question after a delay
	current_question_index += 1
	if current_question_index < questions.size():
		await get_tree().create_timer(1.5).timeout  # Wait for 1.5 seconds before displaying the next question
		_display_question(questions[current_question_index])
	else:
		print("No more questions available.")
		print("Your score: ", score, "/", questions.size())  # Print the final score

func _on_button_2_pressed():
	var current_question = questions[current_question_index]
	var correct_answer = current_question["correct_answer"]
	var selected_answer = $VBoxContainer/Button2.text

	if selected_answer == correct_answer:
		score += 1  # Increment score for correct answer
		$VBoxContainer/Button2.modulate = Color(0, 1, 0)  # Set button color to green
		print("Correct answer!")
	else:
		$VBoxContainer/Button2.modulate = Color(1, 0, 0)  # Set button color to red
		print("Incorrect answer. The correct answer was: ", correct_answer)

	# Move to the next question after a delay
	current_question_index += 1
	if current_question_index < questions.size():
		await get_tree().create_timer(1.5).timeout
		_display_question(questions[current_question_index])
	else:
		print("No more questions available.")
		print("Your score: ", score, "/", questions.size())

func _on_button_3_pressed():
	var current_question = questions[current_question_index]
	var correct_answer = current_question["correct_answer"]
	var selected_answer = $VBoxContainer/Button3.text

	if selected_answer == correct_answer:
		score += 1  # Increment score for correct answer
		$VBoxContainer/Button3.modulate = Color(0, 1, 0)  # Set button color to green
		print("Correct answer!")
	else:
		$VBoxContainer/Button3.modulate = Color(1, 0, 0)  # Set button color to red
		print("Incorrect answer. The correct answer was: ", correct_answer)

	# Move to the next question after a delay
	current_question_index += 1
	if current_question_index < questions.size():
		await get_tree().create_timer(1.5).timeout
		_display_question(questions[current_question_index])
	else:
		print("No more questions available.")
		print("Your score: ", score, "/", questions.size())

func _on_button_4_pressed():
	var current_question = questions[current_question_index]
	var correct_answer = current_question["correct_answer"]
	var selected_answer = $VBoxContainer/Button4.text

	if selected_answer == correct_answer:
		score += 1  # Increment score for correct answer
		$VBoxContainer/Button4.modulate = Color(0, 1, 0)  
		print("Correct answer!")
	else:
		$VBoxContainer/Button4.modulate = Color(1, 0, 0) 
		print("Incorrect answer. The correct answer was: ", correct_answer)

	current_question_index += 1
	if current_question_index < questions.size():
		await get_tree().create_timer(1.5).timeout
		_display_question(questions[current_question_index])
	else:
		print("No more questions available.")
		print("Your score: ", score, "/", questions.size())
