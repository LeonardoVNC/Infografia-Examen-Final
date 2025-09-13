extends TextureRect

@onready var HPBar = $Player_HP/HP
@onready var HPText = $Player_HP/Text_HP
@export var current_hp = MAX_HP

const MAX_HP = 92

func _ready():
	HPBar.value = MAX_HP
	HPText.text = "%d/%d" % [MAX_HP, MAX_HP]

func update_hp(actual_hp: int):
	HPBar.value = actual_hp
	HPText.text = "%d/%d" % [actual_hp, MAX_HP]
	current_hp = actual_hp
