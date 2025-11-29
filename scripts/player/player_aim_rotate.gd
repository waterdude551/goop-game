extends Node2D
@onready var player: Node2D = null
const BULLET = preload("res://scenes/bullet.tscn")

func _ready():
	player = get_parent()

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if Input.is_action_just_pressed("shoot") and player.shooting:
		if player.weapons[player.weaponIndex] == "pistol":
			makeBullet(0)
		if player.weapons[player.weaponIndex] == "shotgun":
			makeBullet(0)
			makeBullet(0.25)
			makeBullet(-0.25)
	if Input.is_action_just_pressed("ui_equip") and len(player.weapons)>0:
		player.weaponIndex = (player.weaponIndex + 1) % len(player.weapons)

func makeBullet(rot):
	var bullet = BULLET.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = rotation + rot
