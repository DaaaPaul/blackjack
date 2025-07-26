extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Quit"):
		get_tree().quit()
