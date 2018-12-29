extends KinematicBody2D

var forward_motion = Vector2()
var speed = 1500
var forward = false

func _ready():
	add_collision_exception_with(self)
	pass

func _physics_process(delta):
	var new = Preloader.trail.instance()
	new.global_position = self.global_position
	get_parent().add_child(new)
	forward_motion = Vector2(1,0).rotated(rotation) * speed
	forward_motion = move_and_slide(forward_motion)

func explode():
	pass

func _on_Hurtbox_body_entered(body):
	if body == self:
		return
	if body.has_method("hit"):
		body.hit()
		queue_free()
	elif body.has_method("explode"):
		queue_free()