extends CharacterBody2D

@export var speed = 300
var direction : Vector2

func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	direction = direction.normalized()

	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		
	move_and_slide()
