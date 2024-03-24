extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing = "right"

func gravity_state():
	return gravity / abs(gravity)

func _physics_process(delta):

	if (velocity.x >  1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"
	
	if Input.is_action_just_pressed("invert"):
		gravity *= -1
		if gravity > 0:
			up_direction = Vector2.UP
			sprite_2d.flip_v = false
		else:
			up_direction = Vector2.DOWN
			sprite_2d.flip_v = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * gravity_state()

	var direction = Input.get_axis("left", "right")
	if direction:
		var vel = direction * SPEED
		velocity.x = vel
		if vel > 0:
			facing = "right"
		else:
			facing = "left"
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()
	
	if facing == "right":
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true
