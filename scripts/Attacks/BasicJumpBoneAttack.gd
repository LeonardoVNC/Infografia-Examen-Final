extends "res://scripts/attack.gd"

var bones_pool: Array
var current_tanda = 0
var max_tandas = 8
var tanda_interval = 0.8
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
		stop()
		emit_signal("attack_finished")
		return
	_spawn_jump_attack_tanda(current_tanda)
	current_tanda += 1

func _spawn_jump_attack_tanda(tanda_index):
	var left_x = lx
	var right_x = rx
	var top_y = 260
	var bottom_y = 335

	var base_index = tanda_index * 4
	if base_index + 3 >= bones_pool.size():
		print("No hay suficientes huesos para la tanda ", tanda_index)
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
