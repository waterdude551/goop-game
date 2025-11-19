extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0
var color = 1
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var game: Node2D = null
@onready var collision_shape_2d = $CollisionShape2D
var enemies := []
@export var hp = 100
@onready var health_bar = $HealthBar



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var boosts = 0
var dashing := false

func _ready():
	game = get_parent()

func _physics_process(delta):
	collision_shape_2d.disabled = false
	dashing = false
	health_bar.value = hp
	animated_sprite_2d.scale = Vector2(.4, .4)
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
		
	
	
	
	if Input.is_action_just_pressed("ui_dash"):
		velocity *= 50
		collision_shape_2d.disabled = true
		for i in enemies:
			i.queue_free()
		dashing = true
		if direction:
			animated_sprite_2d.scale = Vector2(1, .2)
		if elevation:
			animated_sprite_2d.scale = Vector2(.2, 1)
		animated_sprite_2d.play("default")
		
	
	
	move_and_slide()
	



func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		enemies.append(body)




func _on_area_2d_body_exited(body):
	if body.is_in_group("enemy"):
		enemies.erase(body)
