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
var nerd_path = preload("res://scenes/enemy.tscn")
var green_path = preload("res://scenes/green.tscn")
var boss_path = preload("res://scenes/raidboss.tscn")

@onready var spawner = $Spawner
@onready var text: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var layer_1: TileMapLayer = $TileMapLayer
@onready var timer: Timer = $Timer
@onready var store: Panel = $CanvasLayer/store
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var countdown: RichTextLabel = $CanvasLayer/countdown
@onready var instructions: Panel = $CanvasLayer/instructions
@onready var skip: Button = $CanvasLayer/Skip


var tileSetNumber = 1
var greenTile = Vector2i(17,15)
var yellowTile = Vector2i(18,15)
var cleanTile = Vector2i(15,15)
var defaultColor = null
var enemies := []

# Called when the node enters the scene tree for the first time.
func _ready():
	instructions.process_mode = Node.PROCESS_MODE_ALWAYS
	population = 0
	wave = 0
	enemiesToSpawn = 0
	defaultColor = canvas_modulate.color #saves the default color value
	canvas_modulate.color = Color("white")
	get_tree().paused = true



func _process(delta):
	var mode = "cleaning"
	if player.shooting:
		mode = "shooting"
	text.text = "Wave: "  + str(wave) + "\nMoney: " + str(player.money) + "\nEnergy: " + str(player.boosts) + "\nMode: " + mode + "\nEsc for menu"
	countdown.text = "Next wave in: " + str(int(timer.time_left))
	if mode == "shooting":
		countdown.text += "\n Weapon: " + player.weapons[player.weaponIndex]
	if enemiesToSpawn <= 0 and population <= 0 and !coolingDown:
		coolingDown = true
		audio.stop()
		timer.start()
		skip.visible = true
		canvas_modulate.color = Color("white")
		
	if enemiesToSpawn > 0 and spawner.is_stopped():
		if randi_range(0,100) < 50:
			spawn_enemy(green_path) #each wave has a certain number of enemies to spawn
		else:
			spawn_enemy(nerd_path) #each wave has a certain number of enemies to spawn
	for i in enemies:
		if i != null:
			var tilePosition = layer_1.local_to_map(i.global_position - layer_1.global_position)
			if i.green:
				layer_1.set_cell(tilePosition, tileSetNumber, greenTile) #monster ruins the tiles
			if i.nerd:
				layer_1.set_cell(tilePosition, tileSetNumber, yellowTile) #slow tiles
		else:
			destroy_enemy(i)
	if player != null:
		var player_pos = layer_1.local_to_map(player.global_position)
		#var adj_pos = layer_1.local_to_map(player.global_position + Vector2(0,32))
		var tile_coords = layer_1.get_cell_atlas_coords(player_pos) #finds the types of tiles the player is on
		if (tile_coords == yellowTile) && !player.sweeping:
			player.SPEED = 100
		else:
			player.SPEED = 600
		if (tile_coords == greenTile) && !player.sweeping:
			player.hp -= 1
		elif player.sweeping:
			var tilePosition = layer_1.local_to_map(player.global_position - layer_1.global_position)
			if layer_1.get_cell_atlas_coords(tilePosition) == greenTile || layer_1.get_cell_atlas_coords(tilePosition) == yellowTile:
				layer_1.set_cell(tilePosition, tileSetNumber, cleanTile) #player cleans the tiles
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(-1,0)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(-1,0)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(-1,0), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(0,-1)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(0,-1)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(0,-1), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(0,1)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(0,1)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(0,1), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(1,0)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(1,0)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(1,0), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(-1,-1)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(-1,-1)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(-1,-1), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(1,1)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(1,1)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(1,1), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(-1,1)) == greenTile  || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(-1,1)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(-1,1), tileSetNumber, cleanTile)
			if layer_1.get_cell_atlas_coords(tilePosition + Vector2i(1,-1)) == greenTile || layer_1.get_cell_atlas_coords(tilePosition + Vector2i(1,-1)) == yellowTile:
				layer_1.set_cell(tilePosition + Vector2i(1,-1), tileSetNumber, cleanTile)
	else:
		print("player is null")
#enemies spawn in a random position in every time the Spawner timeer goess off
func spawn_enemy(enemy_path):
	enemy = enemy_path.instantiate()
	enemy.global_position = Vector2((randi() % 560)-280 + 2074,(randi() % 310)-155 + 1053)
	add_child.call_deferred(enemy)
	enemies.append(enemy)
	spawner.start()
	population += 1
	enemiesToSpawn -= 1
#After every wave the next wave grows by 5
func next_wave(): 
	wave += 1
	if (wave % 10) == 0 and wave > 0:
		spawn_enemy(boss_path)
		initPop += 1
	initPop += 5
	enemiesToSpawn = initPop
	coolingDown = false
	audio.play()
	
func destroy_enemy(enemy):
	enemies.erase(enemy)
	player.money += 5
	population -= 1
	kills += 1
	

func _on_timer_timeout() -> void:
	next_wave()
	skip.visible = false
	canvas_modulate.color = defaultColor # lights turn red when wave begins

func _on_button_pressed() -> void: #purchase energy
	if player.money >= 10:
		player.money -= 10
		player.boosts += 1
	

func _on_button_2_pressed() -> void: #purchase energy
	if player.money >= 20:
		player.money -= 20
		if player.hp <= 80:
			player.hp += 20
		else:
			player.hp = 100
	print(str(player.money))

func _on_button_3_pressed() -> void:
	if player.money >= 50 and !("pistol" in player.weapons):
		player.money -= 50
		player.weapons.append("pistol")

func _on_button_4_pressed() -> void:
	if player.money >= 100 and !("shotgun" in player.weapons):
		player.money -= 100
		player.weapons.append("shotgun")


func _on_button_button_down() -> void:
	instructions.visible = false
	get_tree().paused = false


func _on_skip_button_down() -> void:
	timer.stop()
	timer.emit_signal("timeout")
