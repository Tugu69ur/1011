extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int
var correct: int

@onready var question_text: Label = $Quiz/qInfo/Question
@onready var question_image: TextureRect = $Quiz/qInfo/imageHolder/questionImage

func _ready() ->void:
	for button in $Quiz/qHolder.get_children():
		buttons.append(button)
		
	load_quiz()

func load_quiz() ->void:
	question_text.text= quiz.theme[index].question_info
