extends CharacterBody2D

const SPEED = 30.0

var startingHealth = 100
var currentHealth = startingHealth

var startingDamage = 1
var currentDamage = startingDamage

@export var myTeam : String
@export var enemyTeam : String

var target

var attack_range = 100

var tickTimer = 150
var tick = 0

var listOfFighters = ["res://PjTeam/fighter.tscn"]

var uninteruptable_animations
@onready var animationPlayer = $AnimationPlayer

@export var orbit_radius: float = 375.0    # Distance from center
@export var angular_speed: float = .4    # Radians per second
@export var center_node: Node2D           # Assign in editor to set center point

var current_angle: float = 0.0
var is_circling: bool = false  # Track circling state
func _ready():
	$Engine.play("engine")
	add_to_group(myTeam)

func _physics_process(delta):
	handleMovement(delta)
	tick += 1
	if tick >= tickTimer:
		tick = 0
		if GameManager.activeFighterCount < 4:
			GameManager.activeFighterCount += 1
			spawn_fighter(listOfFighters.pick_random())
			print("spawning fighter")
			pass
		pass
	#if tick timer is ready and there are less than x active figheters
	#Spawn random fighter
	
	#Fly around randomly? Try to keep x distance from enemy
	pass

func takeDamage(damage : int):
	currentHealth -= damage
	if currentHealth < 150:
		queue_free()

func spawn_fighter(path : String):
		var worker = load(path)
		worker.set_local_to_scene(true)
		var unpacked = worker.instantiate()
		unpacked.target = getTarget()
		unpacked.myTeam = myTeam
		unpacked.enemyTeam = enemyTeam
		get_window().add_child.call_deferred(unpacked)
		unpacked.set_global_position((self.global_position) + Vector2(randi_range(1,3),randi_range(1,3)))

func getTarget():
	var hisTeam = get_tree().get_nodes_in_group("G-Man")
	if hisTeam.size() > 0:
		var t =  hisTeam.pick_random()
		target = t
		return t
	else:
		return null

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

func handleMovement(delta):
	if target:
		var to_target = target.global_position - global_position
		if(to_target.length() > orbit_radius):
			is_circling = false  # Reset circling state when out of range
			fly()
		else:
			if not is_circling:
				# Calculate initial angle based on current position when entering orbit
				var offset = global_position - target.global_position
				current_angle = offset.angle()
				is_circling = true
			circleTarget(delta)
