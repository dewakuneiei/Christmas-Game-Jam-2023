extends Marker2D

@export var team: CultTeam.Team = CultTeam.Team.RED
@export var flip_h_sprite : bool = false;

@onready var base_sprite: Sprite2D = %Hr
@onready var spawn_pos: Marker2D = %SpawnPos

var game_manager: GameManager;

func _ready():
	game_manager = GameManager.instance
	update_base_point()
	
	# for sure game is ready
	await get_tree().create_timer(1.5).timeout
	
	finded_cult()

func update_base_point():
	base_sprite.flip_h = flip_h_sprite
	if flip_h_sprite: spawn_pos.position.x *= -1
	print(name, " " + str(spawn_pos.position.x))
	match team:
		CultTeam.Team.RED:
			base_sprite.texture = PlayerSingleton.RED_BASE
		CultTeam.Team.GREEN:
			base_sprite.texture = PlayerSingleton.GREEN_BASE
		CultTeam.Team.BLUE:
			base_sprite.texture = PlayerSingleton.BLUE_BASE
		CultTeam.Team.BLACK:
			base_sprite.texture = PlayerSingleton.BLACK_BASE

#region Spawn Unit
### Spawn unit
func finded_cult():
	while  true:
		check_and_callback()
		await get_tree().create_timer(.2).timeout

func check_and_callback():
	match team:
		CultTeam.Team.RED:
			if(game_manager.red_cult_amount < game_manager.red_max_amout):
				spawn_unit_in_match(0)
		CultTeam.Team.GREEN:
			if(game_manager.green_cult_amount < game_manager.green_max_amout):
				spawn_unit_in_match(1)
		CultTeam.Team.BLUE:
			if(game_manager.blue_cult_amount < game_manager.blue_max_amout):
				spawn_unit_in_match(2)
		CultTeam.Team.BLACK:
			if(game_manager.black_cult_amount < game_manager.black_max_amout):
				spawn_unit_in_match(3)

func spawn_unit_in_match(index: int):
	match index:
		0:
			spawn(PlayerSingleton.RED_UNIT_SCENE)
		1:
			spawn(PlayerSingleton.GREEN_UNIT_SCENE)
		2:
			spawn(PlayerSingleton.BLUE_UNIT_SCENE)
		3:
			spawn(PlayerSingleton.BLACK_UNIT_SCENE)

func spawn(unit_scene: PackedScene):
	var unit = unit_scene.instantiate() as Character
	add_child(unit)
	unit.global_position = spawn_pos.global_position
#endregion
