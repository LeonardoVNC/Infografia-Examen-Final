extends Area2D

var player_in_contact = false
var last_player_position = Vector2.ZERO
var player = null

enum BoneType { NORMAL, BLUE }
var type = BoneType.NORMAL

func _on_body_entered(body):
	if body.name == "Soul":
		player_in_contact = true
		player = body
		last_player_position = body.global_position
		if type == BoneType.NORMAL:
			body.hurt(1)

func _on_body_exited(body):
	if body.name == "Soul":
		player_in_contact = false
		player = null

func _process(delta):
	if player_in_contact && type == BoneType.BLUE && player != null:
		if player.global_position != last_player_position:
			player.hurt(1)
		last_player_position = player.global_position
