extends GridContainer
var Preview = load("res://Scenes/Preview.tscn")
onready var PageCount = Global.ImageDict.size()

func add_previews():
	for n in PageCount:
		Preview = load("res://Scenes/Preview.tscn").instance()
		add_child(Preview)
		
func _ready():
	add_previews()


