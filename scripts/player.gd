extends CharacterBody2D

@onready var Sprite = $Sprite
@onready var ColissionTimer = $Utils/ColissionTimer
@onready var AnimTree = $Utils/AnimationTree
@onready var AnimStates = $Utils/AnimationTree.get("parameters/playback")

@export var hp = 92
@export var gravity = 750.0
@export var max_fall_speed = 1500.0
@export var jump_speed = -180.0
@export var max_jump_time = 0.3
@export var jump_impulse = -210.0

var hasHurtWindow = false
var isBlue = false
var canMove = false
var jump_time = 0.0
var is_jumping = false
var original_position: Vector2

const SPEED = 180
const MAX_HP = 92

signal hp_changed(new_hp)
signal death()

func _ready():
	original_position = global_position

func _physics_process(delta: float) -> void:
	if not canMove:
		return
	if isBlue:
		var input_x = Input.get_axis("ui_left", "ui_right")
		velocity.x = input_x * SPEED

		if is_on_floor():
			velocity.y = 0
			jump_time = 0.0
			is_jumping = false
			if Input.is_action_just_pressed("ui_up"):
				velocity.y = jump_speed
				is_jumping = true
		else:
			if is_jumping and Input.is_action_pressed("ui_up") and jump_time < max_jump_time:
				velocity.y += jump_impulse * delta
				jump_time += delta
			else:
				velocity.y += gravity * delta
			
			if velocity.y > max_fall_speed:
				velocity.y = max_fall_speed
	else:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_axis("ui_left", "ui_right")
		input_vector.y = Input.get_axis("ui_up", "ui_down")
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
			velocity = input_vector * SPEED
		else:
			velocity = Vector2.ZERO
	move_and_slide()

func hurt(dmg: int):
	if(!hasHurtWindow):
		hp -= dmg
		if(hp<=0):
			on_death()
			return
		AnimStates.travel("Hurt")
		hp_changed.emit(hp)
		hasHurtWindow = true
		ColissionTimer.start(0.01)

func on_death():
	global_position = original_position
	velocity = Vector2.ZERO
	isBlue = false
	canMove = false
	Sprite.modulate = Color(1,0,0,1)
	
	AnimStates.travel("Death")
	
	death.emit()
	
func _on_colission_timer_timeout() -> void:
	hasHurtWindow = false

func recover_hp(rec_hp: int) -> bool:
	var new_hp = hp + rec_hp
	if new_hp >= MAX_HP:
		hp = MAX_HP
		hp_changed.emit(hp)
		return true
	else:
		hp = new_hp
		hp_changed.emit(hp)
		return false

func set_new_turn(new_isBlue: bool):
	isBlue = new_isBlue
	if isBlue:
		print("Modo azul wiwiwi")
		Sprite.modulate = Color(0,0,1,1)
	else:
		print("Modo rojo")
		Sprite.modulate = Color(1,0,0,1)
	global_position = original_position
	velocity = Vector2.ZERO
	able()

func able():
	canMove = true
	show()

func disable():
	canMove = false
	hide()
