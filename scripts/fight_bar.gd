extends TextureRect

const ORIGIN_X = 10
const ORIGIN_Y = 60

@onready var DamageIndicator = $DamageIndicator
@onready var IndicatorTimer = $IndicatorTimer

var has_attacked = false
var lr_pass = true
var x = ORIGIN_X
var y = ORIGIN_Y

signal timeout

func _ready():
	reset_position()

func reset_position():
	has_attacked = false
	lr_pass = true
	x = ORIGIN_X
	y = ORIGIN_Y
	DamageIndicator.position = Vector2(x,y)
	
func start_attack():
	reset_position()
	IndicatorTimer.start(0.01)

func _on_indicator_timer_timeout() -> void:
	if (lr_pass):
		x += 10
	else:
		x -= 10
		
	if (x > 540) :
		lr_pass = false
	
	DamageIndicator.position = Vector2(x,y)
	if (x < ORIGIN_X): 
		attack()
	
func attack():
	if (!has_attacked):
		has_attacked = true
		IndicatorTimer.stop()
		timeout.emit()
