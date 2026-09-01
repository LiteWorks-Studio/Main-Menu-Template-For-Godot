extends Control

@onready var play_button: Button = $CenterContainer/MenuPanel/PlayButton
@onready var options_button: Button = $CenterContainer/MenuPanel/OptionsButton
@onready var credits_button: Button = $CenterContainer/MenuPanel/CreditsButton
@onready var quit_button: Button = $CenterContainer/MenuPanel/QuitButton
@onready var title: Label = $CenterContainer/MenuPanel/TitlePanel/TitleMargin/Title
@onready var subtitle: Label = $CenterContainer/MenuPanel/Subtitle
@onready var menu_panel: VBoxContainer = $CenterContainer/MenuPanel

var title_bounce_tween: Tween
var button_tweens: Dictionary = {}
var idle_animation_timer: Timer
var current_hovered_button: Button = null

func _ready():
	idle_animation_timer = Timer.new()
	idle_animation_timer.wait_time = 0.5
	idle_animation_timer.timeout.connect(_on_idle_animation_timer_timeout)
	add_child(idle_animation_timer)
	idle_animation_timer.start()
	
	_connect_button_animations(play_button)
	_connect_button_animations(options_button)
	_connect_button_animations(credits_button)
	_connect_button_animations(quit_button)
	
	_play_entrance_animation()
	_start_idle_animations()

func _connect_button_animations(button: Button):
	button.mouse_entered.connect(_on_button_hover.bind(button))
	button.mouse_exited.connect(_on_button_unhover.bind(button))
	button.button_down.connect(_on_button_press.bind(button))
	button.button_up.connect(_on_button_release.bind(button))

func _play_entrance_animation():
	menu_panel.modulate.a = 0.0
	
	var entrance_tween = create_tween()
	entrance_tween.set_trans(Tween.TRANS_QUAD)
	entrance_tween.set_ease(Tween.EASE_OUT)
	entrance_tween.tween_property(menu_panel, "modulate:a", 1.0, 0.6)
	
	title.scale = Vector2(0.1, 0.1)
	title.pivot_offset = title.size / 2
	var title_tween = create_tween()
	title_tween.set_trans(Tween.TRANS_BOUNCE)
	title_tween.set_ease(Tween.EASE_OUT)
	title_tween.tween_property(title, "scale", Vector2(1.0, 1.0), 0.8)
	
	var buttons = [play_button, options_button, credits_button, quit_button]
	for i in range(buttons.size()):
		var button = buttons[i]
		button.modulate.a = 0.0
		button.scale = Vector2(0.5, 0.5)
		button.pivot_offset = button.size / 2
		
		var button_tween = create_tween()
		button_tween.set_trans(Tween.TRANS_BACK)
		button_tween.set_ease(Tween.EASE_OUT)
		button_tween.tween_interval(i * 0.1)
		button_tween.tween_property(button, "modulate:a", 1.0, 0.4)
		button_tween.parallel().tween_property(button, "scale", Vector2(1.0, 1.0), 0.5)

func _start_idle_animations():
	var title_scale_tween = create_tween()
	title_scale_tween.set_loops()
	title_scale_tween.set_trans(Tween.TRANS_SINE)
	title_scale_tween.set_ease(Tween.EASE_IN_OUT)
	title_scale_tween.tween_property(title, "scale", Vector2(1.05, 1.05), 1.5)
	title_scale_tween.tween_property(title, "scale", Vector2(1.0, 1.0), 1.5)
	
	var subtitle_tween = create_tween()
	subtitle_tween.set_loops()
	subtitle_tween.set_trans(Tween.TRANS_SINE)
	subtitle_tween.set_ease(Tween.EASE_IN_OUT)
	subtitle_tween.tween_property(subtitle, "modulate:a", 0.5, 1.0)
	subtitle_tween.tween_property(subtitle, "modulate:a", 1.0, 1.0)

func _on_button_hover(button: Button):
	current_hovered_button = button
	
	if button_tweens.has(button):
		button_tweens[button].kill()
	
	button.pivot_offset = button.size / 2
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2(1.15, 1.15), 0.2)
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.1)
	button_tweens[button] = tween
	
	var rotation_tween = create_tween()
	rotation_tween.set_trans(Tween.TRANS_SINE)
	rotation_tween.set_ease(Tween.EASE_IN_OUT)
	rotation_tween.tween_property(button, "rotation_degrees", 3, 0.08)
	rotation_tween.tween_property(button, "rotation_degrees", -3, 0.16)
	rotation_tween.tween_property(button, "rotation_degrees", 2, 0.12)
	rotation_tween.tween_property(button, "rotation_degrees", -2, 0.1)
	rotation_tween.tween_property(button, "rotation_degrees", 0, 0.08)

func _on_button_unhover(button: Button):
	if current_hovered_button == button:
		current_hovered_button = null
	
	if button_tweens.has(button):
		button_tweens[button].kill()
	
	button.pivot_offset = button.size / 2
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(button, "rotation", 0.0, 0.1)
	button_tweens[button] = tween

func _on_button_press(button: Button):
	button.pivot_offset = button.size / 2
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(0.85, 0.8), 0.08)

func _on_button_release(button: Button):
	button.pivot_offset = button.size / 2
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.25)
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.15)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

func _on_idle_animation_timer_timeout():
	if randf() < 0.15 and current_hovered_button == null:
		var buttons = [play_button, options_button, credits_button, quit_button]
		var random_button = buttons[randi() % buttons.size()]
		
		random_button.pivot_offset = random_button.size / 2
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(random_button, "scale", Vector2(1.05, 1.05), 0.15)
		tween.tween_property(random_button, "scale", Vector2(1.0, 1.0), 0.15)

func _on_play_button_pressed():
	_play_transition_animation(play_button)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://MainMenu/testscene.tscn")

func _on_options_button_pressed():
	_play_transition_animation(options_button)
	await get_tree().create_timer(0.3).timeout
	pass

func _on_credits_button_pressed():
	_play_transition_animation(credits_button)
	await get_tree().create_timer(0.3).timeout
	pass

func _on_quit_button_pressed():
	_play_transition_animation(quit_button)
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _play_transition_animation(button: Button):
	button.pivot_offset = button.size / 2
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(button, "scale", Vector2(1.5, 1.5), 0.2)
	tween.parallel().tween_property(button, "modulate:a", 0.0, 0.2)
	
	var fade_tween = create_tween()
	fade_tween.set_trans(Tween.TRANS_QUAD)
	fade_tween.set_ease(Tween.EASE_IN)
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.3)

func _exit_tree():
	if title_bounce_tween:
		title_bounce_tween.kill()
	for tween in button_tweens.values():
		if tween:
			tween.kill()
