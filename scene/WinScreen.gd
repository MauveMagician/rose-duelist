extends Node

onready var texts = ["Now that I remade myself, I think I'll finally rest and relax for a bit. Sometimes, taking it easy for a while is not the problem I thought it was, but an amazing solution."]

func _ready():
	if Preloader.score1 >= Preloader.score2:
		$ColorRect/TextureRect/TextureRect2.visible = true
		$ColorRect/Label.text = texts[0]
	else:
		$ColorRect/TextureRect/TextureRect3.visible = true
		$ColorRect/Label.text = texts[1]
	$TextTick.start()

func _on_TextTick_timeout():
	if $ColorRect/Label.percent_visible < 1.0:
		$ColorRect/Label.visible_characters += 1
	else:
		$TextTick.stop()

func _input(event):
	var is_event_press = event is InputEventKey
	var is_other_press = event is InputEventMouseButton or event is InputEventJoypadButton
	if $ColorRect/Label.percent_visible == 1.0:
		if (is_event_press and not event.echo) and (is_event_press and event.pressed) or is_other_press and event.pressed:
			$FadeInLayer.show()
			$FadeInLayer.fade_in()
			get_tree().get_root().set_disable_input(true)
			yield(get_tree().create_timer(1.5), 'timeout')
			get_tree().get_root().set_disable_input(false)
			BGMPlayer.stop()
			Catharsis.stop()
			get_tree().change_scene("res://scene/MainMenu.tscn")
	elif (is_event_press and not event.echo) and (is_event_press and event.pressed) or is_other_press and event.pressed:
		$ColorRect/Label.percent_visible = 1.0