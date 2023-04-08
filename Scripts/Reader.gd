extends Node2D
class_name MainScript


var pg = 0
var ZoomH = 600
#ZoomH = max(LeftMinS.y, RightMinS.y)/600.0
#Zoom is the maximum height of the minSize of the 2 textureRects/ 600
var CenterMarg


#The largest ImageTexture in the Image dictionary
var ImageLeft = Image.new()
var ImageRight = Image.new()
#Last global mouse position on zoom

onready var Mouse = $Mouse
onready var MouseSprite = $Mouse/Sprite
onready var Paper = $CenterContainer/CenterContainer/Paper
onready var HBox = $CenterContainer/CenterContainer/HBoxContainer
onready var ButtLeft = $CenterContainer/CenterContainer/HBoxContainer/PageLeft/ButtLeft
onready var ButtRight = $CenterContainer/CenterContainer/HBoxContainer/PageRight/ButtRight
onready var PageLeft = $CenterContainer/CenterContainer/HBoxContainer/PageLeft
onready var PageRight = $CenterContainer/CenterContainer/HBoxContainer/PageRight 
onready var CameraM = $CenterContainer/Camera2D

var Zooming = false
var ZoomMax = Vector2(ZoomH, ZoomH)
var ZoomSpeed = Vector2(0.002 * ZoomH, 0.002 * ZoomH)
var ZoomMin = Vector2(0.01 + ZoomSpeed.x * 0.20, 0.01 + ZoomSpeed.y * 0.20)
onready var DesZoom = Vector2.ZERO

func move_to_mouse():
	CameraM.position = lerp(CameraM.position, Mouse.position, 0.5)

func apply_margins():
	CenterMarg = PageLeft.rect_min_size.x * 0.03
	HBox.set("custom_constants/separation", CenterMarg)

func confirm_folder(path):
	var dir = Directory.new()
	if dir.dir_exists(path):
		print("File already exists")
	if not dir.dir_exists(path):
		dir.open("res://")
		dir.make_dir(path)
		print("File created")

func apply_images():
	var TextureLeft = ImageTexture.new()
	var TextureRight = ImageTexture.new()
	
	#loads images from dictionary
	ImageLeft.load("res://images/" + Global.ImageDict[Global.Order[pg]])
	ImageRight.load("res://images/" + Global.ImageDict[Global.Order[pg + 1]])
	
	var LeftMinS = Vector2(ImageLeft.get_width(), ImageLeft.get_height())
	var RightMinS = Vector2(ImageRight.get_width(), ImageRight.get_height())
	
	#Finds largest and smallest height and width between the 2 images
	var HLarge : float = max(ImageLeft.get_height(), ImageRight.get_height())
	var WLarge : float = max(ImageLeft.get_width(), ImageRight.get_width())
	var HSmall : float = min(ImageLeft.get_height(), ImageRight.get_height())
	var WSmall : float = min(ImageLeft.get_width(), ImageRight.get_width())
	#Vector2 with largest dimensions
	var HWLarge = Vector2(HLarge, WLarge)
	#if left is largest
	if HWLarge == Vector2(ImageLeft.get_height(), ImageLeft.get_width()):
		var NewH = ImageRight.get_height() * min(HLarge/HSmall, WLarge/WSmall)
		var NewW = ImageRight.get_width() * min(HLarge/HSmall, WLarge/WSmall)
		RightMinS = Vector2(NewW, NewH)
	#if right is largest
	if HWLarge == Vector2(ImageRight.get_height(), ImageRight.get_width()):
		var NewH = ImageLeft.get_height() * min(HLarge/HSmall, WLarge/WSmall)
		var NewW = ImageLeft.get_width() * min(HLarge/HSmall, WLarge/WSmall)
		LeftMinS = Vector2(NewW, NewH)
		
	#creates textures from the images
	TextureLeft.create_from_image(ImageLeft)
	TextureRight.create_from_image(ImageRight)
	
	PageLeft.texture = TextureLeft
	PageRight.texture = TextureRight
	#Set TextureRect min size here
	PageLeft.rect_min_size = LeftMinS
	PageRight.rect_min_size = RightMinS

	#Gets value for zoom
	ZoomH = max(LeftMinS.y, RightMinS.y)/600.0
	#Set button size
	ButtLeft.rect_size = LeftMinS
	ButtRight.rect_size = RightMinS

func paper_size():
	Paper.rect_min_size = \
	Vector2(max(PageLeft.rect_min_size.x, PageRight.rect_min_size.x) * 2 + 3 * CenterMarg, \
	max(PageLeft.rect_min_size.y, PageRight.rect_min_size.y) + 2 * CenterMarg)
	#Paper.rect_min_size = Vector2(LargestPG.x/ZoomH, LargestPG.y)
	
func mouse_resize():
	MouseSprite.scale = Vector2(ZoomH/5, ZoomH/5)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	confirm_folder("res://images")
	#image folder is found or created

	apply_images()

	apply_margins()
	
	paper_size()
	
	mouse_resize()
	
	DesZoom = Vector2(ZoomH, ZoomH)
	ZoomMax = Vector2(ZoomH, ZoomH)
	ZoomSpeed = Vector2(0.1 * ZoomH, 0.1 * ZoomH)
	
func _process(_delta):
	if CameraM.zoom.x != abs(CameraM.zoom.x):
		CameraM.zoom = ZoomMin
	#Corrects the camera if it has a negative zoom
	if CameraM.zoom != DesZoom:
		CameraM.zoom = lerp(CameraM.zoom, DesZoom, 0.2 )
	#smooths zooming with lerp function

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().change_scene("res://Scenes/Menu.tscn")
#quit program with escape, can put other keys here
func _input(event):
	if event.is_action_pressed("page_left"):
		_on_ButtLeft_pressed()
	if event.is_action_pressed("page_right"):
		_on_ButtRight_pressed()
	if event is InputEventMouseButton:
		if event.is_pressed():
			#zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				Zooming = true
				move_to_mouse()
				#Close Mode
				if CameraM.zoom < ZoomMin + ZoomSpeed * 2:
					print("close mode activated")
					if DesZoom > ZoomMin and DesZoom - ZoomSpeed * 0.20 > ZoomMin:
						DesZoom -= 0.20 * ZoomSpeed
					if DesZoom < ZoomMin:
						print ("past ZoomMin")
					else:
						DesZoom = ZoomMin
				#Far Mode
				else:
					if DesZoom > ZoomMin and DesZoom - ZoomSpeed > ZoomMin:
						DesZoom -= ZoomSpeed
					else:
						DesZoom = ZoomMin
				yield(get_tree().create_timer(0.2), "timeout")
				Zooming = false
			#zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				#Close Mode
				if CameraM.zoom < ZoomMin + ZoomSpeed * 2:
					if DesZoom >= ZoomMin:
						DesZoom += 0.20 * ZoomSpeed
					else:
						DesZoom.zoom = ZoomMin
				#Far Mode
				else:
					if DesZoom < ZoomMax and DesZoom != -ZoomSpeed:
						DesZoom += ZoomSpeed
					elif DesZoom == -ZoomSpeed:
						CameraM.zoom = ZoomMin

#zooms camera with scroll wheel
func _on_ButtLeft_pressed():
	if pg != 0:
		pg -= 2
		apply_images()
		apply_margins()
		paper_size()
		mouse_resize()
		ZoomMax = Vector2(ZoomH, ZoomH)
		ZoomSpeed = Vector2(0.2 * ZoomH, 0.2 * ZoomH)
		if CameraM.zoom > ZoomMax:
			DesZoom = ZoomMax

func _on_ButtRight_pressed():
	if pg != Global.Order.size() - 2:
		pg += 2
		apply_images()
		apply_margins()
		paper_size()
		mouse_resize()
		ZoomMax = Vector2(ZoomH, ZoomH)
		ZoomSpeed = Vector2(0.2 * ZoomH, 0.2 * ZoomH)
		if CameraM.zoom > ZoomMax:
			DesZoom = ZoomMax

