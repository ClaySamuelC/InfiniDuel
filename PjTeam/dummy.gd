extends CharacterBody2D

var startingHealth = 100
var currentHealth = startingHealth

@export var myTeam : String
@export var enemyTeam : String

func _ready():
	add_to_group(myTeam)

func takeDamage(damage : int):
	currentHealth -= damage
