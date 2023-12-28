extends Node2D
class_name TreePoint

@export var _territory_team: CultTeam.Team

@onready var _tree_sprite: Sprite2D = %TreeSprite
@onready var _entered_area: Area2D = %EnteredArea
@onready var _cicle_progr: TextureProgressBar = %CircleProgress
@onready var _upscore_cooldown: Timer = %UpscoreCooldown
@onready var _anim_player: AnimationPlayer = %gftAnim
@onready var _gift: Sprite2D = %gift

# Timer
var _my_timer: float = 0;
var _target_time: float = 12;
var max_capture_rate: float = 1
var base_capture_rate: float = 0.3

var _can_score_up: bool = true

# Bodies enterd
var capturing_units: int = 0;
var _body_color: Color = Color.WHITE
var _body_team: CultTeam.Team;
var _is_there_one_team: bool;

const GROUP_NAME : StringName = "Tree"

func _ready():
	_gift.visible = false
	reset_status()
	check_overlaping()


func check_overlaping():
	var bodies: Array
	while true :
		# Get bodies was entered this area and Character class_name filering
		bodies = _entered_area.get_overlapping_bodies()
		var characters : Array[Character] = []
		for body in bodies:
			if body is Character:
				# for set layer to show in front of
				if(body.global_position.y < global_position.y):
					body.set_ordering_index(1)
				else:
					body.set_ordering_index(body.defualt_ordering_index)
				characters.append(body)
		
		capturing_units = characters.size()
		if capturing_units > 0:
			_body_color = characters[0].color_cult
			_body_team = characters[0].cult_team
			_is_there_one_team = true; 
			
			# for check have other team is capturing
			var last_cult_team = null;
			for body: Character in characters:
				# continue at the first loop
				if( last_cult_team == null):
					last_cult_team = body.cult_team
					continue
				if last_cult_team != body.cult_team:
					_is_there_one_team = false
					break;
				last_cult_team = body.cult_team
				
			# change all action status of all unit is captured
			if(_is_there_one_team):
				for unit in characters:
					unit.change_state_to_capture()
		await get_tree().create_timer(.2).timeout
		

func count_score_up():
	match _territory_team:
		CultTeam.Team.RED:
			GameManager.instance.add_red_score()
		CultTeam.Team.GREEN:
			GameManager.instance.add_green_score()
		CultTeam.Team.BLUE:
			GameManager.instance.add_blue_score()
		CultTeam.Team.BLACK:
			GameManager.instance.add_black_score()


func _process(delta):
	if(_territory_team != CultTeam.Team.NONE and _can_score_up):
		count_score_up()
		_anim_player.play("fly")
		_can_score_up = false
		_upscore_cooldown.start()
		
	
	# Count time to capturing by capturer
	if(capturing_units > 0 and _territory_team != _body_team and _is_there_one_team):
		_cicle_progr.visible = true
		_cicle_progr.tint_progress = _body_color
		#timer capture set
		var current_capture_rate = base_capture_rate + capturing_units * (max_capture_rate - base_capture_rate)
		_my_timer += delta * current_capture_rate
		_cicle_progr.value = _my_timer
		if(_cicle_progr.value >= _target_time):
			was_capture_by(_body_team)
			reset_status()
			chang_unit_target()
			
	else:
		reset_status()

func chang_unit_target():
	for unit: Character in _entered_area.get_overlapping_bodies() as Array[Character]:
		unit.reset_target()

func reset_status():
	_cicle_progr.visible = false
	_cicle_progr.value = 0
	_cicle_progr.min_value = 0
	_cicle_progr.max_value = _target_time
	_my_timer = 0

func was_capture_by(newTeam: CultTeam.Team) -> void:
	_tree_sprite.self_modulate = _body_color
	_territory_team = newTeam 
	
	match _territory_team:
		CultTeam.Team.RED:
			remove_from_group("red"+GROUP_NAME)
		CultTeam.Team.GREEN:
			remove_from_group("green"+GROUP_NAME)
		CultTeam.Team.BLUE:
			remove_from_group("blue"+GROUP_NAME)
		CultTeam.Team.BLACK:
			remove_from_group("black"+GROUP_NAME)
	match newTeam:
		CultTeam.Team.RED:
			add_to_group("red"+GROUP_NAME)
		CultTeam.Team.GREEN:
			add_to_group("green"+GROUP_NAME)
		CultTeam.Team.BLUE:
			add_to_group("blue"+GROUP_NAME)
		CultTeam.Team.BLACK:
			add_to_group("black"+GROUP_NAME)

func get_territory_name() -> CultTeam.Team:
	return _territory_team


func _on_entered_area_body_exited(body):
	if body is Character:
		body.reset_target()


func _on_upscore_cooldown_timeout():
	_can_score_up = true

