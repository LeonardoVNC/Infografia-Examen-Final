extends Node

@onready var bones_container = $BonesContainer
var bone_scene = preload("res://scenes/Bone.tscn")
var bones_pool: Array = []
var scenario_size = Vector2(640, 480)
const MID_X = 320
var lx = 0
var rx = 0
var active_attack = null

signal attack_finished

func _ready():
	for i in range(32):
		var bone = bone_scene.instantiate()
		bones_container.add_child(bone)
		bone.disable()
		bones_pool.append(bone)

func set_scenario_size(size: Vector2):
	scenario_size = size
	lx = MID_X - scenario_size.x / 2
	rx = MID_X + scenario_size.x / 2

func start_attack(attack_name: String):
	if active_attack:
		active_attack.stop()
		active_attack.queue_free()
		active_attack = null
	reset_all_bones() 
	
	match attack_name:
		"basic_jump":
			var AttackClass = preload("res://scripts/Attacks/BasicJumpBoneAttack.gd")
			active_attack = AttackClass.new(bones_pool)
		"lateral_jump":
			var AttackClass = preload("res://scripts/Attacks/LateralJumpBoneAttack.gd")
			active_attack = AttackClass.new(bones_pool)
		"lateral_blue":
			var AttackClass = preload("res://scripts/Attacks/LateralBlueJumpBoneAttack.gd")
			active_attack = AttackClass.new(bones_pool)
		_:
			print("Ataque desconocido: ", attack_name)
			return

	add_child(active_attack)
	active_attack.set_limits(lx, rx)
	active_attack.connect("attack_finished", Callable(self, "_on_attack_finished"))
	active_attack.start()

func _on_attack_finished():
	emit_signal("attack_finished")

func reset_all_bones():
	for bone in bones_pool:
		bone.disable()
		bone.reset_position()
		bone.speed = 0

func _process(delta):
	if active_attack:
		active_attack.process(delta)
