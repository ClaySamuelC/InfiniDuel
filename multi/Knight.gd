extends CharacterBody2D

@export var speed = 100.0

@onready var sword_scene = load("res://scenes/sword.tscn")

var range: float = 100.0

var startingHealth = 100
var currentHealth = startingHealth

var startingDamage = 1
var currentDamage = startingDamage

@export var myTeam : String
@export var enemyTeam : String

var uninteruptable_animations
@onready var animationPlayer = $AnimationPlayer

@onready var attack_timer = $AttackTimer
@export var attack_cd: float = 1.0
var can_attack: bool = true

var is_dead: bool = false

var target: Node2D
var rotation_vector: Vector2 = Vector2.RIGHT
@export var aquisition_range = 125.0

func _ready():
	add_to_group(myTeam)
	idle()

func _process(delta):
	if is_dead:
		return
	if currentHealth <= 0:
		die()
		is_dead = true
	if target == null:
		target = get_target()
	if target != null:
		var distance_to_target = global_position.distance_to(target.global_position)
		rotation_vector = (target.global_position - global_position).normalized()
		if distance_to_target > aquisition_range:
			velocity = rotation_vector * speed
			
			move_and_slide()
		else:
			if can_attack:
				print("attacking")
				attack()



func attack():
	animationPlayer.play("attack_anim")
	can_attack = false
	attack_timer.start(attack_cd)
	
	var sword = sword_scene.instantiate()
	sword.position = rotation_vector * range
	add_child(sword)

func die():
	animationPlayer.play("die_anim")

func idle():
	animationPlayer.play("idle_anim")

func _physics_process(delta):
	pass
	
func takeDamage(damage : int):
	currentHealth -= damage

func get_target():
	var hisTeam = get_tree().get_nodes_in_group(enemyTeam)
	if hisTeam.size() > 0:
		print("Target found")
		return hisTeam.pick_random()
	print("Target not found")
	return null


func _on_attack_cd_timeout() -> void:
	can_attack = true
