extends Node3D

const card_options := ["clubs_01", "clubs_02", "clubs_03", "clubs_04", "clubs_05", "clubs_06", "clubs_07", "clubs_08", "clubs_09", "clubs_10", "clubs_11", "clubs_12", "clubs_13",
					 "spades_01", "spades_02", "spades_03", "spades_04", "spades_05", "spades_06", "spades_07", "spades_08", "spades_09", "spades_10", "spades_11", "spades_12", "spades_13",
					 "hearts_01", "hearts_02", "hearts_03", "hearts_04", "hearts_05", "hearts_06", "hearts_07", "hearts_08", "hearts_09", "hearts_10", "hearts_11", "hearts_12", "hearts_13",
					 "diamonds_01", "diamonds_02", "diamonds_03", "diamonds_04", "diamonds_05", "diamonds_06", "diamonds_07", "diamonds_08", "diamonds_09", "diamonds_10", "diamonds_11", "diamonds_12", "diamonds_13"]
var card1 := load("res://scenes/cards/" + card_options[randi_range(0, 51)] + ".tscn")
var card2 := load("res://scenes/cards/" + card_options[randi_range(0, 51)] + ".tscn")

func _ready() -> void:
	instantiate(card1, Vector3(0.015, 0.015, 0.015), Vector3(0.313, 0.87, 1.415), Vector3(0.0, 31.0, 0.0))
	instantiate(card2, Vector3(0.015, 0.015, 0.015), Vector3(0.425, 0.87, 1.351), Vector3(0.0, 31.0, 0.0))

func _process(delta: float) -> void:
	if !%BGSound.playing:
		%BGSound.play()

func instantiate(scene: Resource, scale: Vector3, position: Vector3, rotation_degrees: Vector3) -> void:
	var instance = scene.instantiate()
	instance.scale = scale
	instance.position = position
	instance.rotation_degrees = rotation_degrees
	add_child(instance)
