extends Control

func _on_VisibilityTimer_timeout():
	if $ColorRect/Label.percent_visible < 1:
		$ColorRect/Label.visible_characters += 1

func _on_Lifespam_timeout():
	queue_free()
