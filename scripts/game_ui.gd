extends Control
class_name ScoreBoardUI

@export_subgroup("texture paths")
@export var path_texture_1: Texture2D
@export var path_texture_2: Texture2D
@export var path_texture_3: Texture2D
@export var path_texture_4: Texture2D

@onready var label_1: Label =%l1
@onready var label_2: Label =%l2
@onready var label_3: Label =%l3
@onready var label_4: Label =%l4
@onready var texture_1: TextureRect = %t1
@onready var texture_2: TextureRect = %t2
@onready var texture_3: TextureRect = %t3
@onready var texture_4: TextureRect = %t4

func _ready():
	if(path_texture_1 != null):texture_1.texture = path_texture_1
	if(path_texture_2 != null):texture_2.texture = path_texture_2
	if(path_texture_3 != null):texture_3.texture = path_texture_3
	if(path_texture_4 != null):texture_4.texture = path_texture_4
	

func update_label_1(text: String):
	label_1.text = text

func update_label_2(text: String):
	label_2.text = text

func update_label_3(text: String):
	label_3.text = text

func update_label_4(text: String):
	label_4.text = text

