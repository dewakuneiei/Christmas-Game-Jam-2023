extends CharacterBody2D
class_name Character

@export_subgroup("PackedScene")
@export var snowball : PackedScene

# Character state
@export_subgroup("Status Settings")
@export var max_health: int = 7;
@export var strength: int = 2;
@export var color_cult: Color = Color.WHITE

@export_subgroup("Current")
@export var cult_team: CultTeam.Team;
@export var state_action: Action;


@onready var _nav_agent: NavigationAgent2D = %NavAgent
@onready var _time_cooldown: Timer = %ThrowSnowCooldown
@onready var _throw_pos: Marker2D = %ThrowPos
@onready var _hp_bar: TextureProgressBar = $HealthBar
@onready var _character_sprite: Sprite2D = %CharacterSprite
@onready var _player_anim: AnimationPlayer = %playerAnim
@onready var _selection_sprite: Sprite2D = %Selection

enum Action {
	NONE,
	MOVING,
	CAPTURING,
	GET_COMMAND,
	DIED,
}

# temp
var defualt_ordering_index: int;

# setup/ get ref
var game_manager: GameManager;
var rng = RandomNumberGenerator.new()
var _captured_dist: float = 5.0

# Status updated
var is_fight_mode: bool = false;
var move_speed: float = 40;

var _health: int

var _dir_to_target: Vector2;
var _tree_target: TreePoint;

# Shooting
var _can_throw: bool = true;
var _enemy_detected: Character;



const speed_multipiler:= 100

# Player command on this character
var can_selected: bool = false;
var is_waiting_command: bool = false;
var target_command_point: Vector2;
var has_been_clicked: bool = false;

var _flag_target: Sprite2D;

func take_damage(amount: int):
	if( state_action == Action.DIED):
		return
	
	_hp_bar.visible = true
	_health = _health - amount
	_hp_bar.value = _health
	if(_health <= 0):
		state_action = Action.DIED
		_hp_bar.visible = false

func set_ordering_index(index: int):
	_character_sprite.z_index = index

func _ready():
	game_manager = GameManager.instance
	
	state_action = Action.NONE
	_tree_target = null
	_reset_selection()
	
	# Set Status
	_health = max_health
	_hp_bar.visible = false
	_hp_bar.min_value = 0
	_hp_bar.max_value = max_health
	_hp_bar.value = _health
	
	# Set temp
	defualt_ordering_index = _character_sprite.z_index
	
	# wait for game manager is completed load
	await get_tree().create_timer(3.0).timeout 
	
	_seached_point()

func _seached_point():
	while true:
		await get_tree().create_timer(.5).timeout
		if( _tree_target != null or state_action == Action.GET_COMMAND):
			continue
		
		var allPoints : Array[TreePoint] = game_manager.get_all_points()
		var point_is_not_cap : Array[TreePoint] = []

		
		for point: TreePoint in allPoints:
			if(point.get_territory_name() != cult_team):
				point_is_not_cap.append(point)
		
		var point_is_not_cap_size: int = point_is_not_cap.size()
		
		# Not founded point
		if(point_is_not_cap_size == 0):
			_tree_target = null
			state_action = Action.NONE
			return;
		
		if(point_is_not_cap_size > 1):
			
			# sort to find the shortest point
			_bubble_sort_point(point_is_not_cap)
			
			var rand_point = rng.randi_range(0, 1)
			_tree_target = point_is_not_cap[rand_point]
			pass
		else:
			_tree_target = point_is_not_cap[0]
		

func _process(delta):
	
	if( can_selected and 
		Input.is_action_just_pressed("selected_unit") and 
		not has_been_clicked ):
		_wait_command()
		has_been_clicked = true
	elif(Input.is_action_just_released("selected_unit")):
		has_been_clicked = false
		
	if( is_waiting_command and 
		Input.is_action_just_pressed("selected_unit") and 
		not has_been_clicked):
		_get_commander(get_global_mouse_position())
	
	
	if(state_action == Action.DIED and not _player_anim.is_playing()):
		_player_anim.play("died")
		return;

	if(_dir_to_target.x < 0):
		_character_sprite.flip_h = true
	else:
		_character_sprite.flip_h = false
	

func _physics_process(delta):
	
	if(state_action == Action.DIED):
		return;
	
	if( state_action == Action.GET_COMMAND):
		_nav_agent.target_position = target_command_point
		_dir_to_target = global_position.direction_to(_nav_agent.get_next_path_position())
	
		var intended_velocity = _dir_to_target * move_speed * speed_multipiler
		_nav_agent.velocity = intended_velocity * delta
		
		var dist_to_command_point = global_position.distance_to(target_command_point)
		if(dist_to_command_point < 20):
			reset_target()
		return 


	if(_tree_target == null):
		return;

	if(_tree_target.get_territory_name() == cult_team):
		reset_target()
		return;
	
	var target_pos = _tree_target.global_position
	
	if _enemy_detected != null:
		if(_can_throw): throw_snowball()
		_nav_agent.velocity = Vector2.ZERO
		is_fight_mode = true;
		return;
	else :
		is_fight_mode = false;

	if (state_action == Action.CAPTURING):
		# Stop movement if capturing
		_nav_agent.velocity = Vector2.ZERO
		return
	
	
#region agent moved
	# Unit Movement to target
	state_action = Action.MOVING
	
	_nav_agent.target_position = target_pos
	_dir_to_target = global_position.direction_to(_nav_agent.get_next_path_position())
	
	var intended_velocity = _dir_to_target * move_speed * speed_multipiler
	_nav_agent.velocity = intended_velocity * delta
#endregion

func throw_snowball():
	var ball = snowball.instantiate()
	var dir : Vector2= global_position.direction_to(_enemy_detected.global_position)
	add_child(ball)
	ball.set_value(dir, strength, cult_team)
	_can_throw = false
	_time_cooldown.start()

# for tree point checking only
func change_state_to_capture() -> void:
	state_action = Action.CAPTURING
	

func is_under_command() -> bool:
	return state_action == Action.GET_COMMAND

func reset_target():
	_tree_target = null
	state_action = Action.NONE
	_dir_to_target = Vector2.ZERO
	
	if(_flag_target != null):
		_flag_target.queue_free()



### Sorting Algorithm
func _bubble_sort_point(arr: Array[TreePoint]):
	var size = arr.size()
	if(size < 2):
		printerr("Array can't be sorting!")
		return
	
	for i in range(size):
		for j in range(size - 1):
			var a_dist = global_position.distance_to(arr[j].global_position)
			var b_dist = global_position.distance_to(arr[j + 1].global_position)
			
			if a_dist > b_dist:
				var temp = arr[j+1]
				arr[j+1] = arr[j]
				arr[j] = temp;
			

### Player command on this character
func _wait_command():
	_selection_sprite.visible = true
	is_waiting_command = true;

func _reset_selection():
	_selection_sprite.visible = false
	is_waiting_command = false;

func _get_commander(pos: Vector2):
	if( _flag_target != null):
		_flag_target.queue_free()
	
	target_command_point = pos
	state_action = Action.GET_COMMAND
	is_waiting_command = false
	_reset_selection()
	
	#Create Flag
	var flag_sprite_new = Sprite2D.new()
	flag_sprite_new.texture = PlayerSingleton.FLAG
	flag_sprite_new.modulate = color_cult
	flag_sprite_new.global_position = pos
	flag_sprite_new.z_index = 50
	flag_sprite_new.top_level = true;
	flag_sprite_new.scale = Vector2.ONE * .25
	_flag_target = flag_sprite_new
	add_child(_flag_target)





func _on_nav_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body is Character:
		if (body.cult_team != cult_team and body.state_action != Action.DIED):
			_enemy_detected = body
		else:
			_enemy_detected = null

func _on_area_2d_body_exited(body):
	if body is Character:
		if body.cult_team != cult_team:
			_enemy_detected = null


func _on_throw_snow_cooldown_timeout():
	_can_throw = true


func _on_player_anim_animation_finished(anim_name):
	if anim_name == "died":
		await get_tree().create_timer(.5).timeout
		queue_free()


func _on_area_detected_mouse_entered():
	if( cult_team == PlayerSingleton.player_team):
		can_selected = true


func _on_area_detected_mouse_exited():
	can_selected = false
