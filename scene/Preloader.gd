extends Node

var bullet
var trail

func _ready():
	bullet = preload("res://scene/Bullet.tscn")
	trail = preload("res://scene/Trail.tscn")