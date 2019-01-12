extends Node

func _process(delta):
	get_input()

func get_input():
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false
	if Input.is_action_just_pressed("retry"):
		get_tree().change_scene("res://scene/Game.tscn")