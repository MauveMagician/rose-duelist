extends Node

var bullet
var poof
var trail
var muzzleFlash
var petals

func _ready():
	bullet = preload("res://scene/Bullet.tscn")
	trail = preload("res://scene/Trail.tscn")
	muzzleFlash = preload("res://scene/MuzzleFlash.tscn")
	poof = preload("res://scene/BulletPoof.tscn")
	petals = preload("res://scene/petals.tscn")