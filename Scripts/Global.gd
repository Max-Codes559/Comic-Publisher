extends Node

var ImageDict = {}
var LargestPG = Vector2(0, 0)

var Order = []

func dir_contents(path):
	var n = 0
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			elif file_name.get_extension().to_lower() == "jpg" or file_name.get_extension().to_lower() == "png" or file_name.get_extension().to_lower() == "jpeg":
				print("Found file: " + file_name)
				ImageDict[n] = file_name
				n += 1
				var image = ImageTexture.new()
				image.load("res://images/" + file_name)
				if image.get_width() > LargestPG.x:
					LargestPG.x = image.get_width()
				if image.get_height() > LargestPG.y:
					LargestPG.y = image.get_height()
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
		
func create_order():
	Order = ImageDict.keys()
	
func _ready():
	dir_contents("res://images")
	create_order()
	#prints name of files in image folder, adds files to dictionary but not folders
