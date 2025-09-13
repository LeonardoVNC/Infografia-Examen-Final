extends TextureRect

@onready var Player = $Soul
@onready var FightOptions = $FightUI
@onready var Scenario = $Scenario
@onready var OptionTimer = $OptionTimer
@onready var AnimTimer = $AnimTimer
@onready var AnimTree = $AnimationTree
@onready var AnimStates = $AnimationTree.get("parameters/playback")
@onready var UpperBox = $FightUI/VBox/UpperBox
@onready var BackAudio = $BackgroundAudioPlayer

enum states {PREPARATION, PLAYER_TURN, ATTACK, DIALOGUE}
enum animStates {REST, KNIFE, MISS, DMG}
var state = states.PREPARATION
var animState = animStates.REST
var can_change_option = true
var items: Array[String] = ["Fideos", "Pie", "Héroe Leg.", "Héroe Leg.", "Héroe Leg."]

func _ready() -> void:
	FightOptions.hide()
	FightOptions.item.connect(_on_option_item)
	UpperBox.inputAttack.connect(_on_attack_ready)
	FightOptions.set_items(items)

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

# Funciones para el primer turno
func preparation_state():
	#TODO - Pensar si aqui ponemos los primeros dialogos igual o q onda
	if Input.is_action_just_pressed("Action"):
		print("Cambiando a ataque aaa")
		FightOptions.show()
		#TODO - De hecho toda esta etapa es... rara... pasamos de dialogo a ataque a dialogo a turno
		# piensalo mejor, pero, más adelante, de momento esto safa dx
		_set_player_turn_state()
		BackAudio.play()

# Funciones para el turno del jugador
func _set_player_turn_state():
	Player.disable()
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
		input_vector.y = Input.get_axis("ui_up", "ui_down")
		input_vector = input_vector.normalized()
		
		OptionTimer.start(0.12)
		can_change_option = false
		if input_vector != Vector2.ZERO:
			if input_vector.x == -1:
				_option_left()
			elif input_vector.x == 1:
				_option_right()
			elif input_vector.y == -1:
				_option_up()
			else:
				_option_down()

func _option_left():
	FightOptions.option_left()

func _option_right():
	FightOptions.option_right()
	
func _option_down():
	FightOptions.option_down()

func _option_up():
	FightOptions.option_up()

func _on_option_timer_timeout() -> void:
	can_change_option = true

func _on_option_item(item_name):
	print("el jugador debe comer alguito:", item_name)

func _on_attack_ready():
	AnimStates.travel("KnifeAttack")
	animState = animStates.KNIFE
	#TODO - tambien hay q decirle al esqueleto loco q se mueva pa ete lao
	AnimTimer.start(0.6)

func _on_anim_timer_timeout() -> void:
	match animState:
		animStates.KNIFE:
			#TODO - hay que diferenciar entre los primeros turnos y el final
			AnimStates.travel("Miss")
			animState = animStates.MISS
			AnimTimer.start(1.8)
		animStates.MISS:
			_on_fight_ui_ready_to_close()
	
func _on_fight_ui_ready_to_close() -> void:
	FightOptions.set_sans_attack()
	
	#TODO - Mostrar el Scenario
	_set_attack_state()

# Funciones para el turno del esqueleto ketchup
func _set_attack_state():
	Player.able()
	state = states.ATTACK

func attack_state():
	print("Aun nos falta la preparación dx")

# Funciones para cuando habla el esqueleto ketchup
func dialogue_state():
	print("Aun nos falta la preparación dx")
