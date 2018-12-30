extends Node

var bullet
var trail
var muzzleFlash

func _ready():
	bullet = preload("res://scene/Bullet.tscn")
	trail = preload("res://scene/Trail.tscn")
	muzzleFlash = preload("res://scene/MuzzleFlash.tscn")