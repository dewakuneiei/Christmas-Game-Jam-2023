extends Camera2D

@export_subgroup("Camera Settings")
@export_range(50, 1000, .5) var move_speed : float = 750
@export_range(.1, 1, .01) var zooming: float = .25
@export_subgroup("First Move Point")
@export var red_point: Marker2D;
@export var green_point: Marker2D;
@export var blue_point: Marker2D;
@export var black_point: Marker2D;

@export_subgroup("camera limit custom")
@export var top_side: int = -1200;
@export var right_side: int = 2000;
@export var bottom_side: int = 2000;
@export var left_side: int = -2000;

const MAX_MOVE_SPEED = 500
const MIN_MOVE_SPEED = 100
const MOVE_SPEED_CALULATE = 50

const max_zooming: float = 6
const min_zooming: float = 1

# Setup
var move_dir: Vector2 = Vector2.ZERO;
var can_player_control: bool = false;
var target_first_point: Vector2;
var mouse_pos: Vector2

#viewport MARGIN point
const MARGIN = 25

func _ready():
	match  PlayerSingleton.player_team:
		CultTeam.Team.RED:
			target_first_point = red_point.global_position
		CultTeam.Team.GREEN:
			target_first_point = green_point.global_position
		CultTeam.Team.BLUE:
			target_first_point = blue_point.global_position
		CultTeam.Team.BLACK:
			target_first_point = black_point.global_position

func _process(delta):
	
	if(can_player_control):
		move_base_on_mouse(delta)
		move_base_on_keyboard(delta)
		limit_camera_move()

	else:
		
		move_dir = global_position.direction_to(target_first_point)
		global_transform.origin += move_dir * move_speed * delta

		if( global_position.distance_to(target_first_point) < 10):
			can_player_control = true

func move_base_on_mouse(delta: float):
		var viewport_size = get_viewport().size
		
		if(mouse_pos.x <= MARGIN):
			# on left
			move_dir.x = -1
		if(mouse_pos.x >= viewport_size.x - MARGIN):
			#right
			move_dir.x = 1
		if(mouse_pos.y <= MARGIN):
			#top
			move_dir.y = -1
		if(mouse_pos.y >= viewport_size.y - MARGIN):
			#bottom
			move_dir.y = 1

		global_transform.origin += move_dir * move_speed * delta

func move_base_on_keyboard(delta: float):
	move_dir = Vector2(
	int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
	int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	).normalized()
	
	global_transform.origin += move_dir * move_speed * delta

func limit_camera_move():
		if(global_position.x > right_side):
			global_position.x = right_side
		if(global_position.x < left_side):
			global_position.x = left_side
		if(global_position.y > bottom_side):
			global_position.y = bottom_side
		if(global_position.y < top_side):
			global_position.y = top_side

func _unhandled_input(event):
	# Zooming
	if (event is InputEventMouseButton and
		event.is_action("zoom-in") and
		_is_can_zoom_in() and 
		can_player_control):
			
		zoom += Vector2.ONE * zooming
		move_speed = clamp(move_speed - MOVE_SPEED_CALULATE, MIN_MOVE_SPEED, MAX_MOVE_SPEED)


	elif(event is InputEventMouseButton and
		event.is_action("zoom-out") and
		_is_can_zoom_out() and
		can_player_control):
			
		zoom -= Vector2.ONE * zooming
		move_speed = clamp(move_speed + MOVE_SPEED_CALULATE, MIN_MOVE_SPEED, MAX_MOVE_SPEED)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = event.position

func _is_can_zoom_in() -> int:
	if zoom.x >= max_zooming or zoom.y >= max_zooming:
		return false
	return true

func _is_can_zoom_out() -> int:
	if zoom.x <= min_zooming or zoom.y <= min_zooming:
		return false
	return true
