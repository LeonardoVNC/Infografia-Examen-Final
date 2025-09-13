extends AudioStreamPlayer

var select_effect = preload("res://assets/sounds/select.wav")

func play_select():
	stream = select_effect
	play()
