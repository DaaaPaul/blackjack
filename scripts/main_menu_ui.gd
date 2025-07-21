extends Control

signal start
@onready var hover_sound = get_node("HoverSound")
@onready var click_sound = get_node("ClickSound")
var alpha := 0.65
var started := false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !started:
		%BeepBeep.play()
		start.emit()
		started = true

func _process(delta: float) -> void:
	var rand_addition = (randf() - 0.5) / 10.0
	alpha += rand_addition
	alpha = clamp(alpha, 0.0, 1.0)
	%PressAnyKey.modulate = Color(1.0, 1.0, 1.0, alpha)

func _on_play_pressed() -> void:
	click_sound.play()

func _on_play_mouse_entered() -> void:
	hover_sound.play()

func _on_shop_pressed() -> void:
	click_sound.play()

func _on_shop_mouse_entered() -> void:
	hover_sound.play()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_mouse_entered() -> void:
	hover_sound.play()
