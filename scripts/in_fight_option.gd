extends TextureRect

@onready var TextOption = $Text
@onready var Icon = $Icon
	
func set_icon(path: String):
	var tex = load(path)
	Icon.texture = tex
	
func set_selected():
	$".".modulate = Color(1, 1, 0.3, 1)
	
func set_unselected():
	$".".modulate = Color(1, 1, 1, 1)
	
func set_text(text: String):
	TextOption.text = text
