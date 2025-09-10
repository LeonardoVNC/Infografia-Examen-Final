extends HBoxContainer

@onready var Fight = $FightOption
@onready var Act = $ActOption
@onready var Item = $ItemOption
@onready var Mercy = $MercyOption
var actual_option = 0
var options = []

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

func option_left():
	if (actual_option <= 0): return
	options[actual_option].set_unselected()
	actual_option-=1
	options[actual_option].set_selected()

func option_right():
	if (actual_option >= options.size()-1): return
	options[actual_option].set_unselected()
	actual_option+=1
	options[actual_option].set_selected()

func execute_option():
	match actual_option:
		0:
			print("Ataqueeen")
			fight.emit()
		1:
			print("Actueeeen")
			act.emit()
		2: 
			print("Estan mejor crudooos")
			#Aqui el propio jugador debería recuperar su vida supongo, no hay pq mandar lógica a game asdfl
			item.emit()
		3:
			print("*no hace nada*")
			mercy.emit()
	
