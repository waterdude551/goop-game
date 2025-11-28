extends CharacterBody2D


@export var SPEED = 600
const JUMP_VELOCITY = -400.0
var color = 1
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var game: Node2D = null
@onready var collision_shape_2d = $CollisionShape2D
var enemies := []
var weapons := []
@export var hp = 100
@onready var health_bar = $HealthBar
@onready var camera_2d: Camera2D = $Camera2D
@export var sweeping = false
@export var shooting = false
@export var pistol = false
@export var shotgun = false

@export var money = 0
@onready var sprite_2d: Sprite2D = $PlayerAimPivot/PlayerAim/Sprite2D
@onready var aim_pivot: Node2D = $PlayerAimPivot

var weaponIndex = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var boosts = 5
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
	if velocity.x != 0 || velocity.y != 0:
		if animated_sprite_2d.animation == "idle":
			animated_sprite_2d.play("walking")
			
	if Input.is_action_just_pressed("ui_left"):
		animated_sprite_2d.flip_h = false
		sprite_2d.flip_v = false
		aim_pivot.position.x = 32
	if Input.is_action_just_pressed("ui_right"):
		animated_sprite_2d.flip_h = true
		#sprite_2d.flip_v = true
		aim_pivot.position.x = 12
	if Input.is_action_just_pressed("ui_switch"):
		if sweeping:
			sweeping = false
			shooting = true
		elif shooting:
			sweeping = true
			shooting = false
		print("switch")
	
	
	if Input.is_action_just_pressed("ui_dash") and boosts > 0:
		boosts -= 1
		velocity *= 50
		collision_shape_2d.disabled = true
		for i in enemies:
			game.enemies.erase(i);
			i.queue_free()
			game.population -=  1;
			game.kills += 1;
		dashing = true
		if direction:
			animated_sprite_2d.scale = Vector2(4, 1)
		if elevation:
			animated_sprite_2d.scale = Vector2(1, 4)
		animated_sprite_2d.play("default")
		
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		enemies.append(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		enemies.erase(body)
