extends Node2D
@onready var player: Node2D = null
const BULLET = preload("res://scenes/bullet.tscn")

func _ready():
	player = get_parent()

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	if Input.is_action_just_pressed("shoot") and player.shooting:
		var bullet = BULLET.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = rotation
##l
