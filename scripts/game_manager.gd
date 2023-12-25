extends Node2D
class_name GameManager

static var instance: GameManager;

@export var parent_trees: NodePath
@export var _all_points: Array

func _ready():
	_all_points = []
	for point in get_node(parent_trees).get_children():
		if point is TreePoint:
			_all_points.append(point)

func _init():
	self.instance = self

### For the point
func get_point(index: int) -> TreePoint:
	return _all_points[index]

func get_all_points() -> Array :
	return _all_points
	
func get_parent_size() -> int :
	return _all_points.size()
