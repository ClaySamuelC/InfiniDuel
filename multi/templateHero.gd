extends CharacterBody2D

const SPEED = 30.0

var startingHealth = 100
var currentHealth = startingHealth

var startingDamage = 1
var currentDamage = startingDamage

@export var myTeam : String
@export var enemyTeam : String

var uninteruptable_animations
@onready var animationPlayer = $AnimationPlayer

func _ready():
	add_to_group(myTeam)

func _physics_process(delta):
	pass
	
func takeDamage(damage : int):
	currentHealth -= damage
