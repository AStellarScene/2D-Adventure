extends CharacterBody2D

const SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = -1
var special = false

func _ready():
	pass
# Physics process and gravity.
func _physics_process(delta):
	apply_gravity(delta)
	update_horizontal_movement()
	move_slide()
# Flip direction if the enemy runs into a wall.
func update_horizontal_movement():
	if is_on_wall():
		direction = direction * -1

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Set velocity and apply movement.
func move_slide():
	velocity.x = SPEED * direction
	velocity.y += 20 
	move_and_slide()
	update_animation()

# Play the correct animation for the sequence.
func update_animation():
	if special:
		$AnimatedSprite2D.animation = "attack"
	else:
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walking"
		else:
			$AnimatedSprite2D.animation = "idle" 
		$AnimatedSprite2D.flip_h = velocity.x < 0
