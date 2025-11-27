extends Node2D
var wave = 0;
var enemiesToSpawn = 0;
var population = 0;
var kills = 0;
var initPop = 0;
var coolingDown = true;
@onready var enemy: Node2D = null #enemies will be spawned repeatedly
@onready var player: Node2D = null
@onready var game: Node2D = null
var enemy_path = preload("res://scenes/enemy.tscn")
var green_path = preload("res://scenes/green.tscn")

@onready var spawner = $Spawner
@onready var text: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var layer_1: TileMapLayer = $TileMapLayer
@onready var timer: Timer = $Timer


var tileSetNumber = 1
var greenTile = Vector2i(17,15)
var yellowTile = Vector2i(18,15)
var cleanTile = Vector2i(15,15)

var enemies := []

# Called when the node enters the scene tree for the first time.
func _ready():
	population = 0
	wave = 0
	enemiesToSpawn = 0



func _process(delta):
	text.text = "Wave: "  + str(wave) + "\n" + "Enemies Left: " + str(population) + "\n" + "Enemies Killed: " + str(kills)
	if enemiesToSpawn <= 0 and population <= 0 and !coolingDown:
		coolingDown = true
		timer.start()
		
	if enemiesToSpawn > 0 and spawner.is_stopped():
		spawn_enemy() #each wave has a certain number of enemies to spawn
	for i in enemies:
		if i != null:
			var tilePosition = layer_1.local_to_map(i.global_position - layer_1.global_position)
			if i.green:
				layer_1.set_cell(tilePosition, tileSetNumber, greenTile) #monster ruins the tiles
			if i.nerd:
				layer_1.set_cell(tilePosition, tileSetNumber, yellowTile)
		else:
			destroy_enemy(i)
	if player != null:
		var player_pos = layer_1.local_to_map(player.global_position)
		var tile_coords = layer_1.get_cell_atlas_coords(player_pos)
		#var tile_id = layer_1.get_cell(tile_coords.x, tile_coords.y)
		if (tile_coords == yellowTile) && !player.sweeping:
			player.SPEED = 100
		else:
			player.SPEED = 600
		if (tile_coords == greenTile) && !player.sweeping:
			player.hp -= 1
		elif player.sweeping:
			var tilePosition = layer_1.local_to_map(player.global_position - layer_1.global_position)
			layer_1.set_cell(tilePosition, tileSetNumber, cleanTile) #player cleans the tiles
	else:
		print("player is null")
#enemies spawn in a random position in every time the Spawner timeer goess off
func spawn_enemy():
	enemy = enemy_path.instantiate()
	if randi_range(0,100) < 50: #25% chance of spawning special enemy
		enemy = green_path.instantiate()
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
	coolingDown = false
	
func destroy_enemy(enemy):
	enemies.erase(enemy)
	population -= 1
	kills += 1
	

func _on_timer_timeout() -> void:
	next_wave()
