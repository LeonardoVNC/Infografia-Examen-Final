extends Node

@onready var bones_container = $BonesContainer
var bone_scene = preload("res://scenes/Bone.tscn")
var bones_pool: Array = []

func _ready():
	for i in range(16):
		var bone = bone_scene.instantiate()
		bones_container.add_child(bone)
		bone.disable()
		bones_pool.append(bone)

func spawn_bone_pattern():
	# Ejemplo: activar 5 huesos con posiciones y velocidades
	for i in range(5):
		var bone = bones_pool[i]
		bone.enable()
		bone.reset_position()
		bone.position = Vector2(100 * i, 350)
		bone.speed = 100 if (i % 2 == 0) else -100 
		bone.set_type(bone.BoneType.NORMAL if (i % 2 == 0) else bone.BoneType.BLUE)

func reset_all_bones():
	for bone in bones_pool:
		bone.disable()
		bone.reset_position()
		bone.speed = 0

func _process(delta):
	# Ejemplo: si un hueso sale fuera de pantalla, lo reseteamos y deshabilitamos
	for bone in bones_pool:
		if bone.visible and (bone.position.x < -50 or bone.position.x > 850):
			bone.disable()
			bone.reset_position()
			bone.speed = 0
