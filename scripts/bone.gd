extends Area2D

@onready var sprite = $Sprite2D

@export var type: BoneType = BoneType.NORMAL
@export var speed: float = 0.0
var player_in_contact: bool = false
var last_player_position: Vector2 = Vector2.ZERO
var player = null
var original_position: Vector2

enum BoneType { NORMAL, BLUE }

func _ready():
	original_position = position
	_update_color()

func _process(delta):
	if speed != 0:
		position.x += speed * delta

	if player_in_contact and type == BoneType.BLUE and player != null:
		if player.global_position != last_player_position:
			player.hurt(1)
		last_player_position = player.global_position

# Funciones para control en tiempo de ejecución
func reset_position():
	position = original_position

func move_to_position(new_pos: Vector2):
	position = new_pos

func enable():
	set_process(true)
	show()
	set_collision_layer_value(0, true)
	set_collision_mask_value(0, true)
	
	player_in_contact = false
	player = null
	last_player_position = Vector2.ZERO

func disable():
	set_process(false)
	hide()
	set_collision_layer_value(0, false)
	set_collision_mask_value(0, false)
	
	player_in_contact = false
	player = null
	last_player_position = Vector2.ZERO

func _update_color():
	if type == BoneType.NORMAL:
		sprite.modulate = Color(1, 1, 1)
	elif type == BoneType.BLUE:
		sprite.modulate = Color(0.4, 0.6, 1)

func set_type(new_type: BoneType):
	type = new_type
	_update_color()

# Funciones de señales - para provocar daño
func _on_body_entered(body):
	if body.name == "Soul":
		player_in_contact = true
		player = body
		last_player_position = body.global_position
		if type == BoneType.NORMAL:
			body.hurt(1)

func _on_body_exited(body):
	if body.name == "Soul":
		player_in_contact = false
		player = null
