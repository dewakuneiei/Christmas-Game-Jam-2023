extends Camera2D

@export_subgroup("Camera Settings")
@export_range(10, 1000, .5) var move_speed : float = 750
@export_range(.1, 1, .01) var zooming: float = .25
@export_subgroup("First Move Point")
@export var red_point: Marker2D;
@export var green_point: Marker2D;
@export var blue_point: Marker2D;
@export var black_point: Marker2D;

const max_zooming: float = 6
const min_zooming: float = 1

# Setup
var move_dir: Vector2 = Vector2.ZERO;
var can_player_control: bool = false;
var target_first_point: Vector2;

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
		move_dir = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		).normalized()
		
		global_transform.origin += move_dir * move_speed * delta
	else:
		move_dir = global_position.direction_to(target_first_point)
		global_transform.origin += move_dir * move_speed * delta

		if( global_position.distance_to(target_first_point) < 5):
			can_player_control = true

	

func _unhandled_input(event):
	# Zooming
	if event is InputEventMouseButton and event.is_action("zoom-in") and _is_can_zoom_in() :
		zoom += Vector2.ONE * zooming
	elif event is InputEventMouseButton and event.is_action("zoom-out") and _is_can_zoom_out():
		zoom -= Vector2.ONE * zooming

func _is_can_zoom_in() -> int:
	if zoom.x >= max_zooming or zoom.y >= max_zooming:
		return false
	return true

func _is_can_zoom_out() -> int:
	if zoom.x <= min_zooming or zoom.y <= min_zooming:
		return false
	return true
