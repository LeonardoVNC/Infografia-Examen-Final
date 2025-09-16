extends Node

@onready var bones_container = $BonesContainer
var bone_scene = preload("res://scenes/Bone.tscn")

func spawn_bones_pattern():
	for i in range(5):
		var bone_instance = bone_scene.instantiate()
		bones_container.add_child(bone_instance)
		bone_instance.position = Vector2(100 * i, 350)
		bone_instance.type = bone_instance.BoneType.NORMAL if (i % 2 == 0) else bone_instance.BoneType.BLUE
