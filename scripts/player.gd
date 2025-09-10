extends CharacterBody2D

const SPEED = 200

@export var hp = 92
var hasHurtWindow = false
var isBlue = false

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = input_vector * SPEED
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
