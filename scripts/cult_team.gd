extends Node
class_name CultTeam

static var instance: CultTeam;

enum Team {
	NONE,
	RED,
	GREEN,
	BLUE,
	BLACK,
}

func _init():
	instance = self
