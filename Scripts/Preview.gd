extends TextureRect

signal prev_clicked(new_page)
var Display = ImageTexture.new()
var ImageLoad = Image.new()
onready var pg = self.get_index()
#onready var Grid = get_parent()

func _ready():
	ImageLoad.load("res://images/" + Global.ImageDict[Global.Order[pg]])
	Display.create_from_image(ImageLoad)
	texture = Display
	
func _on_Preview_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("prev_clicked", pg)
			
			
			
#func place():
	#print("place")
