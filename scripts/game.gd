extends TextureRect

@onready var Player = $Player
@onready var FightOptions = $FightOptions
@onready var Scenario = $Scenario
@onready var OptionTimer = $OptionTimer

enum states {PREPARATION, PLAYER_TURN, ATTACK, DIALOGUE}
var state = states.PREPARATION
var can_change_option = true

func _ready() -> void:
	FightOptions.hide()
	FightOptions.fight.connect(_on_option_fight)
	FightOptions.act.connect(_on_option_act)
	FightOptions.item.connect(_on_option_item)
	FightOptions.mercy.connect(_on_option_mercy)

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
		
	if Input.is_action_just_pressed("Back"):
		FightOptions.go_back()
		return	
	
	if (can_change_option):
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_axis("ui_left", "ui_right")
		input_vector = input_vector.normalized()
		
		OptionTimer.start(0.12)
		can_change_option = false
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
	
func _on_option_fight():
	print("El jugador golpea aaaa")
	
func _on_option_act():
	print("El jugador debe actuar wiii")
	
func _on_option_item():
	print("el jugador debe comer alguito")

func _on_option_mercy():
	print("el jugador perdona")

func _on_option_timer_timeout() -> void:
	can_change_option = true
