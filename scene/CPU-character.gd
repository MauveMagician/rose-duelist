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
var facing = -1
var dashCooldown = false
var fireCooldown = false
var anim = "Idle"
var state = "left"
var playerNumber = 2
var stop = true

signal scattered

func _ready():
	randomize()

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
	if not stop:
		immune = true
		dashCooldown = true
		dashing = true
		gravity = false
		$DashTiming.start()

func animate():
	if dashing:
		return "Airborn"
	if state == "right":
		$Sprite.flip_h = false
		return "Idle"
	elif state == "left":
		$Sprite.flip_h = true
		return "Idle"
	elif state == "up":
		return "Aim_up"
	elif state == "down":
		return "Aim_down"
	else:
		return "Idle"

func fire():
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

func find_safe_dir():
	var dir = Vector2(int(rand_range(-1.9,1.9)),int(rand_range(-1.9,1.9)))
	for c in $AI_Areas.get_children():
		if c.is_class("Area_2D"):
			if c.get_overlapping_bodies().empty():
				dir = Vector2(c.get_child("Position2D").global_position
				- self.global_position).normalized()
	return dir

func ai_cycle():
	if not stop:
		if state == "Idle":
			$GunPivot.rotation_degrees = correct_rotation()
		elif state == "right":
			direction.x = 1
			facing = 1
			$GunPivot.rotation_degrees = correct_rotation()
			motion.x = horizontalSpeed
		elif state == "left":
			direction.x = -1
			facing = -1
			$GunPivot.rotation_degrees = correct_rotation()
			motion.x = -horizontalSpeed
		if not fireCooldown:
			fire()

func _physics_process(delta):
	if gravity:
		motion.y -= GRAVITY_SPEED
	if dashing:
		motion = direction * dashSpeed
	elif not $DashStopping.is_stopped():
		motion.x += direction.x * dashSpeed/50
	else:
		ai_cycle()
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

func _on_AreaUp_body_entered(body):
	if body.has_method("hit"):
		state = "up"
		$GunPivot.rotation_degrees = -90
	elif body.has_method("explode") and not dashCooldown:
		direction = find_safe_dir()
		dash()

func _on_AreaLeft_body_entered(body):
	if not dashing:
		if body.has_method("hit"):
			state = "left"
			$GunPivot.rotation_degrees = correct_rotation()
			facing = 1
		elif body.has_method("explode") and not dashCooldown:
			direction = find_safe_dir()
			dash()
		elif body.has_method("explode") and not fireCooldown:
			state = "left"
			$GunPivot.rotation_degrees = correct_rotation()
			facing = 1
			fire()

func _on_AreaRight_body_entered(body):
	if not dashing:
		if body.has_method("hit"):
			state = "right"
			$GunPivot.rotation_degrees = correct_rotation()
			facing = -1
		elif body.has_method("explode") and not dashCooldown:
			direction = find_safe_dir()
			dash()
		elif body.has_method("explode") and not fireCooldown:
			state = "right"
			$GunPivot.rotation_degrees = correct_rotation()
			facing = -1
			fire()

func _on_AreaDown_body_entered(body):
	if not dashing:
		if body.has_method("hit"):
			state = "down"
			$GunPivot.rotation_degrees = 90
		elif body.has_method("explode") and not dashCooldown:
			direction = find_safe_dir()
			dash()

func _on_DownRight_body_entered(body):
	if not dashing:
		if body.has_method("hit") and not dashCooldown:
			direction = Vector2(self.global_position - body.global_position).normalized()
			dash()

func _on_AreaUpRight_body_entered(body):
	if not dashing:
		if body.has_method("hit") and not dashCooldown:
			direction = find_safe_dir()
			dash()

func _on_AreaDownLeft_body_entered(body):
	if not dashing:
		if body.has_method("hit") and not dashCooldown:
			direction = Vector2(self.global_position - body.global_position).normalized()
			dash()

func _on_AreaUpLeft_body_entered(body):
	if not dashing:
		if body.has_method("hit") and not dashCooldown:
			direction = find_safe_dir()
			dash()
