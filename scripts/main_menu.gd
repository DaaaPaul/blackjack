extends Node3D

var playing = false

func _input(event):
	if event is InputEventMouseMotion and playing == false:
		%Camera3D.rotation_degrees.y -= event.relative.x * 0.005
		%Camera3D.rotation_degrees.z += event.relative.y * 0.005
		%Camera3D.rotation_degrees.y = clamp(%Camera3D.rotation_degrees.y, -5.25, 5.25)
		%Camera3D.rotation_degrees.z = clamp(%Camera3D.rotation_degrees.z, -4.0, 4.0)

func _process(delta: float) -> void:
	if !%BGSound.playing:
		%BGSound.play()
		
func _on_play_pressed() -> void:
	playing = true
	%"Main Menu UI".visible = false
	%Blackjack.visible = false
	%SpotLight3D.light_energy = 2.0
	
	var x_pos_diff = abs(0.431 - %Camera3D.position.x)
	var y_pos_diff = abs(1.192 - %Camera3D.position.y)
	var z_pos_diff = abs(1.711 - %Camera3D.position.z)
	var x_rot_diff = abs(-40.9 - %Camera3D.rotation_degrees.x)
	var y_rot_diff = abs(39.0 - %Camera3D.rotation_degrees.y)
	
	while %Camera3D.position.x < 0.431 and %Camera3D.position.y < 1.192 and %Camera3D.position.z < 1.711 and %Camera3D.rotation_degrees.x < -40.9 and %Camera3D.rotation_degrees.y < 39.0:
		%Camera3D.position.x += x_pos_diff / 100
		%Camera3D.position.y += y_pos_diff / 100
		%Camera3D.position.z += z_pos_diff / 100
		%Camera3D.rotation_degrees.x += x_rot_diff / 100
		%Camera3D.rotation_degrees.y += y_rot_diff / 100
		await get_tree().create_timer(0.01).timeout
