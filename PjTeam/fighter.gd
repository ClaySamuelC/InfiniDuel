extends CharacterBody2D

const SPEED = 75.0

@export var myTeam : String
@export var enemyTeam : String

var tickTimer = 150
var tick = 0
var lifeTimer = 900
var lifeTick = 0

var target

@export var orbit_radius: float = 100.0    # Distance from center
@export var angular_speed: float = 1.2    # Radians per second
@export var center_node: Node2D           # Assign in editor to set center point

var current_angle: float = 0.0
var is_circling: bool = false  # Track circling state

func _ready():
	$Engine.play("engine")
	add_to_group(myTeam)

func _physics_process(delta):
	if !center_node:
		if target:
			center_node = target
		else:
			return  # Safety check
		rotation = (center_node.global_position - global_position).angle() + PI/2

	var to_target = target.global_position - global_position
	if(to_target.length() > 100):
		is_circling = false  # Reset circling state when out of range
		fly()
	else:
		if not is_circling:
			# Calculate initial angle based on current position when entering orbit
			var offset = global_position - target.global_position
			current_angle = offset.angle()
			is_circling = true
		circleTarget(delta)
		tick += 1
		if tick >= tickTimer:
			tick = 0
			lifeTick += 1
			spawnRocket()
			if lifeTick > lifeTimer:
				GameManager.activeFighterCount -= 1
				queue_free()

func circleTarget(delta):
	if !center_node:
		if target:
			center_node = target
		else:
			return  # Safety check

	# Update orbital position
	current_angle += angular_speed * delta
	var new_position = center_node.global_position + Vector2(
		cos(current_angle) * orbit_radius,
		sin(current_angle) * orbit_radius
	)

	# Set position and rotation
	global_position = new_position
	rotation = (center_node.global_position - global_position).angle() + PI/2

func fly():
	var to_target = target.global_position - global_position
	velocity = to_target.normalized() * SPEED  # Set velocity towards target
	move_and_slide()  # Apply movement and handle collisions

func spawnRocket():
		var worker = load("res://PjTeam/rocket.tscn")
		worker.set_local_to_scene(true)
		var unpacked = worker.instantiate()
		unpacked.target = target
		get_window().add_child.call_deferred(unpacked)
		unpacked.set_global_position((self.global_position) + Vector2(randi_range(1,3),randi_range(1,3)))
