extends StaticBody2D
class_name TreePoint

@export var state_cult: Cult;

enum Cult {
	NONE,
	RED,
	GREEN,
	BLUE,
	BLACK
}





func _on_area_2d_body_entered(body):
	print(body)
