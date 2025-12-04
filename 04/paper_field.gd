extends GridContainer

@export var paper_scene: PackedScene = null
@export var emtpy_tile_scene: PackedScene = null
var result_part1_label: Label = null
var result_part2_label: Label = null
var _input_map := AOC_Input_04.new().input_to_2DPaperMap()

func remove_indices(indices: Array[Array]) -> void:
	var row_len = len(_input_map[0])

	for idx_arr in indices:
		var row: int = idx_arr[0]
		var col: int= idx_arr[1]

		_input_map[row][col] = false

		var idx_1D = row * row_len + col
		var node_to_remove := self.get_child(idx_1D)
		self.get_child(idx_1D).queue_free()
		self.remove_child(node_to_remove)
		var new_empty_tile = emtpy_tile_scene.instantiate()
		self.add_child(new_empty_tile)
		self.move_child(new_empty_tile, idx_1D)
		
	await get_tree().process_frame
	

		
		

func count_and_remove() -> int:
	var row_len = len(_input_map[0])
	var to_remove: Array[Array] = []
	var row_idx: int = 0
	for row in _input_map:
		var col_idx: int = 0
		for tile in row:
			if tile:
				var neighbor_count := count_neighbors(row_idx, col_idx)
				var idx_1D: int = row_idx * row_len + col_idx 
				self.get_child(idx_1D).set_value(neighbor_count)
				if neighbor_count < 4:
					to_remove.append([row_idx, col_idx])
			col_idx += 1
		row_idx += 1
	
	await get_tree().create_timer(0.1).timeout
	await remove_indices(to_remove)
	await get_tree().create_timer(0.1).timeout
	return len(to_remove)
	
				
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result_part1_label = $"../../Result"
	result_part2_label = $"../../Result2"
	self.columns = len(_input_map[0])
	for row in _input_map:
		for tile in row:
			var scene_object: Control = null
			if tile:
				scene_object = paper_scene.instantiate()
			else:
				scene_object = emtpy_tile_scene.instantiate()
			add_child(scene_object, true)
	
	var result: int = await count_and_remove()
	result_part1_label.text = "Accessible Papers at the start: " + str(result)
	var result2: int = result
	result_part2_label.text = "Total removed Papers: " + str(result2)
	while true:
		var count := await count_and_remove()
		if count == 0:
			break 
		result2 += count
		result_part2_label.text = "Total removed Papers: " + str(result2)
	
	
		
func count_neighbors(row_idx: int, col_idx: int) -> int:
	var count = 0
	var max_row = len(_input_map)
	var max_col = len(_input_map[0])
	
	for row_dist in [-1,0,1]:
		for col_dist in [-1,0, 1]:
			if row_dist == 0 and col_dist == 0:
				continue
			
			var check_row: int = row_idx + row_dist
			var check_col: int = col_idx + col_dist
			
			if check_row < 0 or check_row >= max_row or check_col < 0 or check_col >= max_col:
				continue
			
			if _input_map[check_row][check_col]:
				count += 1
				
	return count
				
	
