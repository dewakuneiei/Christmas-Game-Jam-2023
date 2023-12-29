extends Node2D
class_name GameManager

static var instance: GameManager;

@export var player_ctrl: PlayerControl; 
@export var game_ui: ScoreBoardUI;
@export var parent_trees: NodePath
@export var all_points: Array[TreePoint]

@export_subgroup("Character Settings")
@export var red_max_amout: int = 3;
@export var green_max_amout: int = 3;
@export var blue_max_amout: int = 3;
@export var black_max_amout: int = 3;

@export_subgroup("Game Setting")
@export var end_at_point: int = 10 

var is_game_ended: bool = false

### Counting
var red_cult_amount :int;
var green_cult_amount:int;
var blue_cult_amount:int;
var black_cult_amount:int;

var count_red_tree: int;
var count_green_tree: int;
var count_blue_tree: int;
var count_black_tree: int;

### Show on score board
var _blue_score: int;
var _red_score: int;
var _green_score: int;
var _black_score: int;

func ended_game():
	is_game_ended = true;
	print("game is ended")


func add_red_score():
	_red_score += 1;
	game_ui.update_label_1(str(_red_score))
	
	if(_red_score >= end_at_point):
		ended_game()

func add_green_score():
	_green_score += 1;
	game_ui.update_label_2(str(_green_score))
	
	if(_green_score >= end_at_point):
		ended_game()

func add_blue_score():
	_blue_score += 1;
	game_ui.update_label_3(str(_blue_score))
	
	if(_blue_score >= end_at_point):
		ended_game()

func add_black_score():
	_black_score += 1;
	game_ui.update_label_4(str(_black_score))
	
	if(_black_score >= end_at_point):
		ended_game()

func _ready():
	_check_population()
	_load_all_tree_point()

func _load_all_tree_point():
	all_points = []
	for point in get_node(parent_trees).get_children():
		if point is TreePoint:
			all_points.append(point)

func _check_population():
	while true :
		red_cult_amount = get_tree().get_nodes_in_group("red").size()
		blue_cult_amount = get_tree().get_nodes_in_group("blue").size()
		green_cult_amount = get_tree().get_nodes_in_group("green").size()
		black_cult_amount = get_tree().get_nodes_in_group("black").size()
		
		count_red_tree = get_tree().get_nodes_in_group("redTree").size()
		count_green_tree = get_tree().get_nodes_in_group("greenTree").size()
		count_blue_tree = get_tree().get_nodes_in_group("blueTree").size()
		count_black_tree = get_tree().get_nodes_in_group("blackTree").size()
		
		
		await get_tree().create_timer(.2).timeout


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

