extends Node2D

enum State {WALKING, HURT, DEATH}

const RIGHT = 1
const LEFT = -1

var current_state: State = State.WALKING

@export var speed = 50
var hp = 3
var direction = RIGHT

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

@onready var enemy_hit_zone: Area2D = $"Enemy Hit Zone"
@onready var killzone: Area2D = $Killzone


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_state:
		State.WALKING:
			animated_sprite.play("walking")
			position.x += direction * speed * delta
			
			if ray_cast_left.is_colliding():
				direction = RIGHT
				animated_sprite.flip_h = false
			elif ray_cast_right.is_colliding():
				direction = LEFT
				animated_sprite.flip_h = true
				
		State.HURT:
			pass
		State.DEATH:
			pass

func on_hit():
	hp -= 1
	
	if hp > 0:
		current_state = State.HURT
		animation_player.call_deferred("play", "hurt")
	elif hp == 0: 
		animation_player.call_deferred("play", "death")	
		current_state = State.DEATH


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		current_state = State.WALKING
