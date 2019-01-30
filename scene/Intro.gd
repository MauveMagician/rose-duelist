extends Node

onready var texts = ["After school, the bells started to toll. I was invited by letter to a dangerous game, on the rose garden.",
"Two duelists would fire at each other with special guns, guns that can scatter souls, like flowers in a field",
"This dangerous contest has an ante. Win, and you get to rebuild yourself, to whoever you want to be! To whoever you were! Lose, and be scattered, to be born again at another time",
"You are determined that it is your own fire that will bring change to your life. The challenge is accepted! You'll bloom in supreme nobility, or scatter in sublime beauty"]
var textindex = 0
var finale = false

func _ready():
	$Images.get_child(textindex).visible = true
	$Control/NinePatchRect/Label.text = texts[textindex]

func _on_TextTick_timeout():
	if $Control/NinePatchRect/Label.percent_visible < 1.0:
		$Control/NinePatchRect/Label.visible_characters += 1
	else:
		$TextTick.stop()

func _input(event):
	if finale:
		var is_event_press = event is InputEventKey
		var is_other_press = event is InputEventMouseButton or event is InputEventJoypadButton
		if (is_event_press and not event.echo) and (is_event_press and event.pressed) or is_other_press and event.pressed:
			$FadeInLayer/FadeIn.show()
			$FadeInLayer/FadeIn.fade_in()
			get_tree().get_root().set_disable_input(true)
			yield(get_tree().create_timer(1.5), 'timeout')
			get_tree().get_root().set_disable_input(false)
			get_tree().change_scene("res://scene/MainMenu.tscn")
	var is_event_press = event is InputEventKey
	var is_other_press = event is InputEventMouseButton or event is InputEventJoypadButton
	if (is_event_press and not event.echo) and (is_event_press and event.pressed) or is_other_press and event.pressed:
		if $Control/NinePatchRect/Label.percent_visible < 1.0:
			$Control/NinePatchRect/Label.percent_visible = 1.0
		else:
			$TextTick.start()
			if textindex < 3:
				$Images.get_child(textindex).visible = false
				textindex += 1
				$Images.get_child(textindex).visible = true
				$Control/NinePatchRect/Label.text = texts[textindex]
				$Control/NinePatchRect/Label.percent_visible = 0
			else:
				finale = true