extends Node2D

@export var area_size = Vector2(300, 200)
@export var wall_thickness = 4
@export var border_color = Color(1, 1, 1)

func _ready():
	print("TODO-Arreglar escenario")
	#_create_walls()

func _create_walls():
	var walls = $Walls.get_children()
	if walls.size() == 0:
		for name in ["WallTop", "WallBottom", "WallLeft", "WallRight"]:
			var wall = StaticBody2D.new()
			wall.name = name
			var shape = CollisionShape2D.new()
			shape.shape = RectangleShape2D.new()
			wall.add_child(shape)
			$Walls.add_child(wall)
	
	_update_walls()

func _update_walls():
	var half_size = area_size / 2
	var half_thick = wall_thickness / 2
	$Walls/WallTop.position = Vector2(0, -half_size.y + half_thick)
	$Walls/WallTop/CollisionShape2D.shape.extents = Vector2(half_size.x, half_thick)
	
	$Walls/WallBottom.position = Vector2(0, half_size.y - half_thick)
	$Walls/WallBottom/CollisionShape2D.shape.extents = Vector2(half_size.x, half_thick)
	
	$Walls/WallLeft.position = Vector2(-half_size.x + half_thick, 0)
	$Walls/WallLeft/CollisionShape2D.shape.extents = Vector2(half_thick, half_size.y)
	
	$Walls/WallRight.position = Vector2(half_size.x - half_thick, 0)
	$Walls/WallRight/CollisionShape2D.shape.extents = Vector2(half_thick, half_size.y)

func _draw():
	print("TODO-Arreglar dibujado de escenario")
	#draw_rect(Rect2(-area_size / 2, area_size), border_color, false, wall_thickness)

func set_area_size(new_size: Vector2) -> void:
	area_size = new_size
	_update_walls()
