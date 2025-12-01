extends Control

func _ready() -> void:
	resume()
	process_mode = Node.PROCESS_MODE_ALWAYS
	$TextureRect.visible = false
func resume():
	get_tree().paused = false
	visible = false
	$TextureRect.visible = false
func pause():
	get_tree().paused = true
	visible = true
	
func openPause():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
		print_debug("hello")
		resume()

func _on_controls_pressed() -> void:
	$TextureRect.visible = !$TextureRect.visible

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _process(delta):
	openPause()
