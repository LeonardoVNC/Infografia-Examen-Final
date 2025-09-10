extends HBoxContainer

@onready var Fight = $FightOption
@onready var Act = $ActOption
@onready var Item = $ItemOption
@onready var Mercy = $MercyOption

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
