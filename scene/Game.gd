extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_WrapAreaW_body_entered(body):
	if not body.is_class("StaticBody2D"):
		body.position = Vector2(get_viewport().size.x,body.position.y)

func _on_WrapAreaE_body_entered(body):
	if not body.is_class("StaticBody2D"):
		body.position = Vector2(0,body.position.y)
