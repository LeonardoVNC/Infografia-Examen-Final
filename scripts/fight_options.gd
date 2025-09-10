extends Control

@onready var Fight = $VBox/BottomOptions/FightOption
@onready var Act = $VBox/BottomOptions/ActOption
@onready var Item = $VBox/BottomOptions/ItemOption
@onready var Mercy = $VBox/BottomOptions/MercyOption
@onready var Description = $VBox/UpperOptions/Description
@onready var UpperOptions = $VBox/UpperOptions
@onready var Option1 = $VBox/UpperOptions/Option1
@onready var Option2 = $VBox/UpperOptions/Option2
@onready var Option3 = $VBox/UpperOptions/Option3
@onready var Option4 = $VBox/UpperOptions/Option4
@onready var Option5 = $VBox/UpperOptions/Option5
@onready var Option6 = $VBox/UpperOptions/Option6

enum states {BOTTOM, UPPER}
var state = states.BOTTOM

var actual_option = 0
var options = []
var actual_upper_option=0
var able_options = 0
var upper_options = []

signal fight
signal act
signal item
signal mercy

const SPRITES = {
	"fight" : "res://assets/Fight.png",
	"act" : "res://assets/Act.png",
	"item" : "res://assets/Item.png",
	"mercy" : "res://assets/Mercy.png",
}

func _ready() -> void:
	Fight.set_text("fight")
	Fight.set_icon(SPRITES.fight)
	Act.set_text("act")
	Act.set_icon(SPRITES.act)
	Item.set_text("item")
	Item.set_icon(SPRITES.item)
	Mercy.set_text("mercy")
	Mercy.set_icon(SPRITES.mercy)
	options = [Fight, Act, Item, Mercy]
	upper_options = [Option1, Option2, Option3, Option4, Option5, Option6]
	_set_new_turn()
	
func _set_new_turn():
	_set_bottom()
	actual_option = 0
	actual_upper_option = 0
	able_options = 0
	options[0].set_selected()
	
func _set_bottom():
	state = states.BOTTOM
	hide_upper()
	Description.show()

func _set_upper():
	state = states.UPPER
	show_upper()
	Description.hide()

func show_upper():
	upper_options[0].select_option()
	for i in range(6):
		upper_options[i].able()

func hide_upper():
	for i in range(6):
		upper_options[i].disable()

func set_description(text: String):
	Description.text = "* " + text

func set_upper_options(texts: Array[String]):
	if (texts.size() >= 6):
		print("Deberían introducirse solo 6 opciones loco")
		return
	able_options = 0
	for i in range(6):
		if (i < texts.size()):
			upper_options[i].set_text("* " + texts[i])
			able_options+=1
		else:
			upper_options[i].disable()


func option_left():
	match state:
		states.BOTTOM:
			if (actual_option <= 0): return
			options[actual_option].set_unselected()
			actual_option-=1
			options[actual_option].set_selected()
		states.UPPER:
			if (actual_upper_option <= 0): return
			upper_options[actual_upper_option].unselect_option()
			actual_upper_option-=1
			upper_options[actual_upper_option].select_option()

func option_right():
	match state:
		states.BOTTOM:
			if (actual_option >= options.size()-1): return
			options[actual_option].set_unselected()
			actual_option+=1
			options[actual_option].set_selected()
		states.UPPER:
			if (actual_upper_option >= able_options-1): return
			upper_options[actual_upper_option].unselect_option()
			actual_upper_option+=1
			upper_options[actual_upper_option].select_option()
			
	
func option_up():
	match state:
		states.UPPER:
			var temp_option = actual_upper_option-2
			if (temp_option < 0): temp_option = 0
			upper_options[actual_upper_option].unselect_option()
			actual_upper_option = temp_option
			upper_options[actual_upper_option].select_option()
	
func option_down():
	match state:
		states.UPPER:
			var temp_option = actual_upper_option+2
			if (temp_option >= able_options): temp_option = able_options-1
			upper_options[actual_upper_option].unselect_option()
			actual_upper_option = temp_option
			upper_options[actual_upper_option].select_option()

func execute_option():
	match state:
		states.BOTTOM:
			execute_bottom_option()
		states.UPPER:
			execute_upper_option()
	
func execute_bottom_option():
	_set_upper()
	match actual_option:
		0:
			set_upper_options(["Sans"])
		1:
			set_upper_options(["Observar"])
		2: 
			#TODO-Hay que cargar estos dinámicamente
			set_upper_options(["Fideos", "Héroe Leg.", "Héroe Leg.", "Héroe Leg.", "Héroe Leg."])
		3:
			set_upper_options(["Perdonar"])
		
func execute_upper_option():
	match actual_option:
		0:
			fight_upper_option()
		1: 
			act_upper_option()
		2:
			item_upper_option()
		3:
			mercy_upper_option()

func fight_upper_option():
	fight.emit()
	
func act_upper_option():
	act.emit()
	
func item_upper_option():
	#TODO-hay que meter mucha lógica aqui
	item.emit("a")
	
func mercy_upper_option():
	mercy.emit()

func go_back():
	_set_bottom()
	upper_options[actual_upper_option].unselect_option()
	actual_upper_option = 0
