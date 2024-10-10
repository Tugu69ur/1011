extends Node

var client = NakamaManager.client
var session = NakamaManager.session


func get_questions(level_name: String):
	if client == null:
		print("Error: Nakama client is not initialized.")
		return []
	if session == null:
		print("Error: Nakama session is not initialized.")
		return []
	var questions = []
	var dataList = await client.list_storage_objects_async(session, "Levels", session.user_id, 5)
	var json_instance = JSON.new()  # Create an instance of JSON
	for obj in dataList.objects:
		var parse_result = json_instance.parse(obj.value)  # Use the instance to parse
		if parse_result.error == OK:
			var levels_data = parse_result.data
			
			# Loop through levels to extract questions
			for level in levels_data["Levels"]:
				if level["map_name"] == level_name:  # Filter by the given level_name
					for question_info in level["questions"]:
						var quiz_rush = QuizRush.new()
						quiz_rush.question_info = question_info.get("question_text", question_info.get("question_text2", ""))
						quiz_rush.options = []
						quiz_rush.correct = ""

						if question_info.has("options"):
							quiz_rush.type = Enum.qType.TEXT
							quiz_rush.options = question_info.options
							quiz_rush.correct = question_info.correct_answer
						elif question_info.has("True or False"):
							quiz_rush.type = Enum.qType.TEXT  # Or use a different enum type for True/False
							quiz_rush.options = ["True", "False"]
							quiz_rush.correct = str(question_info["True or False"])  # Use square brackets for dictionary access
						questions.append(quiz_rush)

	return questions
