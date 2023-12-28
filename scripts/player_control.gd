extends Node
class_name PlayerControl

@export var parent: Node;
@export_subgroup("PackedScene")
@export var RedPackedScene: PackedScene;
@export var GreenPackedScene: PackedScene;
@export var BluePackedScene: PackedScene;
@export var BlackPackedScene: PackedScene;

@export_subgroup("Texture")
@export var red_texture: String;
@export var green_texture: String;
@export var blue_texture: String;
@export var black_texture: String;



@export var player_team: CultTeam.Team;

@onready var count_tree_l: Label = %CountTreeLabel
@onready var tell_amount: Label = %able_summon_label
@onready var player_texture: TextureRect = %player_texture

var rng = RandomNumberGenerator.new()
var gameManager: GameManager;

var spawn_point: Vector2;

func _process(delta):
	update_ui()

func update_ui():
	match player_team:
		CultTeam.Team.RED:
			count_tree_l.text = str(gameManager.count_red_tree)
			var amount = gameManager.red_max_amout - gameManager.red_cult_amount
			tell_amount.text = str(amount)
		CultTeam.Team.GREEN:
			count_tree_l.text = str(gameManager.count_green_tree)
			var amount = gameManager.green_max_amout - gameManager.green_cult_amount
			tell_amount.text = str(amount)
		CultTeam.Team.BLUE:
			count_tree_l.text = str(gameManager.count_blue_tree)
			var amount = gameManager.blue_max_amout - gameManager.blue_cult_amount
			tell_amount.text = str(amount)
		CultTeam.Team.BLACK:
			count_tree_l.text = str(gameManager.count_black_tree)
			var amount = gameManager.black_max_amout - gameManager.black_cult_amount
			tell_amount.text = str(amount)
	
func instance_scene():
	var packed_scene: PackedScene
	match player_team:
		CultTeam.Team.RED:
			packed_scene = RedPackedScene
		CultTeam.Team.GREEN:
			packed_scene = GreenPackedScene
		CultTeam.Team.BLUE:
			packed_scene = BluePackedScene
		CultTeam.Team.BLACK:
			packed_scene = BlackPackedScene
	var unit = packed_scene.instantiate() as Character
	unit.global_position = spawn_point
	parent.add_child(unit)


func _find_path_to_summon() -> bool:
	var point_can_spawn : Array[TreePoint] = []
	for point: TreePoint in GameManager.instance.get_all_points():
		if(point._territory_team == player_team):
			point_can_spawn.append(point)
	var point_size = point_can_spawn.size()
	if( point_size == 0):
		print("No point can spawn")
		return false;
	var rand_num : int= rng.randi_range(0,point_size  - 1)
	spawn_point = point_can_spawn[rand_num].global_position
	return true;
	

func _can_summon() -> bool:
	match player_team:
		CultTeam.Team.RED:
			return gameManager.red_cult_amount < gameManager.red_max_amout
		CultTeam.Team.GREEN:
			return gameManager.green_cult_amount < gameManager.red_max_amout
		CultTeam.Team.BLUE:
			return gameManager.blue_cult_amount < gameManager.red_max_amout
		CultTeam.Team.BLACK:
			return gameManager.black_cult_amount < gameManager.red_max_amout
	return false;

func _input(event):
	if event.is_action_pressed("summon"):
		if( _can_summon() and _find_path_to_summon()):
			instance_scene()

func _ready():
	gameManager = GameManager.instance
	player_team = PlayerSingleton.player_team
	
	update_player_texture()

func update_player_texture():
	match player_team:
		CultTeam.Team.RED:
			var texture_load = load(red_texture)
			player_texture.texture = texture_load
		CultTeam.Team.GREEN:
			var texture_load = load(green_texture)
			player_texture.texture = texture_load
		CultTeam.Team.BLUE:
			var texture_load = load(blue_texture)
			player_texture.texture = texture_load
		CultTeam.Team.BLACK:
			var texture_load = load(black_texture)
			player_texture.texture = texture_load
	return false;
