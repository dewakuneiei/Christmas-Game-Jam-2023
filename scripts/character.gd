extends CharacterBody2D
class_name Character

# Character state
@export_subgroup("Status Settings")
@export var max_health: int = 7;
@export var strength: int = 2;
@export var move_speed: float = 1000;

@export_subgroup("Current")
@export var tree_target: TreePoint

@export var state_cult: Cult;
@export var state_action: Action;

enum Cult {
	NONE,
	RED,
	GREEN,
	BLUE,
	BLACK
}

enum Action {
	NONE,
	MOVING,
	CAPTURING,
	FIGHT
}

# setup/ get ref
var game_manager: GameManager;
var rng = RandomNumberGenerator.new()

# Status updated
var health: int
var _dir_to_target: Vector2;

var is_hit: bool = false

func _ready():
	game_manager = GameManager.instance
	
	state_action = Action.NONE
	tree_target = null
	
	# wait for game manager is completed load
	await get_tree().create_timer(3.0).timeout 
	
	_seached_point()

func _seached_point():
	var allPoints : Array = game_manager.get_all_points()
	var rand_point = rng.randi_range(0, allPoints.size() - 1)
	
	tree_target = game_manager.get_point(rand_point)
	print(tree_target)

func _physics_process(delta):
	
	if(tree_target == null):
		return;
	
	_dir_to_target = (tree_target.global_position - global_position).normalized()
	
	velocity = _dir_to_target * move_speed * delta
	is_hit = move_and_slide()
	print(velocity)

