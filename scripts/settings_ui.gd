extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Controls"):
		if self.visible:
			get_tree().paused = false
			self.visible = false
		else:
			get_tree().paused = true
			self.visible = true
