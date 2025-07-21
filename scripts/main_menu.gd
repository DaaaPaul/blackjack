extends Node3D

signal play
var playing := false

func _input(event):
	if event is InputEventMouseMotion and playing == false:
		%Camera3D.rotation_degrees.y -= event.relative.x * 0.005
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.005
		%Camera3D.rotation_degrees.y = clamp(%Camera3D.rotation_degrees.y, -5.0, 5.0)
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -57.75, -52.75)

func _process(delta: float) -> void:
	if playing == false:
		if !%BGSound.playing:
			%BGSound.play()

		var rand_addition := randf()
		if(rand_addition >= 0.975):
			%Blackjack.visible = false
			await get_tree().create_timer(0.5).timeout
			if(playing == false):
				%Blackjack.visible = true
	
		
func _on_start() -> void:
	playing = true
	%Blackjack.visible = false
	%MainMenuUI.visible = false
	
	var x_pos_diff = abs(0.431 - %Camera3D.position.x)
	var y_pos_diff = abs(1.192 - %Camera3D.position.y)
	var z_pos_diff = abs(1.711 - %Camera3D.position.z)
	var x_rot_diff = abs(-40.9 - %Camera3D.rotation_degrees.x)
	var y_rot_diff = abs(39.0 - %Camera3D.rotation_degrees.y)
	
	while %Camera3D.position.x < 0.431 and %Camera3D.position.y < 1.192 and %Camera3D.position.z < 1.711 and %Camera3D.rotation_degrees.x < -40.9 and %Camera3D.rotation_degrees.y < 39.0:
		%Camera3D.position.x += x_pos_diff / 100.0
		%Camera3D.position.y += y_pos_diff / 100.0
		%Camera3D.position.z += z_pos_diff / 100.0
		%Camera3D.rotation_degrees.x += x_rot_diff / 100.0
		%Camera3D.rotation_degrees.y += y_rot_diff / 100.0
		%BGSound.volume_db -= 0.3
		await get_tree().create_timer(0.01).timeout
	
	play.emit()

func _play() -> void:
	%SpotLight3D.light_energy = 2.0
	%ThumpSound.play()
	await %ThumpSound.finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
