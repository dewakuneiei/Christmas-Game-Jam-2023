extends Node2D

@export var scene_path: String;
	

func _on_red_btn_pressed():
	PlayerSingleton.set_player_team(CultTeam.Team.RED)
	get_tree().change_scene_to_file(scene_path)


func _on_green_btn_pressed():
	PlayerSingleton.set_player_team(CultTeam.Team.GREEN)
	get_tree().change_scene_to_file(scene_path)



func _on_blue_btn_pressed():
	PlayerSingleton.set_player_team(CultTeam.Team.BLUE)
	get_tree().change_scene_to_file(scene_path)



func _on_black_btn_pressed():
	PlayerSingleton.set_player_team(CultTeam.Team.BLACK)
	get_tree().change_scene_to_file(scene_path)

