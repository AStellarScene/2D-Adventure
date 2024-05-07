extends CharacterBody2D

const SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = -1
var special = false

func _ready():
	pass

func _physics_process(delta):
	apply_gravity(delta)
	update_horizontal_movement()
	move_slide()

func update_horizontal_movement():
	if is_on_wall():
		direction = direction * -1

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func move_slide():
	velocity.x = SPEED * direction
	velocity.y += 20 
	move_and_slide()
	update_animation()

func update_animation():
	if special:
		$AnimatedSprite2D.animation = "attack"
	else:
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walking"
		else:
			$AnimatedSprite2D.animation = "idle" 
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_head_hit_area_entered(area):
	update_animation() 
	special = true
	print("Head Hit")

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == 1:
		special = false
