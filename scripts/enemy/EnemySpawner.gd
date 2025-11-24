extends Node2D
var wave = 0;
var enemiesToSpawn = 0;
var population = 0;
var kills = 0;
var initPop = 0;
@onready var enemy: Node2D = null #enemies will be spawned repeatedly
@onready var player: Node2D = null
@onready var game: Node2D = null
var enemy_path = preload("res://scenes/enemy.tscn")
@onready var spawner = $Spawner
@onready var enemyCount: RichTextLabel = $RichTextLabel
@onready var layer_1: TileMapLayer = $TileMapLayer


var tileSetNumber = 0
var slimeTile = Vector2i(4,15)
var cleanTile = Vector2i(15,15)

var enemies := []

# Called when the node enters the scene tree for the first time.
func _ready():
	wave = 0
	enemiesToSpawn = 0
	spawn_enemy()



func _process(delta):
	enemyCount.text = "Wave: "  + str(wave) + "\n" + "Enemies Left: " + str(population) + "\n" + "Enemies Killed: " + str(kills)
	if enemiesToSpawn <= 0 and population <= 0:
		next_wave()
	if enemiesToSpawn > 0 and spawner.is_stopped():
		spawn_enemy() #each wave has a certain number of enemies to spawn
	for i in enemies:
		var tilePosition = layer_1.local_to_map(i.global_position - layer_1.global_position)
		layer_1.set_cell(tilePosition, tileSetNumber, slimeTile) #monster ruins the tiles
	if player != null:
		var tilePosition = layer_1.local_to_map(player.global_position - layer_1.global_position)
		layer_1.set_cell(tilePosition, tileSetNumber, cleanTile) #player cleans the tiles
	else:
		print("player is null")
#enemies spawn in a random position in every time the Spawner timeer goess off
func spawn_enemy():
	enemy = enemy_path.instantiate()
	enemy.global_position = Vector2((randi() % 560)-280 + 2074,(randi() % 310)-155 + 1053)
	get_parent().add_child.call_deferred(enemy)
	enemies.append(enemy)
	spawner.start()
	population += 1
	enemiesToSpawn -= 1
#After every wave the next wave grows by 5
func next_wave(): 
	wave += 1
	initPop += 5
	enemiesToSpawn = initPop
	
func destroy_enemy(enemy):
	enemies.erase(enemy)
	population -= 1
