extends TextureRect

@onready var Play = $OptionPlay
@onready var Exit = $OptionExit

var actual_option = 0
var options = []

func _ready ():
	Play.set_text("Jugar")
	Exit.set_text("Salir")
	options = [Play, Exit]
	options[actual_option].select_option()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Action"):
		_execute_option()
		return
	
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.y == -1:
			_option_up()
		else:
			_option_down()

func _option_up():
	if (actual_option <= 0): return
	options[actual_option].unselect_option()
	actual_option-=1
	options[actual_option].select_option()

func _option_down():
	if (actual_option >= options.size()-1): return
	options[actual_option].unselect_option()
	actual_option+=1
	options[actual_option].select_option()

func _execute_option():
	match actual_option:
		0:
			print("vamo juga")
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		1:
			print("nos vimos")
			get_tree().quit()
	
