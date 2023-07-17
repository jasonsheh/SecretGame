extends Node2D

@export var map_width = 300
@export var map_height = 300

@export var map_width_offset = 0
@export var map_height_offset = 0

@export var world_seed = "Hello World!"
@export var noise_octaves = 1
@export var noise_frequency = 0.03 # 平滑水平
@export var noise_fractal_gain = 0.5 # 好像没用
@export var noise_lacunarity = 2 # 好像没用
@export var noise_threshold = 0.05
@export var fractal_type = 1
@export var noise_type = 1 # default 1

#@export var noise_iterations = 20000
#@export var noise_neighbors     = 4
#@export var noise_ground_chance = 48
#@export var noise_min_cave_size = 80

var land_tileset_mode = 0
var big_land_tileset_mode = 1
var grass_tileset_mode = 1

var tile_map : TileMap
var simplex_noise = FastNoiseLite.new()

func _ready():
	self.tile_map = get_parent()
	self.generate()

func _clear():
	self.tile_map.clear()

func generate():
	self.simplex_noise.seed = self.world_seed.hash()
	self.simplex_noise.fractal_octaves = self.noise_octaves
	self.simplex_noise.frequency = self.noise_frequency
	self.simplex_noise.fractal_gain = self.noise_fractal_gain
	self.simplex_noise.fractal_lacunarity = self.noise_lacunarity
	self.simplex_noise.fractal_type = self.fractal_type
	self.simplex_noise.noise_type = self.noise_type
	
	var cells = []
	for x in range(map_width_offset - self.map_width / 2, map_width_offset + self.map_width / 2):
		for y in range(map_height_offset+self.map_height):
			if self.simplex_noise.get_noise_2d(x, y) >= self.noise_threshold:
				cells.append(Vector2(x, y))
	
	# make walls
	for x in range(map_width_offset - self.map_width / 2, map_width_offset + self.map_width / 2):
	#	cells.append(Vector2(x, map_height_offset))
		cells.append(Vector2(x, map_height_offset+self.map_height))
	for y in range(map_height_offset+self.map_height):
		cells.append(Vector2(map_width_offset - self.map_width / 2, y))
		cells.append(Vector2(map_width_offset + self.map_width / 2, y))
		
	self.tile_map.set_cells_terrain_connect(0, cells, 0, land_tileset_mode)

func _set_autotile(x, y, tile_type):
	self.tile_map.set_cell(
		0,
		Vector2(x, y),
		0,
		tile_type,
	)
