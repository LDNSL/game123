extends Node3D
@onready var knife_animations: AnimationPlayer = $"Knife animations"
@onready var knife: Node3D = $"."
@onready var knife_model_right: Node3D = $Knife_model_right
@onready var left_hand: Node3D = $left_hand
@onready var right_hand: Node3D = $right_hand
@onready var knife_model_left: Node3D = $Knife_model_left
@onready var knife_hitbox: Area3D = $"../../../../../../neck/head/eyes/Camera3D/Knife hitbox"
@onready var knife_slash: AudioStreamPlayer3D = $Knife_model_right/knife_slash

var attack_index = 1
var knife_in_use = false
var damage = 1 
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	knife_model_left.visible = false
	knife_model_right.visible = false
	right_hand.visible = false
	left_hand.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event):
	if knife_in_use:
		if event.is_action_pressed("shoot"):
			timer.start()
			melee()
		if event.is_action_pressed("inspect"):
			print("placeholder inspect")
func equip():
	if knife_in_use:
		knife_animations.play("equip")
	else:
		knife_animations.play_backwards("equip")
func melee():
	knife_animations.play("knife_attack_1")
	var hit_list = knife_hitbox.get_overlapping_bodies()
	for i in hit_list:
		if i.is_in_group("enemy"):
			knife_slash.play()
			i.hit(damage)
	
	


func _on_timer_timeout() -> void:
	attack_index = 1
