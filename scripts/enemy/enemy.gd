extends CharacterBody2D


const JUMP_VELOCITY = -400.0
@onready var player: Node2D = null
@onready var game: Node2D = null
@onready var goop: Node2D = null
var color
var colliding := false
var canPop := false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attack = $Attack
@onready var nav_agent = $NavigationAgent2D
var goop_path = preload("res://scenes/goop.tscn")

@onready var spawner = $Spawner

@export var speed = 300.0
@export var damage = 10
@export var health = 3


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	color = (randi() % 3) + 1
	game = get_parent()

func _process(delta):
	if health <= 0:
		get_parent().get_node("Practice arena").destroy_enemy(self)
		queue_free()

func _physics_process(delta):
	if player == null:
		_ready()
	if spawner.is_stopped():
		spawn_goop()
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	if colliding == true && attack.is_stopped():
		player.hp -= damage
		attack.start()
	
	var current_position: Vector2 = self.global_transform.origin
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = current_position.direction_to(next_path_position)
	nav_agent.velocity = new_velocity
	update_target_position(player.global_transform.origin)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		colliding = true
		player.hp -= damage
		attack.start()
	
	if body.is_in_group("bullet"):
		health -= 1
		body.queue_free()




func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		attack.stop()
		colliding = false
	


func _on_area_2d_area_entered(area):
	if area.is_in_group("dash"):
		canPop = true
		print("in range")


func _on_area_2d_area_exited(area):
	if area.is_in_group("dash"):
		canPop = false

func update_target_position(target_pos: Vector2):
	nav_agent.target_position = target_pos

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity * speed, 12.0)
	move_and_slide()
	
func spawn_goop():
	goop = goop_path.instantiate()
	goop.global_position = global_position
	get_parent().add_child(goop)
	spawner.start()
##l
