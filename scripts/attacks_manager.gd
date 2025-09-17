extends Node

@onready var bones_container = $BonesContainer
const MID_X = 320
var scenario_size = Vector2(640,480)
var lx = MID_X-scenario_size.x/2
var rx = MID_X+scenario_size.x/2

var bone_scene = preload("res://scenes/Bone.tscn")
var bones_pool: Array = []
var current_jump_tanda = 0
var max_jump_tandas = 8
var tanda_interval = 0.8
var attack_timer: Timer

signal attack_finished

func _ready():
	for i in range(32):
		var bone = bone_scene.instantiate()
		bones_container.add_child(bone)
		bone.disable()
		bones_pool.append(bone)
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = tanda_interval
	attack_timer.one_shot = false
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))

func set_scenario_size(size: Vector2):
	scenario_size = size
	lx = MID_X-scenario_size.x/2
	rx = MID_X+scenario_size.x/2

func start_basic_jump_bone_attack():
	current_jump_tanda = 0
	attack_timer.start()

func _on_attack_timer_timeout():
	if current_jump_tanda >= max_jump_tandas:
		attack_timer.stop()
		reset_all_bones()
		print("Fin del ataque")
		attack_finished.emit()
		return

	_spawn_jump_attack_tanda(current_jump_tanda)
	current_jump_tanda += 1

func _spawn_jump_attack_tanda(tanda_index):
	var left_x = lx
	var right_x = rx
	var top_y = 260
	var bottom_y = 335

	var base_index = tanda_index * 4
	if base_index + 3 >= bones_pool.size():
		print("Nos faltan wesos para la tanda ", tanda_index)
		return

	for i in range(2):
		var bone = bones_pool[base_index + i]
		bone.enable()
		bone.position = Vector2(left_x if i == 0 else right_x, bottom_y)
		bone.speed = 250 if i == 0 else -250
		bone.set_type(bone.BoneType.NORMAL)
		bone.scale = Vector2(0.5, 0.5)

	for i in range(2, 4):
		var bone = bones_pool[base_index + i]
		bone.enable()
		bone.position = Vector2(left_x if i == 2 else right_x, top_y)
		bone.speed = 250 if i == 2 else -250
		bone.set_type(bone.BoneType.NORMAL)
		bone.scale = Vector2(1, 1.8)

		
func spawn_bone_pattern():
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
	for bone in bones_pool:
		if bone.visible and (bone.position.x < lx or bone.position.x > rx):
			bone.disable()
			bone.reset_position()
			bone.speed = 0
