extends Node2D

@onready var Soul = $Soul
@onready var Sans = $Sans
@onready var Scenario = $Scenario
	
# Funciones para el scenario
func set_new_turn(size: Vector2, isBlue: bool):
	Scenario.set_scenario_size(size)
	Scenario.show();
	Soul.set_new_turn(isBlue);

func finish_turn():
	Scenario.hide()
	Soul.disable()

# Funciones para Sans
func sans_dodge():
	Sans.dodge()
