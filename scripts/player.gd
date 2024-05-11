extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback = Vector2.ZERO

var hurt = false
var hop = false
var death = false

var health = 100

@onready var animated_sprite_2d = $PlayerAnimator

func _physics_process(delta):
	# Handle animation.
	if hurt == false && hop == false && death == false:
		if (velocity.x > 1 || velocity.x < -1):
			if is_on_floor():
				animated_sprite_2d.animation = "walking"
			else:
				animated_sprite_2d.animation = "jumping"
		else:
			animated_sprite_2d.animation = "idle"

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if hurt == true:
		velocity.x = -300

	move_and_slide()

	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	
# Reset player if out of bounds.
