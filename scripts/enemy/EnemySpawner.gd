extends Node2D
var wave = 0;
var population = 0;
@onready var enemy: Node2D = null
var enemy_path = preload("res://scenes/enemy.tscn")
@onready var spawner = $Spawner

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemy();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if population == 0:
		wave += 1;
	if spawner.is_stopped():
		spawn_enemy()

func spawn_enemy():
	enemy = enemy_path.instantiate()
	enemy.global_position = Vector2((randi() % 560)-280,(randi() % 310)-155)
	get_parent().add_child(enemy)
	spawner.start()
	population += 1
