extends Control

signal start
var started := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !started and !event.is_action_pressed("Quit") and !event.is_action_pressed("Controls"):
		%BeepBeep.play()
		start.emit()
		started = true

func _process(delta: float) -> void:
	var rand_addition: float = 0.0
	
	if(%Text.modulate.a > 0.65):
		rand_addition = (randf() - 0.55) / 10.0
		%Text.modulate.a += rand_addition
	else:
		rand_addition = (randf() - 0.45) / 10.0
		%Text.modulate.a += rand_addition
