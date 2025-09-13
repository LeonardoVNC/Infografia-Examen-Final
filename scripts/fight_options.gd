extends Control

@onready var UpperBox = $VBox/UpperBox
@onready var SoulUI = $VBox/SoulUI
@onready var Fight = $VBox/BottomOptions/FightOption
@onready var Act = $VBox/BottomOptions/ActOption
@onready var Item = $VBox/BottomOptions/ItemOption
@onready var Mercy = $VBox/BottomOptions/MercyOption

enum states {BOTTOM, UPPER}
var state = states.BOTTOM

var actual_option = 0
var options = []
var items = []
var hasAttacked = false
var isActing = false
var fight_options: Array[String] = ["Sans"]
var act_options: Array[String] = ["Observar"]
var mercy_options: Array[String] = ["Perdonar"]

signal item(item_name)
signal readyToClose

const SPRITES = {
	"fight" : "res://assets/Fight.png",
	"act" : "res://assets/Act.png",
	"item" : "res://assets/Item.png",
	"mercy" : "res://assets/Mercy.png",
}

func _ready() -> void:
	_prepare_bottom_options()
	_set_new_turn()
	
func _prepare_bottom_options():
	Fight.set_text("fight")
	Fight.set_icon(SPRITES.fight)
	Act.set_text("act")
	Act.set_icon(SPRITES.act)
	Item.set_text("item")
	Item.set_icon(SPRITES.item)
	Mercy.set_text("mercy")
	Mercy.set_icon(SPRITES.mercy)
	options = [Fight, Act, Item, Mercy]

func _set_new_turn():
	actual_option = 0
	isActing = false
	options[0].set_selected()
	
func set_items(item_list: Array[String]):
	items = item_list

func set_bottom():
	state = states.BOTTOM
	UpperBox.show_description()

func set_options():
	state = states.UPPER
	UpperBox.show_options()

# Funciones de navegación
func option_left():
	match state:
		states.BOTTOM:
			if (actual_option <= 0): return
			options[actual_option].set_unselected()
			actual_option-=1
			options[actual_option].set_selected()
		states.UPPER:
			UpperBox.option_left()

func option_right():
	match state:
		states.BOTTOM:
			if (actual_option >= options.size()-1): return
			options[actual_option].set_unselected()
			actual_option+=1
			options[actual_option].set_selected()
		states.UPPER:
			UpperBox.option_right()

func option_up():
	match state:
		states.UPPER:
			UpperBox.option_up()

func option_down():
	match state:
		states.UPPER:
			UpperBox.option_down()

func execute_option():
	match state:
		states.BOTTOM:
			execute_bottom_option()
		states.UPPER:
			UpperBox.execute_option()

func go_back():
	if (!isActing):
		set_bottom()

# Funciones de selección de opciones - UpperBox
func _on_upper_box_option_selected(option: Variant) -> void:
	isActing = true
	match actual_option:
		0:
			_fight_selected(option)
		1:
			_act_selected(option)
		2:
			_item_selected(option)
		3:
			_mercy_selected(option)

func _fight_selected(option: int):
	if (option == 0):
		hasAttacked = true
		UpperBox.show_fight_bar()
		UpperBox.start_attack()
	else:
		print("Algo raro está pasando con la selección de opciones - attack")

func _act_selected(option: int):
	if (option == 0):
		var text
		if (hasAttacked):
			text = "No puede seguir esquivando por siempre. Sigue atacando."
		else:
			text = "SANS 1 ATK 1 DEF\n* El enemigo más fácil.\n* Solo puede provocar 1 de daño."
		UpperBox.set_description(text)
		UpperBox.show_description()
	else:
		print("Algo raro está pasando con la selección de opciones - act")

func _item_selected(option: int):
	item.emit(items[option])

func _mercy_selected(option: int):
	if (option == 0):
		readyToClose.emit()
	else:
		print("Algo raro está pasando con la selección de opciones - mercy")
	
func _on_upper_box_action_finished() -> void:
	readyToClose.emit()

# Funciones de selección de opciones - BottomOptions
func execute_bottom_option():
	match actual_option:
		0:
			UpperBox.set_options(fight_options)
		1:
			UpperBox.set_options(act_options)
		2: 
			UpperBox.set_options(items)
		3:
			UpperBox.set_options(mercy_options)
	set_options()
