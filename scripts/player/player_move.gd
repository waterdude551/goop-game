extends Node2D

@export var move_speed : float

var move_input : Vector2

func _process(delta: float) -> void:
	read_input()

func _physics_process(delta: float) -> void:
	self.transform.origin += move_input

func read_input() -> void:
	move_input = Vector2.ZERO
	if (Input.is_key_pressed(KEY_W)):
		move_input -= Vector2(0, move_speed)
	if (Input.is_key_pressed(KEY_S)):
		move_input += Vector2(0, move_speed)
	if (Input.is_key_pressed(KEY_A)):
		move_input -= Vector2(move_speed, 0)
	if (Input.is_key_pressed(KEY_D)):
		move_input += Vector2(move_speed, 0)
	pass
