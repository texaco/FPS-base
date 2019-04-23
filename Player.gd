extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 0.3
var camera_change = Vector2()

var velocity = Vector3()
var direction = Vector3()

#fly variables
const FLY_SPEED = 20
const FLY_ACCEL = 4
var flying = false

#walk variables
var gravity = -9.8 * 3
const MAX_SPEED = 10
const MAX_RUNNING_SPEED = 15
const ACCEL = 2
const DEACCEL = 6

#jumping
var jump_height = 10
var in_air = 0
var has_contact = false

#slope variables
const MAX_SLOPE_ANGLE = 10

#stair variables
const MAX_STAIR_SLOPE = 20
const STAIR_JUMP_HEIGHT = 6

# Debug variables
var debug = true

func _process(delta):
	aim()
	if flying:
		fly(delta)
	else:
		walk(delta)

func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative
	if Input.is_action_just_pressed("fly"):
		flying = !flying
	if debug and Input.is_action_just_pressed("ui_page_down"):
		print ($Foot.slopeAngle)
		
func getDirection():
	var dir = Vector3()

	# get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	
	# check input and change direction
	if Input.is_action_pressed("ui_up"):
		dir -= aim.z
	if Input.is_action_pressed("ui_down"):
		dir += aim.z
	if Input.is_action_pressed("ui_left"):
		dir -= aim.x
	if Input.is_action_pressed("ui_right"):
		dir += aim.x
	return dir
	
func walk(delta):
	direction = getDirection()
	
	direction.y = 0
	direction = direction.normalized()
	
	if is_on_floor():
		has_contact = true
		
		if $Foot.getSlopeAngle() > MAX_SLOPE_ANGLE:
			velocity.y += gravity * delta
		
	else:
		if !$Foot.is_colliding():
			has_contact = false
		velocity.y += gravity * delta

	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0, -1, 0))
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("run"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	if has_contact and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
		has_contact = false
	
	# move
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if debug and !has_contact:
		print(in_air)
		in_air += 1
	
func fly(delta):
	# reset the direction of the player
	direction = getDirection()
	
	direction = direction.normalized()
	
	# where would the player go at max speed
	var target = direction * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move
	move_and_slide(velocity)
	
func aim():
	if camera_change.length() > 0:
		$Head.rotate_y(deg2rad(-camera_change.x * mouse_sensitivity))

		var change = -camera_change.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()
