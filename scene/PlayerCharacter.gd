extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0,-1)
const GRAVITY_SPEED = -40
export var verticalSpeed = -1000
export var horizontalSpeed = 500
export var dashSpeed = 1000
var motion = Vector2()
var direction = Vector2()
var dashing = false
var airdash = false
var gravity = true
var facing = -1
var dashCooldown = false
var fireCooldown = false

func _ready():
	pass

func correct_rotation():
	if facing == -1:
		return 180
	else:
		return 0

func hit():
	pass

func dash():
	dashCooldown = true
	dashing = true
	gravity = false
	$DashTiming.start()

func get_input():
	if Input.is_action_just_pressed("fire") and not fireCooldown:
		var new = Preloader.bullet.instance()
		new.position = $GunPivot/Gun.global_position
		new.rotation = $GunPivot.global_rotation
		var flash = Preloader.muzzleFlash.instance()
		flash.position = $GunPivot/Gun.global_position
		flash.rotation = $GunPivot.global_rotation
		get_parent().add_child(flash)
		get_parent().add_child(new)
		$FireCooldown.start()
		fireCooldown = true
	if Input.is_action_just_pressed("dash") and not dashCooldown:
		if is_on_floor():
			airdash = false
			direction.y = 0
		else:
			airdash = true
		if Input.is_action_pressed("ui_up"):
			direction = Vector2(0,-1)
		elif Input.is_action_pressed("ui_down"):
			direction = Vector2(0,1)
		else:
			direction.y = 0
		dash()
	if Input.is_action_pressed("ui_up"):
		$GunPivot.rotation_degrees = -90
	elif Input.is_action_pressed("ui_down"):
		if not is_on_floor():
			$GunPivot.rotation_degrees = +90
		else:
			$GunPivot.rotation_degrees = correct_rotation()
	else:
		$GunPivot.rotation_degrees = correct_rotation()
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		facing = 1
		$GunPivot.rotation_degrees = correct_rotation()
		motion.x = horizontalSpeed
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
		facing = -1
		$GunPivot.rotation_degrees = correct_rotation()
		motion.x = -horizontalSpeed
	else:
		motion.x = 0
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			motion.y = verticalSpeed
	if Input.is_action_just_released("jump"):
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
	motion = move_and_slide(motion, FLOOR_NORMAL)

func _on_DashTiming_timeout():
	gravity = true
	dashing = false
	airdash = false
	$DashStopping.start()

func _on_DashStopping_timeout():
	$DashCooldown.start()

func _on_DashCooldown_timeout():
	dashCooldown = false

func _on_FireCooldown_timeout():
	fireCooldown = false

func _on_SlowdownArea_area_entered(area):
	if area != $SlowdownArea and area.name == "SlowdownArea":
		Engine.time_scale = 0.5

func _on_SlowdownArea_area_exited(area):
	if area != $SlowdownArea and area.name == "SlowdownArea":
		Engine.time_scale = 1