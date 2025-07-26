extends Node3D

const card_list := {"clubs_01": 1, "clubs_02": 2, "clubs_03": 3, "clubs_04": 4, "clubs_05": 5, "clubs_06": 6, "clubs_07": 7, "clubs_08": 8, "clubs_09": 9, "clubs_10": 10, "clubs_11": 10, "clubs_12": 10, "clubs_13": 10,
					 "spades_01": 1, "spades_02": 2, "spades_03": 3, "spades_04": 4, "spades_05": 5, "spades_06": 6, "spades_07": 7, "spades_08": 8, "spades_09": 9, "spades_10": 10, "spades_11": 10, "spades_12": 10, "spades_13": 10,
					 "hearts_01": 1, "hearts_02": 2, "hearts_03": 3, "hearts_04": 4, "hearts_05": 5, "hearts_06": 6, "hearts_07": 7, "hearts_08": 8, "hearts_09": 9, "hearts_10": 10, "hearts_11": 10, "hearts_12": 10, "hearts_13": 10,
					 "diamonds_01": 1, "diamonds_02": 2, "diamonds_03": 3, "diamonds_04": 4, "diamonds_05": 5, "diamonds_06": 6, "diamonds_07": 7, "diamonds_08": 8, "diamonds_09": 9, "diamonds_10": 10, "diamonds_11": 10, "diamonds_12": 10, "diamonds_13": 10}
var inventory_cards: Array[Node3D] = []
var inventory_strings: Array[String] = []
const base_position := Vector3(0.4, 0.873, 1.415)
const base_rotation := Vector3(0.0, 31.0, 0.0)
var offset_right := Vector3(0.055, 0.0, -0.033)
var offset_left := Vector3(-0.055, 0.0, 0.033)

var dealer_cards: Array[Node3D] = []
var dealer_strings: Array[String] = []
const dealer_position := Vector3(0.0, 0.873, 1.135)
const dealer_rotation := Vector3(0.0, 0.0, 0.0)
var dealer_right := Vector3(0.065, 0.0, 0.0)
var dealer_left := Vector3(-0.065, 0.0, 0.0)

const base_scale := Vector3(0.015, 0.015, 0.015)
var stood: Array[bool] = [false, false]
var alternating := true
var won := false
var lost := false
var your_turn := false
var dealers_turn := false
var tie := false
static var wins := 0
static var losses := 0
static var ties := 0
static var first_time := true

func _ready() -> void:
	upstart()

func _process(delta: float) -> void:
	if !lost and !won and !tie:
		if !%BGSound.playing:
			%BGSound.play()
			
	if your_turn:
		flash(%YourTurn)
	elif dealers_turn:
		flash(%DealersTurn)
	elif lost or won or tie:
		dealer_cards[0].rotation_degrees.z = 0.0
		flash(%Restart)

func _input(event: InputEvent) -> void:
	if your_turn:
		if event.is_action_pressed("Hit"):
			add_card(base_position, base_rotation, false)
			stood[0] = false
		if event.is_action_pressed("Stand"):
			%Stand.play()
			await get_tree().create_timer(0.2).timeout
			%Stand.play()
			stood[0] = true
			if stood[0] and stood[1]:
				check_winner()
			else:
				change_to_dealers_turn()

	if lost or won or tie:
		if event.is_action_pressed("Restart"):
			get_tree().reload_current_scene()

func upstart() -> void:	
	%Score.text = str(wins) + " wins\n" + str(losses) + " losses\n" + str(ties) + " draws"
	if first_time:
		%Score.modulate.a = 0.0
		while %Score.modulate.a < 1.0:
			%Score.modulate.a += 0.01
			await get_tree().create_timer(0.01).timeout
		first_time = false
	
	add_card(base_position, base_rotation, false)
	await get_tree().create_timer(0.5).timeout
	add_card(base_position, base_rotation, false)
	await get_tree().create_timer(0.5).timeout
	add_card(dealer_position, dealer_rotation + Vector3(0.0, 0.0, -180.0), true)
	await get_tree().create_timer(0.5).timeout
	add_card(dealer_position, dealer_rotation, true)
	await get_tree().create_timer(0.5).timeout
	change_to_your_turn()

func add_card(pos: Vector3, rot: Vector3, dealer: bool) -> void:
	var odd := false
	var card_name: String = card_list.keys()[randi_range(0, 51)]
	var addition_card := load("res://scenes/cards/" + card_name + ".tscn")
	var addition: Node3D = addition_card.instantiate()
	
	if !dealer:
		for card in inventory_cards:
			if card.position.x > pos.x:
				card.position += offset_right
			elif card.position.x < pos.x:
				card.position += offset_left
			else:
				card.position += offset_right
				odd = true
		
		inventory_cards.append(addition)
		inventory_strings.append(card_name)
		
		if odd:
			trans(addition, base_scale, pos + offset_left, rot)
		else:
			trans(addition, base_scale, pos, rot)
	else:
		for card in dealer_cards:
			if card.position.x > pos.x :
				card.position += dealer_right
			elif card.position.x < pos.x:
				card.position += dealer_left
			else:
				card.position += dealer_right
				odd = true
		
		dealer_cards.append(addition)
		dealer_strings.append(card_name)
		
		if odd:
			trans(addition, base_scale, pos + dealer_left, rot)
		else:
			trans(addition, base_scale, pos, rot)
	
	add_child(addition)
	
	if alternating:
		%CardPlace1.play()
		alternating = !alternating
	else:
		%CardPlace2.play()
		alternating = !alternating

func adjust_turns() -> void:
	if your_turn:
		%YourTurn.visible = true
		%DealersTurn.visible = false
		%Restart.visible = false	
	elif dealers_turn:
		%DealersTurn.visible = true
		%YourTurn.visible = false
		%Restart.visible = false
		
		await get_tree().create_timer(1 + 2 * randf()).timeout
		
		var points := 0
		var player_points := 0
		for card in dealer_strings:
			points += card_list[card]
		for card in inventory_strings:
			player_points += card_list[card]
		
		if points <= 21 and player_points <= 21:
			if points >= player_points and stood[0]:
				stood[1] = true
				%Stand.play()
				await get_tree().create_timer(0.2).timeout
				%Stand.play()
			elif points < player_points or points <= 15 or (points == player_points and points <= 17):
				add_card(dealer_position, dealer_rotation, true)
				stood[1] = false
			else:
				stood[1] = true
				%Stand.play()
				await get_tree().create_timer(0.2).timeout
				%Stand.play()
		elif (player_points > 21 and points <= 21) or (points > 21 and player_points <= 21):
			stood[1] = true
			%Stand.play()
			await get_tree().create_timer(0.2).timeout
			%Stand.play()
		elif player_points > 21 and points > 21:
			stood[1] = true
			%Stand.play()
			await get_tree().create_timer(0.2).timeout
			%Stand.play()
			
		if stood[0] and stood[1]:
			check_winner()
		else:
			change_to_your_turn()
	elif lost or won or tie:
		%Restart.visible = true
		%YourTurn.visible = false
		%DealersTurn.visible = false

func check_winner() -> void:
	if return_winner() == 0:
		change_to_tie()
		tie_screen()
	elif return_winner() == 1:
		change_to_lost()
		lost_screen()
	elif return_winner() == 2:
		change_to_won()
		won_screen()

func return_winner() -> int:
	var sum := 0
	var dealer_sum := 0
	
	for card in inventory_strings:
		sum += card_list[card]
	for card in dealer_strings:
		dealer_sum += card_list[card]
		
	if sum == dealer_sum:
		return 0
	elif sum > 21 and dealer_sum <= 21:
		return 1
	elif dealer_sum > 21 and sum <= 21:
		return 2
	elif sum > 21 and dealer_sum > 21:
		if sum > dealer_sum:
			return 1
		else:
			return 2
	elif sum <= 21 and dealer_sum <= 21:
		if sum > dealer_sum:
			return 2
		else:
			return 1
	else:
		return 404
		
func lost_screen() -> void:
	losses += 1
	%Grayscale.visible = true
	%Lost.play()
	%BGSound.stop()
	%Score.text = str(wins) + " wins\n" + str(losses) + " losses\n" + str(ties) + " draws"
	
	while true:
		%Camera3D.position.y += 0.001
		%Camera3D.position.z += 0.001
		%Camera3D.rotation_degrees.y -= 0.01
		%Camera3D.rotation_degrees.z -= 0.01
		await get_tree().create_timer(0.01).timeout

func won_screen() -> void:
	wins += 1
	%Won.play()
	%BGSound.stop()
	%Score.text = str(wins) + " wins\n" + str(losses) + " losses\n" + str(ties) + " draws"

func tie_screen() -> void:
	ties += 1
	%Tie.play()
	%BGSound.stop()
	%Score.text = str(wins) + " wins\n" + str(losses) + " losses\n" + str(ties) + " draws"

func change_to_dealers_turn() -> void:
	dealers_turn = true
	your_turn = false
	won = false
	lost = false
	tie = false
	adjust_turns()
	
func change_to_your_turn() -> void:
	your_turn = true
	dealers_turn = false
	won = false
	lost = false
	tie = false
	adjust_turns()
	
func change_to_lost() -> void:
	lost = true
	your_turn = false
	dealers_turn = false
	won = false
	tie = false
	adjust_turns()
	
func change_to_won() -> void:
	won = true
	lost = false
	your_turn = false
	dealers_turn = false
	tie = false
	adjust_turns()

func change_to_tie() -> void:
	tie = true
	won = false
	lost = false
	your_turn = false
	dealers_turn = false
	adjust_turns()

func trans(card: Node3D, scale: Vector3, pos: Vector3, rot: Vector3) -> void:
	card.scale = scale
	card.position = pos
	card.rotation_degrees = rot

func flash(text: Label) -> void:
	var rand_addition: float = 0.0
	
	if text.modulate.a > 0.65:
		rand_addition = (randf() - 0.55) / 10.0
		text.modulate.a += rand_addition
	else:
		rand_addition = (randf() - 0.45) / 10.0
		text.modulate.a += rand_addition
