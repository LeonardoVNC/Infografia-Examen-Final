extends AudioStreamPlayer

var select_effect = preload("res://assets/sounds/select.wav")
var normal_text_effect = preload("res://assets/sounds/SND_TXT2.wav")

func play_select():
	stream = select_effect
	play()

func play_normal_text():
	stream = normal_text_effect
	play()
