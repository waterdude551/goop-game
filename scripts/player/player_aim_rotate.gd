extends Node2D
@onready var player: Node2D = null
const BULLET = preload("res://scenes/bullet.tscn")
@onready var pistol_sound: AudioStreamPlayer2D = $"../pistol_sound"
@onready var shotgun_sound: AudioStreamPlayer2D = $"../shotgun_sound"


func _ready():
	player = get_parent()

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if Input.is_action_just_pressed("shoot") and player.shooting:
		if player.weapons[player.weaponIndex] == "pistol":
			makeBullet(0)
			pistol_sound.play()
		if player.weapons[player.weaponIndex] == "shotgun":
			makeBullet(0) 
			makeBullet(0.25) #shotgun spread
			makeBullet(-0.25)
			shotgun_sound.play()
	if Input.is_action_just_pressed("ui_equip") and len(player.weapons)>0: #scroll through weapons
		player.weaponIndex = (player.weaponIndex + 1) % len(player.weapons)

func makeBullet(rot):
	var bullet = BULLET.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_position = global_position
	bullet.rotation = rotation + rot
