extends MenuButton

var MenuPopUp : PopupMenu = self.get_popup()

func _ready():
	
	MenuPopUp.add_item("Mechanic")
	MenuPopUp.add_item("Chemistry")
	MenuPopUp.add_item("Mathematics")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
