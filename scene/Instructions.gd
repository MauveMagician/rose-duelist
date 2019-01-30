extends ColorRect

func _input(event):
	if self.visible:
		var is_event_press = event is InputEventKey
		var is_other_press = event is InputEventMouseButton or event is InputEventJoypadButton
		if (is_event_press and not event.echo) and (is_event_press and event.pressed) or is_other_press and event.pressed:
			self.visible = false
			get_parent().find_node("Menu").find_node("Button5").grab_focus()
			get_parent().find_node("Menu").visible = true