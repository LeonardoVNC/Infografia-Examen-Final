extends TextureRect

@onready var Player = $Player
@onready var FightOptions = $FightOptions
@onready var Scenario = $Scenario

enum states {PREPARATION, PLAYER_TURN, ATTACK, DIALOGUE}
#TODO luego hay que hacer la preparación como tal
var state = states.PLAYER_TURN

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Action"):
		FightOptions.execute_option()
		return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x == -1:
			_option_left()
		else:
			_option_right()
			
func _option_left():
	FightOptions.option_left()

func _option_right():
	FightOptions.option_right()
