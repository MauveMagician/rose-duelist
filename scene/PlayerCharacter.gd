extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0,-1)
const GRAVITY_SPEED = -40
export var verticalSpeed = -1000
export var horizontalSpeed = 500
export var dashSpeed = 1000
var motion = Vector2()
var direction = Vector2()
var immune = false
var dashing = false
var airdash = false
var gravity = true
var facing = 1
var dashCooldown = false
var fireCooldown = false
var anim = "Idle"
var playerNumber = 1
var stop = false
var c_up
var c_down
var c_left
var c_right
var c_fire
var c_jump
var c_dash

signal scattered

func _ready():
	pass

func setController(control_type):
	if Preloader.current_mode == "VS_CPU":
		for s in InputMap.get_action_list("ui_up_2"):
			InputMap.action_add_event("ui_up", s)
		for s in InputMap.get_action_list("ui_down_2"):
			InputMap.action_add_event("ui_down", s)
		for s in InputMap.get_action_list("ui_left_2"):
			InputMap.action_add_event("ui_left", s)
		for s in InputMap.get_action_list("ui_right_2"):
			InputMap.action_add_event("ui_right", s)
		for s in InputMap.get_action_list("jump_2"):
			InputMap.action_add_event("jump", s)
		for s in InputMap.get_action_list("dash_2"):
			InputMap.action_add_event("dash", s)
		for s in InputMap.get_action_list("fire_2"):
			InputMap.action_add_event("fire", s)
	if playerNumber == 2:
		$Sprite.frames = load("res://scene/PlayerCharacter2.tres")
		facing = -1
		$Sprite.flip_h = true
		$GunPivot.rotation_degrees = correct_rotation()
	if control_type == "keyboard1":
		if Preloader.p2Control == "keyboard2":
			c_up = "ui_up_1_alt"
			c_down = "ui_down_1_alt"
			c_left = "ui_left_1_alt"
			c_right = "ui_right_1_alt"
			c_fire = "fire_1_alt"
		else:
			c_up = "ui_up"
			c_down = "ui_down"
			c_left = "ui_left"
			c_right = "ui_right"
			c_fire = "fire"
		c_jump = "jump"
		c_dash = "dash"
	elif control_type == "gamepad1":
		c_up = "ui_up_2"
		c_down = "ui_down_2"
		c_left = "ui_left_2"
		c_right = "ui_right_2"
		c_fire = "fire_2"
		c_jump = "jump_2"
		c_dash = "dash_2"
	if control_type == "keyboard2":
		c_up = "ui_up_3"
		c_down = "ui_down_3"
		c_left = "ui_left_3"
		c_right = "ui_right_3"
		c_fire = "fire_3"
		c_jump = "jump_3"
		c_dash = "dash_3"
	elif control_type == "gamepad2":
		c_up = "ui_up_4"
		c_down = "ui_down_4"
		c_left = "ui_left_4"
		c_right = "ui_right_4"
		c_fire = "fire_4"
		c_jump = "jump_4"
		c_dash = "dash_4"

func correct_rotation():
	if facing == -1:
		return 180
	else:
		return 0

func hit():
	if not immune:
		get_parent().slow()
		get_parent().shake(0.5, 25, 25, 1)
		var new = Preloader.petals.instance()
		new.position = global_position
		get_parent().add_child(new)
		emit_signal("scattered")
		queue_free()
	else:
		pass

func dash():
	immune = true
	dashCooldown = true
	dashing = true
	gravity = false
	$DashTiming.start()

func animate():
	if not stop:
		if dashing:
			return "Airborn"
		if Input.is_action_pressed(c_right):
			$Sprite.flip_h = false
			if is_on_floor():
				return "Walk"
			else:
				return "Idle"
		elif Input.is_action_pressed(c_left):
			$Sprite.flip_h = true
			if is_on_floor():
				return "Walk"
			else:
				return "Idle"
		elif Input.is_action_pressed(c_up):
			return "Aim_up"
		elif Input.is_action_pressed(c_down) and not is_on_floor():
			return "Aim_down"
		else:
			return "Idle"
	return "Idle"

func get_input():
	if not stop:
		if Input.is_action_just_pressed(c_fire) and not fireCooldown:
			Shot.play()
			var new = Preloader.bullet.instance()
			new.position = $GunPivot/Gun.global_position
			new.rotation = $GunPivot.global_rotation
			var flash = Preloader.muzzleFlash.instance()
			flash.position = $GunPivot/Gun.global_position
			flash.rotation = $GunPivot.global_rotation
			get_parent().add_child(flash)
			get_parent().add_child(new)
			get_parent().shake()
			$FireCooldown.start()
			fireCooldown = true
		if Input.is_action_just_pressed(c_dash) and not dashCooldown:
			DashSound.play()
			if is_on_floor():
				airdash = false
				direction.y = 0
			else:
				airdash = true
			if Input.is_action_pressed(c_up):
				direction = Vector2(0,-1)
			elif Input.is_action_pressed(c_down):
				direction = Vector2(0,1)
			else:
				direction.y = 0
			dash()
		if Input.is_action_pressed(c_up):
			$GunPivot.rotation_degrees = -90
		elif Input.is_action_pressed(c_down):
			if not is_on_floor():
				$GunPivot.rotation_degrees = +90
			else:
				$GunPivot.rotation_degrees = correct_rotation()
		else:
			$GunPivot.rotation_degrees = correct_rotation()
		if Input.is_action_pressed(c_right):
			direction.x = 1
			facing = 1
			$GunPivot.rotation_degrees = correct_rotation()
			motion.x = horizontalSpeed
		elif Input.is_action_pressed(c_left):
			direction.x = -1
			facing = -1
			$GunPivot.rotation_degrees = correct_rotation()
			motion.x = -horizontalSpeed
		else:
			motion.x = 0
		if Input.is_action_just_pressed(c_jump):
			if is_on_floor():
				motion.y = verticalSpeed
		if Input.is_action_just_released(c_jump):
			if motion.y < GRAVITY_SPEED:
				motion.y = GRAVITY_SPEED
		if direction == Vector2(0,0):
			direction = facing * Vector2(1,0)
			$GunPivot.rotation_degrees = correct_rotation()

func _physics_process(delta):
	if gravity:
		motion.y -= GRAVITY_SPEED
	if dashing:
		motion = direction * dashSpeed
	elif not $DashStopping.is_stopped():
		motion.x += direction.x * dashSpeed/50
	else:
		get_input()
		$Sprite.animation = animate()
	motion = move_and_slide(motion, FLOOR_NORMAL)

func _on_DashTiming_timeout():
	gravity = true
	dashing = false
	airdash = false
	immune = false
	$DashStopping.start()

func _on_DashStopping_timeout():
	$DashCooldown.start()

func _on_DashCooldown_timeout():
	dashCooldown = false

func _on_FireCooldown_timeout():
	fireCooldown = false

func _on_Stomped_area_entered(area):
	if area != $Stomped and area.name == "Stomper":
		hit()
