extends TextureRect

@onready var Player = $Player
@onready var Scenario = $FightScenario

func _ready():
	Player.set_movement_area(Scenario.get_movement_rect())
