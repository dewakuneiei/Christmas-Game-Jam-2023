extends Node

var player_team: CultTeam.Team = CultTeam.Team.RED;

const RED_UNIT_SCENE: PackedScene = preload("res://scenes/Characters/red.tscn")
const GREEN_UNIT_SCENE: PackedScene = preload("res://scenes/Characters/green.tscn")
const BLUE_UNIT_SCENE: PackedScene = preload("res://scenes/Characters/blue.tscn")
const BLACK_UNIT_SCENE: PackedScene = preload("res://scenes/Characters/black.tscn")

const RED_BASE = preload("res://assets/HR.png")
const GREEN_BASE = preload("res://assets/HG.png")
const BLUE_BASE = preload("res://assets/HBlue.png")
const BLACK_BASE = preload("res://assets/HB.png")

const FLAG = preload("res://assets/flag.png")

func set_player_team(team: CultTeam.Team):
	player_team = team;
