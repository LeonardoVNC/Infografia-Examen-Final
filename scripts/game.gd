extends TextureRect

@onready var FightOptions = $FightUI
@onready var Scenario = $FightScenario
@onready var Player = $FightScenario/Soul
@onready var AnimTree = $Utils/AnimationTree
@onready var AnimStates = $Utils/AnimationTree.get("parameters/playback")
@onready var OptionTimer = $Utils/OptionTimer
@onready var AnimTimer = $Utils/AnimTimer
@onready var BackAudio = $Utils/BackgroundAudioPlayer
@onready var UpperBox = $FightUI/VBox/UpperBox

enum states {PREPARATION, PLAYER_TURN, ATTACK, DIALOGUE}
enum animStates {REST, KNIFE, MISS, DMG}
var state = states.PREPARATION
var animState = animStates.REST
var can_change_option = true
var turn = 0

var items_data = {
	"Fideos Inst.": {
		"hp_recover": 90,
		"message": "Están mejor crudos."
	},
	"Tarta": {
		"hp_recover": 92,
		"message": "Te comes la tarta."
	},
	"Filete": {
		"hp_recover": 60,
		"message": "Te comes el Filete con Cara."
	},
	"Héroe L.": {
		"hp_recover": 40,
		"message": "Te comes el Héroe Legendario."
	},
	"Trozo Nieve": {
		"hp_recover": 45,
		"message": "Te has comido el Trozo del Muñeco de Nieve."
	}
}
var items: Array[String] = ["Fideos Inst.", "Tarta", "Filete", "Héroe L.", "Trozo Nieve", "Trozo Nieve"]

func _ready() -> void:
	FightOptions.hide()
	FightOptions.item.connect(_on_option_item)
	UpperBox.inputAttack.connect(_on_attack_ready)
	Player.hp_changed.connect(_on_hp_changed)
	Player.death.connect(_on_player_death)
	FightOptions.set_items(items)

func _physics_process(delta: float) -> void:
	match state:
		states.PREPARATION:
			preparation_state()
		states.PLAYER_TURN:
			player_turn_state()
		states.ATTACK:
			attack_state()
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
	Scenario.finish_turn()
	state = states.PLAYER_TURN
	_set_description_new_turn()
	
func _set_description_new_turn():
	var text
	var current_hp = Player.hp
	if (turn == 0):
		text = Globals.descriptions_1st[0]
	elif (turn == 1):
		text = Globals.descriptions_1st[1]
	elif (turn == 4):
		text = Globals.descriptions_1st[2]
	elif (turn == 9):
		text = Globals.descriptions_1st[3]
	elif (turn == 13):
		text = Globals.descriptions_1st[4]
	elif (turn == 14):
		text = Globals.descriptions_2nd[0]
	elif (turn == 18):
		text = Globals.descriptions_2nd[2]
	elif (turn >= 20):
		text = Globals.descriptions_2nd[3]
	elif (turn == 23):
		text = Globals.descriptions_2nd[4]
	elif (turn > 14):
		text = Globals.descriptions_2nd[1]
	elif (current_hp < 20):
		text = Globals.hp_descriptions[3]
	elif (current_hp < 35):
		text = Globals.hp_descriptions[2]
	elif (current_hp < 50):
		text = Globals.hp_descriptions[1]
	else:
		text = Globals.hp_descriptions[0]
	FightOptions._set_new_turn(text)

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

func _on_option_item(item_index):
	if item_index < 0 or item_index >= items.size():
		return
	var item_name = items[item_index]
	if not items_data.has(item_name):
		print("No pusiste este item en tu diccionario muchacho: ", item_name)
		return
		
	var hp_recover = items_data[item_name]["hp_recover"]
	var message = items_data[item_name]["message"]
	
	var isHpFilled = Player.recover_hp(hp_recover)
	
	var text
	if (isHpFilled):
		text = "* Tus HP se has rellenado."
	else:
		text = "* ¡Has recuperado %d HP!"%hp_recover
	
	#FightOptions.set_bottom()
	FightOptions.set_description("%s\n%s" %[message,text])
	items.remove_at(item_index)
	FightOptions.set_items(items)

func _on_attack_ready():
	turn += 1
	print("Avanzando al turno ", turn)
	AnimStates.travel("KnifeAttack")
	animState = animStates.KNIFE
	Scenario.sans_dodge()
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
	_set_attack_state()

# Funciones para el turno del esqueleto ketchup
func _set_attack_state():
	var scenarioSize = _get_scenario_size()
	var isPlayerBlue = _get_player_mode_blue()
	Scenario.set_new_turn(scenarioSize, isPlayerBlue)
	state = states.ATTACK

func attack_state():
	#TODO - Borrar esto, solo debug
	if Input.is_action_just_pressed("Back"):
		print("Saltanto ataque")
		FightOptions.go_back()
		_set_player_turn_state()
		return
		
func _get_scenario_size() -> Vector2:
	match turn:
		0,1,2,3,4,6,8,10,11,12,13:
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
	
func _get_player_mode_blue() -> bool:
	#Con cambio intermedio: 16,21,23
	return turn != 0 && turn != 15 && turn != 19 && turn != 20

# Funciones para cuando habla el esqueleto ketchup
func dialogue_state():
	print("Aun nos falta la preparación dx")
	
# Funciones del player
func _on_hp_changed(new_hp: int):
	FightOptions.update_hp(new_hp)
	
func _on_player_death():
	FightOptions.hide()
	BackAudio.stop()
	Scenario.on_death()
	
