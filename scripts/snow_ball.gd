extends Area2D
class_name SnowBall


var _team: CultTeam.Team = CultTeam.Team.NONE
var _damage: int = 1;
var _speed: float = 200
var _dir: Vector2;
var _timer: float = 0;

func _process(delta):
	global_position += _dir * _speed * delta
	
	_timer += delta
	if(_timer >= 3):
		queue_free()
		return;
	

func set_value(dir: Vector2, damage: int, team: CultTeam.Team):
	_dir = dir.normalized()
	_damage = damage;
	_team = team

func _on_body_entered(body):
	if body is Character:
		if body.cult_team != _team:
			queue_free()
			body.take_damage(_damage)

