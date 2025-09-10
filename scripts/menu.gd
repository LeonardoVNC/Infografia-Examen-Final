extends TextureRect

@onready var Play = $OptionPlay
@onready var Exit = $OptionExit

func _ready ():
	Play.set_text("Jugar")
	Play.select_option()
	Exit.set_text("Salir")
