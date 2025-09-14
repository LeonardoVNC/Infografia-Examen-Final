extends TextureRect

@onready var Description = $Description
@onready var Options = $Options
@onready var Option1 = $Options/Option1
@onready var Option2 = $Options/Option2
@onready var Option3 = $Options/Option3
@onready var Option4 = $Options/Option4
@onready var Option5 = $Options/Option5
@onready var Option6 = $Options/Option6
@onready var FightBar = $FightBar
@onready var UpperTimer = $UpperTimer

var actual_option=0
var able_options = 0
var upper_options = []
var has_selected_option = false
var is_attacking = false
var attack_confirmed = false
var full_text = ""
var current_index = 0

signal optionSelected(option)
signal inputAttack()
signal actionFinished()
signal textChanged()

func _ready() -> void:
	upper_options = [Option1, Option2, Option3, Option4, Option5, Option6]
	show_description()

# Funciones para nodo Descripción:
func show_description():
	Description.show()
	Options.hide()
	FightBar.hide()

func set_description(text: String):
	full_text = "* " + text
	current_index = 0
	Description.text = ""
	UpperTimer.start(0.035)

func _on_upper_timer_timeout() -> void:
	if current_index < full_text.length():
		Description.text += full_text[current_index]
		current_index += 1
		textChanged.emit()
	else:
		UpperTimer.stop()
	
# Funciones para nodos Options:
func show_options():
	if (able_options > 0):
		select_first_option()
		actual_option=0
		Description.hide()
		Options.show()
		FightBar.hide()
	else:
		show_description()
		set_description("No quedan opciones.")
		return
	
func set_options(texts: Array[String]):
	if (texts.size() == 0):
		able_options = 0
		return
	if (texts.size() > 6):
		print("Deberían introducirse solo 6 opciones loco")
		return
	able_options = 0
	for i in range(6):
		if (i < texts.size()):
			upper_options[i].set_text("* " + texts[i])
			upper_options[i].able()
			able_options+=1
		else:
			upper_options[i].disable()

func select_first_option():
	upper_options[0].select_option()
	for i in range (1,6):
		if (i <= able_options):
			upper_options[i].unselect_option()
		else:
			break

func option_left():
	if (actual_option <= 0): return
	upper_options[actual_option].unselect_option()
	actual_option-=1
	upper_options[actual_option].select_option()

func option_right():
	if (actual_option >= able_options-1): return
	upper_options[actual_option].unselect_option()
	actual_option+=1
	upper_options[actual_option].select_option()
			
	
func option_up():
	var temp_option = actual_option-2
	if (temp_option < 0): temp_option = 0
	upper_options[actual_option].unselect_option()
	actual_option = temp_option
	upper_options[actual_option].select_option()
	
func option_down():
	var temp_option = actual_option+2
	if (temp_option >= able_options): temp_option = able_options-1
	upper_options[actual_option].unselect_option()
	actual_option = temp_option
	upper_options[actual_option].select_option()

func _set_new_turn():
	actual_option = 0
	able_options = 0
	has_selected_option = false
	is_attacking = false
	attack_confirmed = false
	
func execute_option():
	# Para atacar
	if is_attacking:
		if attack_confirmed:
			print("Ya estás atacando, dame chance")
			return
		attack_confirmed = true
		attack()
		return
		
	# Para selección de opciones y tal	
	if actual_option >= able_options:
		print("Algo raro está pasando en la selección de opciones")
		return
	
	if has_selected_option:
		if (!is_attacking):
			print("Cerrar ventana UI")
			actionFinished.emit()
	else:
		print("UpperBox: Ejecutando opcion %d" % actual_option)
		has_selected_option = true
		optionSelected.emit(actual_option)

# Funciones para nodo Fight Bar:
func show_fight_bar():
	Description.hide()
	Options.hide()
	FightBar.show()
	
func start_attack():
	if is_attacking:
		return
	is_attacking = true
	attack_confirmed = false
	FightBar.start_attack()

func attack():
	FightBar.attack()
	inputAttack.emit()

func _on_fight_bar_timeout() -> void:
	if (!attack_confirmed):
		inputAttack.emit()
