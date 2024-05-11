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
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	# Animator
	if hurt == false && hop == false && death == false:
		if (velocity.x > 1 || velocity.x < -1):
			if is_on_floor():
				animated_sprite_2d.animation = "walking"
			else:
				animated_sprite_2d.animation = "jumping"
		else:
			animated_sprite_2d.animation = "idle"

	# Gravity & Physics Process
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump input.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

# Apply input direction and apply knock-back.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if hurt == true:
		velocity.x = -600
		velocity.y = -30

	move_and_slide()

# Start knockback when hit by an enemy.
func _on_hurt_area_area_entered(area):
	if area.is_in_group("enemy"):
		print("Hurt!")
		hurt = true
		$"Hurt Area/Hurt Timer".start()

# Stop knockback after timer ends.
func _on_hurt_timer_timeout():
	$"Hurt Area/Hurt Timer".stop()
	hurt = false
