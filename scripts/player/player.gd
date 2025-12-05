extends CharacterBody2D


@export var SPEED = 600
const JUMP_VELOCITY = -400.0
var color = 1
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var game: Node2D = null
@onready var collision_shape_2d = $CollisionShape2D
var enemies := []
var weapons := ["arm"]
@export var hp = 100
@onready var health_bar = $HealthBar
@onready var camera_2d: Camera2D = $Camera2D
@export var sweeping = false
@export var shooting = false
@export var pistol = false
@export var shotgun = false
@onready var energy: Timer = $energy
@onready var player_aim: Node2D = $PlayerAimPivot/PlayerAim


@export var money = 50
@onready var arm: AnimatedSprite2D = $PlayerAimPivot/arm
@onready var aim_pivot: Node2D = $PlayerAimPivot

var weaponIndex = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var boosts = 10
var dashing := false

func _ready():
	game = get_parent()

func _physics_process(delta):
	if game.player == null:
		game.player = self
	
	collision_shape_2d.disabled = false
	dashing = false
	health_bar.value = hp
	animated_sprite_2d.scale = Vector2(2.5, 2.5)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var elevation = Input.get_axis("ui_up", "ui_down")
	var direction = Input.get_axis("ui_left", "ui_right")
	if elevation:
		velocity.y = elevation * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if velocity.x != 0 || velocity.y != 0: #walking animation
		if animated_sprite_2d.animation == "idle" || !animated_sprite_2d.is_playing():
			animated_sprite_2d.play("walking")
	
	if sweeping:
		arm.play("arm")
	if shooting and weapons[weaponIndex] != null: #equips pistol or shotgun
		arm.play(weapons[weaponIndex])
	
	if Input.is_action_just_pressed("ui_left"):
		animated_sprite_2d.flip_h = false
		aim_pivot.position.x = 10
		aim_pivot.scale = Vector2(1,1)
	if Input.is_action_just_pressed("ui_right"): #makes the player face right
		animated_sprite_2d.flip_h = true
		aim_pivot.position.x = -10
		aim_pivot.scale = Vector2(1,-1)
	if Input.is_action_just_pressed("ui_switch"): #toggles between shooting and sweeping
		if sweeping:
			sweeping = false
			shooting = true
		elif shooting:
			sweeping = true
			shooting = false
		print("switch")
	if hp <= 0:
		get_tree().reload_current_scene()
	
	
	if Input.is_action_just_pressed("ui_dash") and boosts > 0:
		energy.start()
		animated_sprite_2d.play("spin")
		boosts -= 1
		velocity *= 10
		collision_shape_2d.disabled = true
		for i in enemies:
			if i.raidboss:
				i.health -= 1
				if i.health <= 0:
					game.enemies.erase(i)
					i.queue_free()
					game.destroy_enemy(i)
			else:
				game.enemies.erase(i)
				i.queue_free()
				game.destroy_enemy(i)
		dashing = true
		if direction:
			animated_sprite_2d.scale = Vector2(4, 1)
		if elevation:
			animated_sprite_2d.scale = Vector2(1, 4)
	if velocity.x == 0 and velocity.y == 0:
		if dashing:
			animated_sprite_2d.play("spin")
		elif !animated_sprite_2d.is_playing() || animated_sprite_2d.animation == "walking" :
			animated_sprite_2d.play("idle")
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		enemies.append(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		enemies.erase(body)


func _on_energy_timeout() -> void:
	if boosts < 10:
		boosts += 1
		energy.start()
