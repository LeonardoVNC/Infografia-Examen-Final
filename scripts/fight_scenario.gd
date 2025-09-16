extends Node2D

@onready var Soul = $Soul
@onready var Sans = $Sans
@onready var Scenario = $Scenario
@onready var AttacksManager = $AttacksManager
	
# Funciones para el scenario
func set_new_turn(size: Vector2, isBlue: bool):
	Scenario.set_scenario_size(size)
	Scenario.show();
	Soul.set_new_turn(isBlue);
	AttacksManager.spawn_bones_pattern()

func finish_turn():
	Scenario.hide()
	Soul.disable()

func on_death():
	Sans.hide()
	Scenario.hide()
	AttacksManager.hide()

# Funciones para Sans
func sans_dodge():
	Sans.dodge()
