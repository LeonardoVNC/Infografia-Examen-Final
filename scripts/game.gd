extends TextureRect

@onready var Player = $Player
@onready var FightOptions = $FightOptions
@onready var Scenario = $Scenario

enum states {PREPARATION, PLAYER_TURN, ATTACK, DIALOGUE}
var state = states.PREPARATION

func _ready() -> void:
	FightOptions.hide()

func _physics_process(delta: float) -> void:
	match state:
		states.PREPARATION:
			preparation_state()
		states.PLAYER_TURN:
			player_turn_state()
		states.ATTACK:
			player_turn_state()
		states.DIALOGUE:
			dialogue_state()

func preparation_state():
	#TODO - Pensar si aqui ponemos los primeros dialogos igual o q onda
	if Input.is_action_just_pressed("Action"):
		print("Cambiando a ataque aaa")
		FightOptions.show()
		#TODO - De hecho toda esta etapa es... rara... pasamos de dialogo a ataque a dialogo a turno
		# piensalo mejor, pero, más adelante, de momento esto safa dx
		state = states.PLAYER_TURN
	
func player_turn_state():
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
	
func attack_state():
	print("Aun nos falta la preparación dx")
	
func dialogue_state():
	print("Aun nos falta la preparación dx")


func _option_left():
	FightOptions.option_left()

func _option_right():
	FightOptions.option_right()
