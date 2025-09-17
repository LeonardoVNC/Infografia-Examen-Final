extends "res://scripts/attack.gd"

var bones_pool: Array
var current_tanda = 0
var max_tandas = 8
var tanda_interval = 0.8
var finished = false
var attack_timer: Timer

func _init(bones_pool_ref):
	bones_pool = bones_pool_ref

func start():
	current_tanda = 0
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = tanda_interval
	attack_timer.one_shot = false
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	attack_timer.start()

func stop():
	if attack_timer:
		attack_timer.stop()
		attack_timer.queue_free()
		attack_timer = null
	reset_all_bones()

func _on_attack_timer_timeout():
	if current_tanda >= max_tandas:
		if (finished):
			emit_signal("attack_finished")
			stop()
		else:
			attack_timer.start(3)
			finished=true
		return
	_spawn_lateral_jump_attack_tanda(current_tanda)
	current_tanda += 1

func _spawn_lateral_jump_attack_tanda(tanda_index):
	var left_x = lx
	var right_x = rx
	var bottom_y = 335
	var top_y = 260

	var base_index = tanda_index * 2
	if base_index + 1 >= bones_pool.size():
		print("No hay suficientes huesos para la tanda lateral ", tanda_index)
		return
		
	var bone_inf = bones_pool[base_index]
	bone_inf.enable()
	bone_inf.position = Vector2(left_x, bottom_y)
	bone_inf.speed = 100
	bone_inf.set_type(bone_inf.BoneType.NORMAL)
	bone_inf.scale = Vector2(0.5, 0.5)
	
	var bone_sup = bones_pool[base_index + 1]
	bone_sup.enable()
	bone_sup.position = Vector2(right_x, top_y)
	bone_sup.speed = -100
	bone_sup.set_type(bone_sup.BoneType.NORMAL)
	bone_sup.scale = Vector2(1, 2.7)

func reset_all_bones():
	for bone in bones_pool:
		bone.disable()
		bone.reset_position()
		bone.speed = 0

func process(delta):
	for bone in bones_pool:
		if bone.visible and (bone.position.x < lx or bone.position.x > rx):
			bone.disable()
			bone.reset_position()
			bone.speed = 0
