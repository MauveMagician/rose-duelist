extends Node

func _ready():
	get_tree().paused = false
	Engine.time_scale = 1

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func slow():
	for c in get_children():
		if c.has_method("hit"):
			c.immune = true
	Engine.time_scale = 0.125

func shake(_duration = 0.1, _frequency = 50, _amplitude = 20, _priority=0):
	$Camera2D/ScreenShake.start(_duration, _frequency, _amplitude, _priority)

func _on_WrapAreaW_body_entered(body):
	if not body.is_class("StaticBody2D"):
		body.position = Vector2(get_viewport().size.x,body.position.y)

func _on_WrapAreaE_body_entered(body):
	if not body.is_class("StaticBody2D"):
		body.position = Vector2(0,body.position.y)
