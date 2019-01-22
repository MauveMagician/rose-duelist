extends Node

onready var texts = ["After school. The bells will soon toll. I was invited by letter to a dangerous game, on the rose garden.",
"Two duelists would fire at each other with special guns, guns that can scatter souls, like flowers in a field",
"The dangerous game has an ante. Win, and you get to restore yourself, to whoever you want to be! To whoever you were! Lose, and you are a flower, scattered to be born again at another time, who knows when",
"You are determined that it is your own fire that will bring your life revolution. The challenge is accepted! You'll bloom in supreme nobility, or scatter in supreme beauty"]
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
		if Input.is_action_just_pressed("fire") or Input.is_action_just_pressed("fire_2") or Input.is_action_just_pressed("fire_3"):
			$FadeInLayer/FadeIn.show()
			$FadeInLayer/FadeIn.fade_in()
			yield(get_tree().create_timer(1.5), 'timeout')
			get_tree().change_scene("res://scene/MainMenu.tscn")
	if Input.is_action_just_pressed("fire") or Input.is_action_just_pressed("fire_2") or Input.is_action_just_pressed("fire_3"):
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