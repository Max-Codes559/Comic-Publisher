extends Node2D

signal refresh()
onready var TGrab = $TGrab
onready var PGroup = get_tree().get_nodes_in_group("panels")

var Display = ImageTexture.new()
var ImageLoad = Image.new()

var StoredPage
var ReplacedPage

func grab_slot(new_page):
	ImageLoad.load("res://images/" + Global.ImageDict[Global.Order[new_page]])
	Display.create_from_image(ImageLoad)
	TGrab.texture = Display
	StoredPage = new_page

func deposit_slot(new_page, stored_page):
	if new_page != stored_page:
		Global.Order[new_page] = stored_page
		Global.Order[stored_page] = new_page
		
		TGrab.texture = null
		StoredPage = null
		ReplacedPage = null

func edit_order(index, new_key):
	Global.Order[index] = new_key

func connect_panels():
	for panels in PGroup:
		panels.connect("prev_clicked", self, "_on_Preview_prev_clicked")
#connect panels to AssMouse
func _ready():
	connect_panels()

func _process(_delta):
	position = get_global_mouse_position()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			StoredPage = null
			TGrab.texture = null

func _on_Preview_prev_clicked(new_page):
	if StoredPage == null:
		grab_slot(new_page)
		print(new_page)
	else:
		print(Global.Order)
		deposit_slot(new_page, StoredPage)
		print(Global.Order)
#called when clicking panels, new_page is page number/ dict key of panel clicked
#Reads from ImageDict and displays image that is clicked
