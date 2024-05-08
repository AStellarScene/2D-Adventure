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
	$ProgressBar.set_value(health) 
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
	

func _on_hit_box_area_entered(area):
	if area.is_in_group("death"):
			$PlayerAnimator/HopPlayer.play()
			$PlayerAnimator/HurtPlayer.play()
			print("Death")
			health = 0
			animated_sprite_2d.animation = "die"
			death = true
	if $"HitBox/Hit Timer".time_left == 0:
		if area.is_in_group("enemy_attack"):
			hurt = true
			$"HitBox/Hit Timer".start()
			animated_sprite_2d.animation = "hurt"
			health = health - 25
			if health == 0:
				$PlayerAnimator/HopPlayer.play()
				$PlayerAnimator/HurtPlayer.play()
				print("Death")
				health = 0
				animated_sprite_2d.animation = "die"
				death = true
				hurt = false
				hop = false
			$PlayerAnimator/HurtPlayer.play()
		if area.is_in_group("enemy_weakness"):
			hop = true
			animated_sprite_2d.animation = "hop"
			$PlayerAnimator/HopPlayer.play()

func _on_hit_timer_timeout():
	$"HitBox/Hit Timer".stop()

func _on_player_animator_frame_changed():
	if %PlayerAnimator.animation == "hurt" && %PlayerAnimator.frame == 4:
		hurt = false
		print("Stop Hurt")
	if %PlayerAnimator.animation == "hop" && %PlayerAnimator.frame == 3:
		hop = false
		print("Stop Hop")
	if %PlayerAnimator.animation == "die" && %PlayerAnimator.frame == 11:
		print("Stop Death")
		position = Vector2(0, 0)   
		health = 100
		death = false
