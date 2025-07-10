extends Node2D

### TODO:
#

### VARIABLES
## onready variables
# zamiana obrazu perlin noise na teksture
@onready var noise_texture: ImageTexture = ImageTexture.create_from_image(generate_perlin_noise_image(512, 512))
# do wyświetlania na ekranie
@onready var output_sprite: Sprite2D = $"output sprite"
# zawiera cały ten grid
@onready var noise_grid: Array = []

## export variables
@export var size: int = 256
@export var density: int = 60
@export var initial_iterations: int = 2



### FUNCTIONS
## premade functions
func _ready():
	#output_sprite.texture = noise_texture
	
	randomize()
	noise_grid = make_noise_grid(density, size)
	noise_grid = apply_cellular_automaton(noise_grid, initial_iterations)
	output_sprite.texture = make_texture_from_grid(noise_grid)

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1:
				noise_grid = apply_cellular_automaton(noise_grid, 1)
				output_sprite.texture = make_texture_from_grid(noise_grid)
			KEY_2:
				noise_grid = make_noise_grid(density, size)
				output_sprite.texture = make_texture_from_grid(noise_grid)


### my functions
## generuje perlin noise
#func generate_perlin_noise_image(width: int, height: int) -> Image:
	#var noise = FastNoiseLite.new()
	#noise.noise_type = FastNoiseLite.TYPE_PERLIN
	#noise.seed = randi()
	## im mniejsza wartość tym większe "wzorki"
	#noise.frequency = 0.05
	#
	#var img = Image.create(width, height, false, Image.FORMAT_RGB8)
	#
	#for y in range(height):
		#for x in range(width):
			#var n = noise.get_noise_2d(x, y)
			## skala z [-1, 1] na [0, 1]
			#n = (n + 1.0) * 0.5
			#img.set_pixel(x, y, Color(n, n, n))
	#
	#return img



### Z PORADNIKA
func make_noise_grid(density: float, size: float) -> Array:
	var noise_grid := []
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	for i in range(size):
		var row := []
		for j in range(size):
			if rand.randi_range(1, 100) > density:
				row.append(0)
			else:
				row.append(1)
		noise_grid.append(row)
	
	return noise_grid

func apply_cellular_automaton(grid: Array, iterations: int) -> Array:
	var size = grid.size()
	
	for i in range(iterations):
		var temp_grid = grid.duplicate(true)
		
		for y in range(1, size - 1):
			for x in range(1, size - 1):
				var neighbor_wall_count = 0
				
				for ny in range(y - 1, y + 2):
					for nx in range(x - 1, x + 2):
						if ny == y and nx == x:
							continue
						if is_within_bounds(nx, ny, size):
							if temp_grid[ny][nx] == 1:
								neighbor_wall_count += 1
						else:
							neighbor_wall_count += 1
				
				if neighbor_wall_count > 4:
					grid[y][x] = 0
				else:
					grid[y][x] = 1
	
	return grid

func is_within_bounds(x: int, y: int, size: int) -> bool:
	return x >= 0 and x < size and y >= 0 and y < size


## spoza filmiku
func make_texture_from_grid(grid: Array) -> ImageTexture:
	var size_x = grid.size()
	var size_y = grid[0].size()
	
	var img = Image.create(size_x, size_y, false, Image.FORMAT_RGB8)
	
	for y in range(size_y):
		for x in range(size_x):
			var value = grid[x][y]
			var color = Color.WHITE if value == 1 else Color.BLACK
			img.set_pixel(x, y, color)
	
	var tex = ImageTexture.create_from_image(img)
	return tex
