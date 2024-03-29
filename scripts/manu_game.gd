extends Node2D

@export var scene_path: String;

@onready var credit_content = %CreditContent
@onready var choosed_color = %ChoosedColor
@onready var open_credit_btn = $CanvasLayer/MainUI/CreditBtn

func _ready():
	_close_credit_content()

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

func _opened_credits():
	pass

func _on_credit_btn_pressed():
	_show_credit_content()

func _show_credit_content():
	credit_content.visible = true
	choosed_color.visible = false
	open_credit_btn.visible = false

func _close_credit_content():
	credit_content.visible = false
	choosed_color.visible = true
	open_credit_btn.visible = true

func _on_back_btn_pressed():
	_close_credit_content()
