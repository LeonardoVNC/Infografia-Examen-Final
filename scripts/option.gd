extends Control

@onready var player = $Player
@onready var text_option = $Texto

var isAble = true

func _ready():
	unselect_option()

func set_text(text: String):
	text_option.text = text
	
func select_option():
	player.modulate = Color(1,1,1,1)
	
func unselect_option():
	player.modulate = Color(0,0,0,0)
	
func disable():
	isAble = false
	hide();

func able():
	isAble = true
	show();
