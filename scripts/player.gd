extends CharacterBody2D

const SPEED = 200
const MAX_HP = 92

@export var hp = 92
var hasHurtWindow = false
var isBlue = false
var canMove = false

func _physics_process(delta: float) -> void:
	if (canMove):
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_axis("ui_left", "ui_right")
		input_vector.y = Input.get_axis("ui_up", "ui_down")
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			velocity = input_vector * SPEED
		else:
			velocity = Vector2.ZERO
		
	move_and_slide()
	
func recover_hp(rec_hp: int) -> bool:
	var new_hp = hp + rec_hp
	if (new_hp >= MAX_HP):
		hp = MAX_HP
		return true
	else:
		hp = new_hp
		return false

func able():
	canMove = true
	show()
	
func disable():
	canMove = false
	hide()
