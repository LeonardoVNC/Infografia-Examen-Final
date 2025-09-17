extends "res://scripts/attack.gd"

var bones_pool: Array
var current_tanda = 0
var max_tandas = 7
var tanda_interval = 1
var attack_timer: Timer
var speed_small = 190
var speed_big = 190

var jump_configs = [
	{"small_scale": 0.55, "small_y": 340, "big_scale": 2.0, "big_y": 255},
	{"small_scale": 0.6, "small_y": 338, "big_scale": 1.9, "big_y": 252},
	{"small_scale": 1.0, "small_y": 332, "big_scale": 1.5, "big_y": 250},
	{"small_scale": 1.4, "small_y": 325, "big_scale": 1.1, "big_y": 245},
	{"small_scale": 1.6, "small_y": 320, "big_scale": 0.9, "big_y": 240},
]

func _init(bones_pool_ref):
	bones_pool = bones_pool_ref
	randomize() 

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

	var base_index = tanda_index * 4
	if base_index + 3 >= bones_pool.size():
		print("No hay suficientes huesos para la tanda ", tanda_index)
		return
	
	var config = jump_configs[randi() % jump_configs.size()]
	
	for i in range(2):
		var bone = bones_pool[base_index + i]
		bone.enable()
		bone.position = Vector2(left_x if i == 0 else right_x, config.small_y)
		bone.speed = speed_small if i == 0 else -speed_small
		bone.set_type(bone.BoneType.NORMAL)
		bone.scale = Vector2(0.5, config.small_scale)
	
	for i in range(2, 4):
		var bone = bones_pool[base_index + i]
		bone.enable()
		bone.position = Vector2(left_x if i == 2 else right_x, config.big_y)
		bone.speed = speed_big if i == 2 else -speed_big
		bone.set_type(bone.BoneType.NORMAL)
		bone.scale = Vector2(1, config.big_scale)

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
