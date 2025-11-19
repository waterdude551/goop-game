extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player: Node2D = null
@onready var game: Node2D = null
var color
var colliding := false
var canPop := false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attack = $Attack
@onready var nav_agent = $NavigationAgent2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	color = (randi() % 3) + 1
	game = get_parent()

func _physics_process(delta):
	if player == null:
		_ready()
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	var current_position: Vector2 = self.global_transform.origin
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = current_position.direction_to(next_path_position)
	nav_agent.velocity = new_velocity
	update_target_position(player.global_transform.origin)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		colliding = true
		if body.color != color:
			attack.start()




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
	velocity = velocity.move_toward(safe_velocity * SPEED, 12.0)
	move_and_slide()
