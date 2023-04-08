extends Camera2D

const MaxSpeed = 20

func _process(_delta):
	if Input.is_action_pressed("left"):
		position.x -= MaxSpeed
	if Input.is_action_pressed("right"):
		position.x += MaxSpeed 
	if Input.is_action_pressed("up"):
		position.y -= MaxSpeed
	if Input.is_action_pressed("down"):
		position.y += MaxSpeed 
