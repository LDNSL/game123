extends Node3D

@onready var first = $shotgun
@onready var second = $Knife
var third = "nothing"


func _input(event):
	if event.is_action_pressed("1"):
		first.shotgun_in_use = true
		second.knife_in_use = false
		first.equip()
		second.equip()
	if event.is_action_pressed("2"):
		first.shotgun_in_use = false
		second.knife_in_use = true
		first.equip()
		second.equip()
		
