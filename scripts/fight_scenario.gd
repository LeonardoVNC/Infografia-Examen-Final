extends Node2D

@onready var Soul = $Soul
@onready var Sans = $Sans
@onready var Scenario = $Scenario
@onready var AttacksManager = $AttacksManager

var tanda_timer = 0.0
var tanda_interval = 1.5
var attack_in_progress = false

# Funciones para el scenario
func set_new_turn(turn: int, isBlue: bool):
	var size = _get_scenario_size(turn)
	Scenario.set_scenario_size(size)
	Scenario.show();
	Soul.set_new_turn(isBlue);
	set_attack(turn, size)
	tanda_timer = 0
	attack_in_progress = false

func finish_turn():
	Scenario.hide()
	Soul.disable()
	AttacksManager.reset_all_bones()
	attack_in_progress = false

func on_death():
	Sans.hide()
	Scenario.hide()
	AttacksManager.hide()
	
func _get_scenario_size(turn: int) -> Vector2:
	match turn:
		0,1,2,3,4,5,6,8,10,11,12,13:
			#Comunes
			return Vector2(300,140)
		7,9:
			#Plataformas sin suelo (?)
			return Vector2(340,160)
		15,19:
			#Gaster Blasters
			return Vector2(350,170)
		17,18,20,22:
			#Gravity! y circulitos
			return Vector2(160,160)
	# Turnos con cambio en medio turno: 14, 16, 21, 23, requiere mayor detenimiento, de momento el basico
	# 14: 310,130?  > 280, 130 > 310,130 I > 280,130
	# 16: 310,130 > 220,160 > 160,160 > 310,130 > 160,160 
	# 21: 310, 130 > 280, 130 I > 310, 130 I > 220,160
	# 23: 160,160 I > X, 145 > 160,160 hasta acabar
		14,16,21:
			return Vector2(310,130)
		23, _:
			return Vector2(160,160)

func set_attack (turn: int, size: Vector2):
	AttacksManager.set_scenario_size(size)
	match turn:
		1,10:
			AttacksManager.start_attack("basic_jump")
		2:
			AttacksManager.start_attack("lateral_blue")
		3,12:
			AttacksManager.start_attack("random_basic_jump")
		11:
			AttacksManager.start_attack("lateral_jump")
		_:
			var attacks = ["basic_jump", "lateral_blue", "random_basic_jump", "lateral_jump"]
			var random_attack = attacks[randi() % attacks.size()]
			AttacksManager.start_attack(random_attack)
	
# Funciones para Sans
func sans_dodge():
	Sans.dodge()
