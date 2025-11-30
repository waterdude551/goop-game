extends Node2D
@onready var player: Node2D = null
@onready var game: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	game = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if  body.is_in_group("player"):
		game.store.show() # store appears when player gets near
		print("store")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if  body.is_in_group("player"):
		game.store.hide() 
