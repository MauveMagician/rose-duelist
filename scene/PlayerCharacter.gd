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

func _ready():
	pass
	
func dash():
	motion.y = 0
	motion.x = 0
	dashing = true
	gravity = false
	$DashTiming.start()

func get_input():
	if Input.is_action_just_pressed("dash"):
		if is_on_floor():
			airdash = false
		else:
			airdash = true
		dash()
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1,0)
		motion.x = horizontalSpeed
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1,0)
		motion.x = -horizontalSpeed
	else:
		motion.x = 0
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			motion.y = verticalSpeed
			if dashing:
				gravity = true
	if Input.is_action_just_released("jump"):
		if motion.y < GRAVITY_SPEED:
			motion.y = GRAVITY_SPEED

func _physics_process(delta):
	if gravity:
		motion.y -= GRAVITY_SPEED
	if dashing:
		motion.x = direction.x * dashSpeed
		motion.y = direction.y * dashSpeed
	elif not $DashStopping.is_stopped():
		motion.x += direction.x * 10
	else:
		get_input()
	motion = move_and_slide(motion, FLOOR_NORMAL)

func _on_DashTiming_timeout():
	gravity = true
	dashing = false
	airdash = false
	$DashStopping.start()

func _on_DashStopping_timeout():
	pass