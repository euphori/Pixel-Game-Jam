extends Node


@export var map_size = Vector2(128,128)
@export var noise_height_texture = NoiseTexture2D
var tile_map : TileMap
var noise : Noise



func _ready():
	noise = noise_height_texture.noise
	tile_map = get_parent()
	generate_world()
	

func clear():
	tile_map.clear()
	
func generate_world():
	
	noise.seed = randi()
	var cells = []
	for x in map_size.x:
		for y in map_size.y:
			var noise_val = noise.get_noise_2d(x,y)
			if noise_val > 0.0:
				cells.append(Vector2(x,y))
	
	tile_map.set_cells_terrain_connect(0,cells,0, 0)

	
	
