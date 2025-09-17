extends TextureRect

@onready var TextOption = $Text
@onready var Icon = $Icon

var soul_texture
var icon_texture

func _ready():
	var tex = load("res://assets/images/Soul.png")
	soul_texture = tex

func set_icon(path: String):
	var tex = load(path)
	icon_texture = tex
	_load_icon()
	
func _load_icon():
	Icon.texture = icon_texture
	
func set_selected():
	Icon.texture = soul_texture
	$".".modulate = Color(10, 10, 0.1, 1)
	
func set_unselected():
	Icon.texture = icon_texture
	$".".modulate = Color(1, 1, 1, 1)
	
func set_text(text: String):
	TextOption.text = text
