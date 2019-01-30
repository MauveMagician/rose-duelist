extends Control

var scene_path_to_load

func _ready():
	get_tree().get_root().set_disable_input(false)
	InputMap.load_from_globals()
	$Menu/Button.grab_focus()
	$Menu/Button.connect("pressed", self, "_on_Button_pressed", [$Menu/Button.scene_to_load])
	Preloader.score1 = 0
	Preloader.score2 = 0
	for b in $Playmode.get_children():
		if b.name != "back":
			b.connect("pressed", self, "_on_Button_pressed", [b.scene_to_load])


func _on_Button_pressed(scene_to_load):
	if scene_to_load:
		get_tree().get_root().set_disable_input(true)
		$FadeIn.show()
		$FadeIn.fade_in()
		BGMPlayer.play()
		scene_path_to_load = scene_to_load


func _on_FadeIn_fade_finished():
	$FadeIn.hide()
	if scene_path_to_load:
		get_tree().change_scene(scene_path_to_load)

func _on_fullscreen_pressed():
	if not OS.window_fullscreen:
		OS.window_fullscreen = true
		$Options/fullscreen/Label.text = "Windowed"
	else:
		OS.window_fullscreen = false
		$Options/fullscreen/Label.text = "Fullscreen"

func _on_Button3_pressed():
	$Menu.visible = false
	$Options.visible = true
	$Options/fullscreen.grab_focus()

func _on_back_pressed():
	$Menu.visible = true
	$Playmode.visible = false
	$Options.visible = false
	$Menu/Button.grab_focus()

func _on_Button2_pressed():
	$Menu.visible = false
	$Playmode.visible = true
	$Playmode/KBvsController.grab_focus()

func _on_KBvsController_pressed():
	Preloader.current_mode = "KB_VS_CONTROLLER"
	Preloader.p1Control = "keyboard1"
	Preloader.p2Control = "gamepad1"

func _on_ControllervsController_pressed():
	Preloader.current_mode = "CONTROLLER_VS_CONTROLLER"
	Preloader.p1Control = "gamepad1"
	Preloader.p2Control = "gamepad2"

func _on_KBvsKB_pressed():
	Preloader.current_mode = "KB_VS_KB"
	Preloader.p1Control = "keyboard1"
	Preloader.p2Control = "keyboard2"

func _on_Button4_pressed():
	get_tree().get_root().set_disable_input(true)
	$FadeIn.show()
	$FadeIn.fade_in()
	yield(get_tree().create_timer(0.4), 'timeout')
	get_tree().quit()

func _on_Button5_pressed():
	$Instructions.visible = true
	$Menu.visible = false
