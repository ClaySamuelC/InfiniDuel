extends CharacterBody2D

const SPEED = 18.0

var target

func _physics_process(delta):
	var to_target = target.global_position - global_position
	velocity = to_target.normalized() * SPEED  # Set velocity towards target
	move_and_slide()  # Apply movement and handle collisions
	rotation = (target.global_position - global_position).angle() + PI/2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("G-Man"):
		body.takeDamage(3)
		print("Gotcha")
		self.queue_free()
