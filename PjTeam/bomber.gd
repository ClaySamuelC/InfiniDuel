extends CharacterBody2D

const SPEED = 45.0

@export var myTeam : String
@export var enemyTeam : String

var lifeTimer = 100
var lifeTick = 0

var target

var current_angle: float = 0.0

var bombing = false
func _ready():
	$Engine.play("engine")
	add_to_group(myTeam)

func _physics_process(delta):
	if !target:
		return  # Safety check
		
	var to_target = target.global_position - global_position
	if(to_target.length() > 10):
		rotation = (target.global_position - global_position).angle() + PI/2
		fly()
	else:
		lifeTick += 1
		if lifeTick > lifeTimer:
			GameManager.activeFighterCount -= 1
			queue_free()
		move_and_slide()
		if !bombing:
			bombing = true
			$Bomb.play("bomb")

func fly():
	var to_target = target.global_position - global_position
	velocity = to_target.normalized() * SPEED  # Set velocity towards target
	move_and_slide()  # Apply movement and handle collisions
