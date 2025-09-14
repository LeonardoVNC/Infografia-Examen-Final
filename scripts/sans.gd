extends Node2D

@onready var AnimTree = $AnimationTree
@onready var AnimStates = $AnimationTree.get("parameters/playback")

func _ready() -> void:
	AnimStates.travel("Idle")
	
func dodge():
	AnimStates.travel("Dodge")
