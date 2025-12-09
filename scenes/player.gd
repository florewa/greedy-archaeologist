extends CharacterBody2D

var tile_size = 64
@onready var ray = $RayCast2D

# Ссылка на карту (найдем её при старте)
var tile_map: TileMapLayer

# НАСТРОЙКИ ТАЙЛОВ (Впиши свои значения!)
# Source ID можно посмотреть в панели TileSet, наведя на картинку слева
var cracked_floor_source_id = 3  # ID картинки с трещиной
var pit_source_id = 2            # ID картинки с ямой

# Атлас координаты обычно (0, 0), если это отдельные картинки
var atlas_coords = Vector2i(0, 0)

var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN
}

func _ready():
	# Ищем узел карты в родительской сцене (Main)
	# Предполагаем, что карта называется "TileMapLayer"
	tile_map = get_parent().get_node("TileMapLayer")

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(inputs[dir])

func move(dir):
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		# 1. Запоминаем, где мы стояли ДО шага (в координатах сетки)
		# local_to_map переводит пиксели (128, 64) в клетки (2, 1)
		var current_tile_pos = tile_map.local_to_map(position)
		
		# 2. Делаем шаг
		position += dir * tile_size
		
		# 3. Проверяем плитку, с которой ушли
		check_break_floor(current_tile_pos)

func check_break_floor(tile_pos):
	# Спрашиваем у карты: какой Source ID у плитки по этим координатам?
	var source_id = tile_map.get_cell_source_id(tile_pos)
	
	# Если это был Хрупкий Пол
	if source_id == cracked_floor_source_id:
		print("Пол обрушился!")
		# Заменяем его на Яму
		tile_map.set_cell(tile_pos, pit_source_id, atlas_coords)
