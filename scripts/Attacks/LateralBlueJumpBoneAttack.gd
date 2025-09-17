extends "res://scripts/attack.gd"

var bones_pool: Array
var current_tanda = 0
var max_tandas = 6
var tanda_interval = 1.1
var delay_between_bones = 0.3
var attack_timer: Timer
var bone_timer: Timer
var bone_index_in_tanda = 0

var bottom_y = 335

func _init(bones_pool_ref):
	bones_pool = bones_pool_ref

func set_limits(left_x: float, right_x: float):
	lx = left_x
	rx = right_x

func start():
	current_tanda = 0
	bone_index_in_tanda = 0
	
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = tanda_interval
	attack_timer.one_shot = false
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	attack_timer.start()
	
	bone_timer = Timer.new()
	add_child(bone_timer)
	bone_timer.one_shot = true
	bone_timer.connect("timeout", Callable(self, "_on_bone_timer_timeout"))
	_spawn_next_bone_in_tanda()

func stop():
	if attack_timer:
		attack_timer.stop()
		attack_timer.queue_free()
		attack_timer = null
	if bone_timer:
		bone_timer.stop()
		bone_timer.queue_free()
		bone_timer = null
	reset_all_bones()

func _on_attack_timer_timeout():
	current_tanda += 1
	if current_tanda >= max_tandas:
		stop()
		emit_signal("attack_finished")
		return
	bone_index_in_tanda = 0
	_spawn_next_bone_in_tanda()

func _on_bone_timer_timeout():
	bone_index_in_tanda += 1
	if bone_index_in_tanda < 2:
		_spawn_next_bone_in_tanda()

func _spawn_next_bone_in_tanda():
	var base_index = current_tanda * 2
	if base_index + bone_index_in_tanda >= bones_pool.size():
		print("No hay suficientes huesos para la tanda ", current_tanda)
		return
	
	var bone = bones_pool[base_index + bone_index_in_tanda]
	bone.enable()
	
	var going_right = current_tanda >= 3 
	var start_x = rx if not going_right else lx
	var speed = -250 if not going_right else 250
	
	if bone_index_in_tanda == 0:
		bone.position = Vector2(start_x, bottom_y)
		bone.speed = speed
		bone.set_type(bone.BoneType.NORMAL) 
		bone.scale = Vector2(0.5, 0.5)
	else:
		bone.position = Vector2(start_x, bottom_y-40)
		bone.speed = speed
		bone.set_type(bone.BoneType.BLUE) 
		bone.scale = Vector2(1, 2.5)

	if bone_index_in_tanda == 0:
		bone_timer.start(delay_between_bones)

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
