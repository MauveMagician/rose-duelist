extends Node

var bullet
var poof
var trail
var muzzleFlash
var petals
var cpuChar
var player
var finalscene
var score1 = 0
var score2 = 0
var p1Control = "keyboard1"
var p2Control = "gamepad1"
var current_mode = "VS_CPU"

func reset_score():
	score1 = 0
	score2 = 0

func _ready():
	bullet = preload("res://scene/Bullet.tscn")
	trail = preload("res://scene/Trail.tscn")
	muzzleFlash = preload("res://scene/MuzzleFlash.tscn")
	poof = preload("res://scene/BulletPoof.tscn")
	petals = preload("res://scene/petals.tscn")
	cpuChar = preload("res://scene/CPU-character.tscn")
	player = preload("res://scene/PlayerCharacter.tscn")
	finalscene = preload("res://scene/Finalscene.tscn")