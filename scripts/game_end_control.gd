extends Control
class_name GameEndedUI

@export var scene_path: String;

@onready var red_l: Label = %GiftCount
@onready var green_l: Label = %GiftCount2
@onready var blue_l: Label = %GiftCount3
@onready var black_l: Label = %GiftCount4
@onready var winner_texture: TextureRect = %profile

func who_is_winner(team: CultTeam.Team):
	match team:
		CultTeam.Team.RED:
			winner_texture.texture = PlayerSingleton.RED_FRAME
		CultTeam.Team.GREEN:
			winner_texture.texture = PlayerSingleton.GREEN_FRAME
		CultTeam.Team.BLUE:
			winner_texture.texture = PlayerSingleton.BLUE_FRAME
		CultTeam.Team.BLACK:
			winner_texture.texture = PlayerSingleton.BLACK_FRAME


func set_red_text(score: int):
	red_l.text = str(score)

func set_green_text(score: int):
	green_l.text = str(score)
	
func set_blue_text(score: int):
	blue_l.text = str(score)

func set_black_text(score: int):
	black_l.text = str(score)


func _on_again_btn_pressed():
	BackgroundMusic.stop()
	get_tree().change_scene_to_file(scene_path)
