extends CharacterBody3D

#var related to movement
#speeds
var SPEED = 10.0
var crouch_speed = 6.0
var walk_speed = 10.0
var sprint_speed = 17.0
var JUMP_VELOCITY = 9.0
var gravity = 9.8
var last_velocity = Vector3.ZERO
var anchor_fall_value = 100
var extra_velocity = Vector3.ZERO

#states
var walking = false
var sprinting = false
var crouching = false
var free_looking = false
var sliding = false
var jumping = false
var wall_running = false
var anchor_fall = false
var falling = false
var dashing = false
#animations
@onready var camera_cnimations = $"neck/head/eyes/camera cnimations"

# enemystep
var enemy_step_amount = 0
#Collosion shapes
@onready var standing_collision = $"Standing col"
@onready var crouching_collision = $"crouching col"
@onready var crouching_raycast = $Crouch_check


# var related to camera
@onready var view_model_camera = $"."
@onready var weapon_camera = $neck/head/eyes/Camera3D/SubViewportContainer/SubViewport/View_model_camera
@onready var crosshair_cam: TextureRect = $neck/head/eyes/Camera3D/SubViewportContainer/TextureRect


@onready var eyes = $neck/head/eyes
@onready var head = $neck/head
@onready var player_camera = $neck/head/eyes/Camera3D
@onready var neck = $neck
var mouse_sense = 0.25
var camera_lcok = true
var crouching_depth = -0.25
var free_look_tilt_amount = 5
var slide_tilt_direction = Vector2.ZERO
var camera_direction = Vector3.ZERO
const head_bobbing_speed_sprint = 22
const head_bobbing_speed_walk = 14
const head_bobbing_speed_crouch = 10

const head_bobbing_intensity_sprint = 0.25
const head_bobbing_intensity_walk = 0.25 / 2
const head_bobbing_intensity_crouch = 0.05

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

@onready var wall_run_check_right = $Wall_run_check_right
@onready var wall_run_check_left = $Wall_run_check_left


#LERP
var direction = Vector3.ZERO
var lerp_speed = 10.0
var air_lerp_speed = 5.0

#abilities
#jumping
var doublejump_cooldown = false

#dashing
var dash_cooldown = 0
var dash_velocity_multi = 100
var dash_vector = Vector2.ZERO
var dash_direction = Vector3.ZERO
var dash_speed_air = 400.0
var dash_speed_floor = 400.0
var aim_vector = 0
var dash_cooldown_countdown = 0.1
@onready var crosshair = $neck/head/eyes/Camera3D/Sprite3D

#sliding
var slide_timer = 0.0
var slide_timer_max = 2.0
var slide_vector = Vector2.ZERO
var slide_speed = 17

#wall running
var wall_running_vector = Vector3.ZERO
var wall_running_speed = Vector3.ZERO
var wall_run_direction = Vector3.ZERO
	

#handles camera
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$neck/head/eyes/Camera3D/SubViewportContainer2/SubViewport.size = DisplayServer.window_get_size()

func _input(event):
	if event is InputEventMouseMotion:
		
		if free_looking:
			neck.rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
			neck.rotation.y = clamp(neck.rotation. y,deg_to_rad(-145),deg_to_rad(145))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation. x,deg_to_rad(-89),deg_to_rad(89))
		camera_direction = player_camera.get_global_transform().basis


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and wall_running == false or dashing == true :
		velocity.y += -gravity * delta
		falling = true
		if anchor_fall == true:
			velocity.x = 0.0
			velocity.z = 0.0
			velocity.y += -anchor_fall_value * delta
			if area_3d.get_overlapping_bodies():
				var enemy_slam_list = area_3d.get_overlapping_bodies()
				enemyslam(enemy_slam_list)
				
	else:
		if is_on_floor():
			doublejump_cooldown = false
			falling = false
	#speed affecting the camera
	player_camera.fov = 75 * (1+ SPEED/100)
	
	#decides direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#unlocks camera remove after testing
	if Input.is_action_just_pressed("fmc"):
		if camera_lcok == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			camera_lcok = false
		else:
			camera_lcok = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#state type movement
	#crouching
	if Input.is_action_pressed("crouch") and is_on_floor() == false and Input.is_action_pressed("sprint") == false:
		anchor_fall = true
	else:
		anchor_fall = false
	if Input.is_action_pressed("crouch") and sliding == false and is_on_floor():
		head.position.y = lerp(head.position.y,crouching_depth,delta*lerp_speed)
		standing_collision.disabled = true
		crouching_collision.disabled = false

		#start of slide
		if sprinting and input_dir != Vector2.ZERO and is_on_floor():
			sliding = true
			slide_vector = input_dir
			free_looking = true
			slide_timer = slide_timer_max
			SPEED = abs(last_velocity.x) + abs(last_velocity.z)
		else:
			SPEED = lerp(SPEED,crouch_speed,delta*lerp_speed)
		walking = false
		sprinting = false
		crouching = false
	elif !crouching_raycast.is_colliding():
		#not crouching
		standing_collision.disabled = false
		crouching_collision.disabled = true
		head.position.y = lerp(head.position.y,0.0,delta*lerp_speed)
		#sprint
		if sliding == false:
			if Input.is_action_pressed("sprint"):
				SPEED =  lerp(SPEED,sprint_speed,delta*lerp_speed)
				walking = false
				sprinting = true
				crouching = false
			else:
				SPEED =  lerp(SPEED,walk_speed,delta*lerp_speed)
				walking = true
				sprinting = false
				crouching = false
	# handles dash
	if Input.is_action_pressed("dash") and dash_cooldown <= 0:
		dashing = true
		crouching = false
		dash_cooldown = 3
		dash_direction = input_dir
	elif  dash_cooldown > 0:
		dash_cooldown += -2 * delta
	#handles free looking
	if Input.is_action_pressed("freelook") or sliding: # or wall_running:
		free_looking = true
		if sliding:
			if slide_vector.x >= 0.1:
				eyes.rotation.z = lerp(eyes.rotation.z,-deg_to_rad(6),delta*lerp_speed)
			else:
				eyes.rotation.z = lerp(eyes.rotation.z,-deg_to_rad(-6),delta*lerp_speed)
		else:
			eyes.rotation.z = -deg_to_rad(neck.rotation.y*free_look_tilt_amount)
	else:
		free_looking = false
		eyes.rotation.z = lerp(eyes.rotation.z,0.0,delta*lerp_speed)
		neck.rotation.y = lerp(neck.rotation.y,0.0,delta*lerp_speed)
	
	
	#slide end
	if sliding:
		slide_timer -= delta
		if slide_timer <= 1:
			sliding = false
			free_looking = false
			
	#head bobbing logic
	if sprinting:
		head_bobbing_current_intensity = head_bobbing_intensity_sprint
		head_bobbing_index += head_bobbing_speed_sprint*delta
	elif walking:
		head_bobbing_current_intensity = head_bobbing_intensity_walk
		head_bobbing_index += head_bobbing_speed_walk*delta
	elif crouching:
		head_bobbing_current_intensity = head_bobbing_intensity_crouch
		head_bobbing_index += head_bobbing_speed_crouch*delta
	
	if is_on_floor() and !sliding and input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2) + 0.5
	
		eyes.position.y = lerp(eyes.position.y,head_bobbing_vector.y*(head_bobbing_current_intensity/2.0),delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x,head_bobbing_vector.x*head_bobbing_current_intensity,delta*lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y,head_bobbing_vector.y*0.0,delta*lerp_speed)
		eyes.position.x = lerp(eyes.position.x,head_bobbing_vector.x*0.0,delta*lerp_speed)		

	# Handle jump.
	if !crouching_raycast.is_colliding() == true:
		if Input.is_action_just_pressed("jump"):
			sliding = false
			dashing = false
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				camera_cnimations.play("jumping_animation")
			elif enemy_step_amount > 1:
				enemystep()
			elif wall_run_check_right.is_colliding() == true or wall_run_check_left.is_colliding() == true and Input.is_action_pressed("jump"): # wall run start
				if wall_run_check_right.is_colliding() == true:
					camera_cnimations.play("wall_run_right")
					wall_running = true
					wall_running_vector = Vector3(input_dir.x,0.0,input_dir.y)
					velocity.y = 0
					SPEED = abs(last_velocity.x) + abs(last_velocity.z)
				elif wall_run_check_left.is_colliding() == true:
					camera_cnimations.play("wall_run_left")
					wall_running = true
					wall_running_vector = Vector3(input_dir.x,0.0,input_dir.y)
					velocity.y = 0
					SPEED = abs(last_velocity.x) + abs(last_velocity.z)
			elif doublejump_cooldown == false and is_on_floor() == false and wall_running == false:
				velocity.y = JUMP_VELOCITY - 1
				camera_cnimations.play("jumping_animation")
				direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*air_lerp_speed) # lets the player have full control of air movement during a double jump (faster direction changing)
				doublejump_cooldown = true
				camera_cnimations.play("jumping_animation")
	if wall_running == true:
		doublejump_cooldown = false
		if wall_run_check_left.is_colliding() == false and wall_run_check_right.is_colliding() == false:
			wall_running = false
			free_looking = false
			camera_cnimations.play("RESET")
		elif Input.is_action_just_released("jump") or anchor_fall == true:
			wall_running = false
			free_looking = false
			camera_cnimations.play("RESET")
			velocity.y = JUMP_VELOCITY * 0.75
	#handles landing animations
	if is_on_floor():
		if last_velocity.y <-15.0:
			camera_cnimations.play("rolling_animation")
		elif last_velocity.y < -2.0:
			camera_cnimations.play("landing_animation")
	if is_on_floor() == true:
		if SPEED >= 35: # max speed of player
			SPEED = 35.0
		if sliding == true:
			if SPEED >= 25: # max speed of player
				SPEED = 25.0
	else:
		if dashing:
			if SPEED >= 35: # max speed of player
				SPEED = 35.0
		else:
			if SPEED >= 25: # max air speed of player
				SPEED = 25.0

			
	# Get the input direction and handle the movement/deceleration.
	if is_on_floor():
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x,0.0, input_dir.y)).normalized(),delta*lerp_speed)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*air_lerp_speed)
	if sliding:
		if dashing == false:
			direction = (transform.basis * Vector3(slide_vector.x,0.0,slide_vector.y)).normalized()
			if direction == Vector3.ZERO:
				direction = (transform.basis * Vector3(0,0.0,-1)).normalized() 
			velocity.z = direction.z * (slide_timer + 0.1) * SPEED * 100
	if wall_running:
		if !wall_running_vector.z == 0:
			direction = (transform.basis * Vector3(0,0.0,wall_running_vector.z)).normalized() #place holder
		else:	
			direction = (transform.basis * Vector3(0,0.0,-1)).normalized()
		dashing = false
	if dashing:
		if dash_cooldown >= 2.5:
			sliding = false
			crouching = false
			if dash_cooldown >= 2.7:
				velocity.y = 0
			direction = (transform.basis * Vector3(dash_direction.x,0.0, dash_direction.y)).normalized()
			if is_on_floor():
				SPEED += dash_speed_floor * delta
			else:
				SPEED += dash_speed_air * delta
			if direction == Vector3.ZERO:
				direction = (transform.basis * Vector3(0,0.0,-1)).normalized()
		else:
			dashing = false
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED 
	else:
		if dashing == false or anchor_fall == true:
			velocity.x = move_toward(velocity.x, 0, SPEED) 
			velocity.z = move_toward(velocity.z, 0, SPEED)
	last_velocity = velocity
	move_and_slide()

func _on_area_3d_body_exited(body: Node3D) -> void:
	enemy_step_amount -= 1
	pass # Replace with function body.


func _on_area_3d_body_entered(body: Node3D) -> void:
	enemy_step_amount += 1
	pass # Replace with function body.
@onready var area_3d: Area3D = $Area3D
func enemystep():
	velocity.y = JUMP_VELOCITY
	var list= area_3d.get_overlapping_bodies()
	for i in list:
		if i.is_in_group("enemy"):
			i.stun()

func enemyslam(list):
	var damage = 3
	for i in list:
		if i.is_in_group("enemy"):
			i.hit(damage)
		
