extends Node2D

@onready var AnimTree = $Utils/AnimationTree
@onready var AnimStates = $Utils/AnimationTree.get("parameters/playback")
@onready var Text = $Text
@onready var Audio = $Utils/AudioPlayer
@onready var TextLabel = $Text/Label
@onready var ETimer = $Utils/EeeTimer

var text = ""
var textIndex = 0

func _ready() -> void:
	AnimStates.travel("Idle")
	
func dodge():
	AnimStates.travel("Dodge")

func talk(newText: String) -> void:
	text = newText
	textIndex = 0
	Text.show()
	TextLabel.text = ""
	ETimer.start()
	
func _on_eee_timer_timeout() -> void:
	if textIndex < text.length():
		TextLabel.text += text[textIndex]
		textIndex += 1
		Audio.stop()
		Audio.play()
	else:
		ETimer.stop()

func hide_text() -> void:
	Text.hide()
	TextLabel.text = ""
