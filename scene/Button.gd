extends Button

export (String) var scene_to_load
export (String) var label_text

func _ready():
	$Label.text = label_text