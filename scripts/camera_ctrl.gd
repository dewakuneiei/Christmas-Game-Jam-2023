extends Camera2D

@export_subgroup("Camera Settings")
@export_range(10, 1000, .5) var move_speed : float = 750
@export_range(.1, 1, .01) var zooming: float = .25

const max_zooming: float = 6
const min_zooming: float = 1

# Setup imput event
var input_dir: Vector2 = Vector2.ZERO;


func _process(delta):

	# Control camera by mouse
	#var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	# Control camera by event input
	input_dir = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	).normalized()

	global_transform.origin += input_dir * move_speed * delta

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
