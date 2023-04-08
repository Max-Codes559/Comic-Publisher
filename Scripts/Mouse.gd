extends Node2D



func _process(_delta):
	if get_parent().Zooming == false:
		position = get_global_mouse_position()
	#else:
		#Input.warp_mouse_position(self.position)
		#get_viewport().warp_mouse(self.position)

