extends Node

var client = null
var session = null
var socket = null

var map_name:String

var email
var password

var level_custom_data = {
	"selected_map": null,
	"selected_char": null,
	"selected_mode": null,
	"gameplay": null,
	"map_name": null,
	"round": null,
	"question_num": null,
	"questions": null
}

func _ready():
	print(level_custom_data)

func initialize_nakama(client_obj, session_obj, socket_obj):
	client = client_obj
	session = session_obj
	socket = socket_obj
	
func initialize_email(x, y):
	email = x
	password = y

func send_level_data_to_nakama():
	# List existing storage objects in the "Levels" collection for the user
	var dataList = await client.list_storage_objects_async(session, "Levels", session.user_id, 5)
	var objects = dataList.objects
	var json_parser = JSON.new()
	var questions_list = []  # Ensure this is an array

	# Parse existing storage objects to retrieve questions
	for obj in objects:
		var parse_result = json_parser.parse(obj.value)
		if parse_result == OK:
			var data = json_parser.data  # Parsed data from the storage
			if data.has("Levels"):
				# Check if data["Levels"] is an array, convert it if necessary
				if data["Levels"] is Array:
					questions_list = data["Levels"]  # Get existing questions (if an array)
				else:
					# If "Levels" is not an array, wrap it into one
					questions_list = [data["Levels"]]

	# Append the current level data to the questions list
	questions_list.append(level_custom_data)

	var json_data = {
		"Levels": questions_list
	}
	var level_data_json = JSON.stringify(json_data)

	# Check if any existing storage object was found
	if objects.size() == 0:
		# If no existing objects are found, create the "Levels" storage object
		var write_result = await client.write_storage_objects_async(session, [
			NakamaWriteStorageObject.new("Levels", "Levels", 1, 1, level_data_json, "")
		])
		if write_result:
			print("New Levels collection created and level data successfully sent to Nakama.")
		else:
			print("Failed to create Levels collection and send level data.")
	else:
		# Update the existing "Levels" storage object
		var write_result = await client.write_storage_objects_async(session, [
			NakamaWriteStorageObject.new("Levels", "Levels", 1, 1, level_data_json, "")
		])
		if write_result:
			print("Level data successfully updated in Nakama.")
		else:
			print("Failed to update level data in Nakama.")
