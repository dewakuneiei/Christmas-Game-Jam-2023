extends Control
class_name PlayerControl

@export_subgroup("Texture")
@export var red_texture: String;
@export var green_texture: String;
@export var blue_texture: String;
@export var black_texture: String;
@export_subgroup("Color Team")
@export var red: Color;
@export var green: Color;
@export var blue: Color;
@export var black: Color;

@export var player_team: CultTeam.Team;

@onready var count_tree_l: Label = %CountTreeLabel
@onready var player_texture: TextureRect = %player_texture
@onready var player_texture2: TextureRect = %player_texture2



var gameManager: GameManager;

func _process(delta):
	update_ui()

func update_ui():
	match player_team:
		CultTeam.Team.RED:
			count_tree_l.text = str(gameManager.count_red_tree)

		CultTeam.Team.GREEN:
			count_tree_l.text = str(gameManager.count_green_tree)

		CultTeam.Team.BLUE:
			count_tree_l.text = str(gameManager.count_blue_tree)

		CultTeam.Team.BLACK:
			count_tree_l.text = str(gameManager.count_black_tree)
	
	

func _ready():
	gameManager = GameManager.instance
	player_team = PlayerSingleton.player_team
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_player_texture()

func update_player_texture():
	match player_team:
		CultTeam.Team.RED:
			var texture_load = load(red_texture)
			player_texture.texture = texture_load
			player_texture2.modulate = red
		CultTeam.Team.GREEN:
			var texture_load = load(green_texture)
			player_texture.texture = texture_load
			player_texture2.modulate = green
		CultTeam.Team.BLUE:
			var texture_load = load(blue_texture)
			player_texture.texture = texture_load
			player_texture2.modulate = blue
		CultTeam.Team.BLACK:
			var texture_load = load(black_texture)
			player_texture.texture = texture_load
			player_texture2.modulate = black
	return false;
