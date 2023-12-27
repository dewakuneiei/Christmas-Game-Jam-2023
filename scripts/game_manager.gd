extends Node2D
class_name GameManager

static var instance: GameManager;

@export var game_ui: ScoreBoardUI;
@export var parent_trees: NodePath
@export var all_points: Array[TreePoint]

var _blue_score: int;
var _red_score: int;
var _green_score: int;
var _black_score: int;

func add_red_score():
	_red_score += 1;
	game_ui.update_label_1(str(_red_score))

func add_green_score():
	_green_score += 1;
	game_ui.update_label_2(str(_green_score))

func add_blue_score():
	_blue_score += 1;
	game_ui.update_label_3(str(_blue_score))

func add_black_score():
	_black_score += 1;
	game_ui.update_label_4(str(_black_score))

func _ready():
	all_points = []
	for point in get_node(parent_trees).get_children():
		if point is TreePoint:
			all_points.append(point)


func _init():
	self.instance = self
	_black_score = 0
	_red_score = 0
	_green_score = 0
	_black_score = 0

### For the point
func get_point(index: int) -> TreePoint:
	return all_points[index]

func get_all_points() -> Array[TreePoint] :
	return all_points
	
func get_parent_size() -> int :
	return all_points.size()


