extends Area2D

@onready var green_slime: Node2D = $".."
@onready var green_slime2: Node2D = $".."

func _on_body_entered(body: Node2D) -> void:
	# Check if player is on air
	if body.velocity.y > 0:
		# Bounce player off slime
		body.velocity.y = -250
		
		# Trigger -1 HP
		green_slime.on_hit()
