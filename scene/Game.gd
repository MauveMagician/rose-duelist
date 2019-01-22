extends Node

func _ready():
	var final = false
	Engine.time_scale = 1
	if(Preloader.score1 >= 2 or Preloader.score2 >= 2):
		$Sky.texture = load("res://sprite/skybox-dusk.png")
		$CanvasModulate.visible = true
		if (not Catharsis.playing) and (Preloader.score1 == 2 and Preloader.score2 == 2):
			BGMPlayer.stop()
			final = true
	var player1 = Preloader.player.instance()
	player1.position = Vector2(230, 490)
	player1.playerNumber = 1
	self.add_child(player1)
	if Preloader.current_mode != "VS_CPU":
		var player2 = Preloader.player.instance()
		player2.position = Vector2(800, 490)
		player2.playerNumber = 2
		self.add_child(player2)
	else:
		var playercpu = Preloader.cpuChar.instance()
		playercpu.position = Vector2(800, 490)
		playercpu.facing = 1
		self.add_child(playercpu)
	for c in get_children():
		if c.get("playerNumber") != null:
			c.stop = true
			c.connect("scattered", self, "_on_scattered", [c.playerNumber])
	if final:
		yield(get_tree().create_timer(1), 'timeout')
		$UILayer/Control/c3.visible = false
		Catharsis.play()
		var finale = Preloader.finalscene.instance()
		$UILayer/Control.add_child(finale)
		yield(finale.get_child(2), 'timeout')
		$UILayer/Control/c3.visible = true
	yield(get_tree().create_timer(1), 'timeout')
	$UILayer/Control/c3.visible = false
	$UILayer/Control/c2.visible = true
	yield(get_tree().create_timer(1), 'timeout')
	$UILayer/Control/c2.visible = false
	$UILayer/Control/c1.visible = true
	yield(get_tree().create_timer(1), 'timeout')
	$UILayer/Control/c1.visible = false
	$UILayer/Control/Fire.visible = true
	yield(get_tree().create_timer(0.25), 'timeout')
	$UILayer/Control/Firetimer.start()
	for c in get_children():
		if c.get("playerNumber") != null:
			c.stop = false

func _on_scattered(arg):
	lose(arg)

func lose(arg):
	$UILayer/WinnerScreen.visible = true
	if arg == 1:
		Preloader.score2 += 1
	if arg == 2:
		Preloader.score1 += 1
	for c in get_children():
		if c.has_method("explode"):
			c.explode()
		elif c.get("playerNumber") != null:
			c.motion = Vector2(0,0)
			c.stop = true
			c.anim = "Idle"
			c.immune = true

	yield(get_tree().create_timer(1), 'timeout')
	$UILayer/WinnerScreen/HBoxContainer1.visible = true
	$UILayer/WinnerScreen/HBoxContainer2.visible = true
	for s1 in range(1,Preloader.score1):
		$UILayer/WinnerScreen/HBoxContainer1/RoundMarkers.get_child(s1).visible = true
	if arg == 1:
		$UILayer/WinnerScreen/HBoxContainer1/RoundMarkers.get_child(Preloader.score1).visible = true
	
	for s2 in range(1,Preloader.score2):
		$UILayer/WinnerScreen/HBoxContainer2/RoundMarkers.get_child(s2).visible = true
	if arg == 2:
		$UILayer/WinnerScreen/HBoxContainer2/RoundMarkers.get_child(Preloader.score2).visible = true

	yield(get_tree().create_timer(1), 'timeout')
	if arg == 2:
		$UILayer/WinnerScreen/HBoxContainer1/RoundMarkers.get_child(Preloader.score1).visible = true
	if arg == 1:
		$UILayer/WinnerScreen/HBoxContainer2/RoundMarkers.get_child(Preloader.score2).visible = true
	yield(get_tree().create_timer(1), 'timeout')
	if Preloader.score1 <= 2 and Preloader.score2 <= 2:
		get_tree().change_scene("res://scene/Game.tscn")
	else:
		$FadeInLayer/FadeIn.show()
		$FadeInLayer/FadeIn.fade_in()
		yield(get_tree().create_timer(2), 'timeout')
		BGMPlayer.stop()
		Catharsis.stop()
		get_tree().change_scene("res://scene/MainMenu.tscn")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func slow():
	for c in get_children():
		if c.has_method("hit"):
			c.immune = true
	Engine.time_scale = 0.25
	yield(get_tree().create_timer(0.5), 'timeout')
	Engine.time_scale = 1

func shake(_duration = 0.1, _frequency = 50, _amplitude = 20, _priority=0):
	$Camera2D/ScreenShake.start(_duration, _frequency, _amplitude, _priority)

func _on_WrapAreaW_body_entered(body):
	if not body.is_class("StaticBody2D"):
		body.position = Vector2(get_viewport().size.x,body.position.y)

func _on_WrapAreaE_body_entered(body):
	if not body.is_class("StaticBody2D"):
		body.position = Vector2(0,body.position.y)

func _on_Firetimer_timeout():
	$UILayer/Control/Fire.visible = false
