extends Node2D

# Guia tamaño bleh: _,170 Max
@export var default = Vector2(150, 150)
@export var wall_width = 10

@onready var WallTop = $WallTop
@onready var WallBottom = $WallBottom
@onready var WallLeft = $WallLeft
@onready var WallRight = $WallRight
@onready var Line = $Line2D

func _ready():
	set_scenario_size(default)

func set_scenario_size(new_size: Vector2) -> void:
	var half_size = new_size / 2
	
	_set_wall(WallTop, Vector2(0, -half_size.y), Vector2(new_size.x, wall_width))
	_set_wall(WallBottom, Vector2(0, half_size.y), Vector2(new_size.x, wall_width))
	_set_wall(WallLeft, Vector2(-half_size.x, 0), Vector2(wall_width, new_size.y))
	_set_wall(WallRight, Vector2(half_size.x, 0), Vector2(wall_width, new_size.y))

	if Line:
		var points = [
			Vector2(-half_size.x, -half_size.y),
			Vector2(half_size.x, -half_size.y),
			Vector2(half_size.x, half_size.y),
			Vector2(-half_size.x, half_size.y),
			Vector2(-half_size.x, -half_size.y)
		]
		Line.points = points

func _set_wall(wall: StaticBody2D, position: Vector2, size: Vector2) -> void:
	wall.position = position
	var shape = wall.get_node("CollisionShape2D").shape
	if shape is RectangleShape2D:
		shape.size = size
	else:
		push_error("CollisionShape2D no es RectangleShape2D en " + wall.name)
