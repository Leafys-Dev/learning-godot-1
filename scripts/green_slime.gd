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
@onready var hurt_sound: AudioStreamPlayer2D = $"Hurt Sound"

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
		hurt_sound.play()
		current_state = State.HURT
		tween_hit_effect()
		
	elif hp == 0: 
		animation_player.call_deferred("play", "death")	
		current_state = State.DEATH

# Hit flash and squash effect
func tween_hit_effect():
	animated_sprite.material.set_shader_parameter("flash_amount", 0.5)
	animated_sprite.scale = Vector2(1.4, 0.6)
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(animated_sprite, "material:shader_parameter/flash_amount", 0.0, 0.2)
	tween.tween_property(animated_sprite, "scale", Vector2(1, 1), 0.2)
	
	# Callback State.WALKING
	tween.chain().tween_callback(func(): current_state = State.WALKING)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		current_state = State.WALKING
