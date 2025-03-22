extends Area2D

@export var damage: float = 5.0
@export var duration: float = 0.5

func _ready():
	$SwordDuration.start(duration)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group(get_parent().enemyTeam):
		print("enemy area entered")
		area.get_parent().takeDamage(damage)

func _on_sword_duration_timeout() -> void:
	queue_free()
