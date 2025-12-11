extends Control

var _input_graph := AOC_Input_11.new().input_to_graph_dict()
var _count_at_dict: Dictionary[String, int] = {}
var _count_at_dict_visited_both: Dictionary[String, int] = {}

func _ready() -> void:
	print("Result1: " + str(_count_path_to_out_recursive("you")))
	print("Result2: " + str(_count_path_to_out_recursive_ensure_visit_dac_fft("svr")))
	
func _count_path_to_out_recursive(current_node: String) -> int:
	if _count_at_dict.has(current_node):
		return _count_at_dict[current_node]
	
	var neighbors := _input_graph[current_node]
	
	if neighbors[0] == "out":
		_count_at_dict[current_node] = 1
		return 1
	
	var path_count: int = 0
	for neighbor in neighbors:
		var _count_at_neighbor = _count_path_to_out_recursive(neighbor)
		path_count += _count_at_neighbor
	_count_at_dict[current_node] = path_count
	
	return path_count
			
func _count_path_to_out_recursive_ensure_visit_dac_fft(current_node: String, visited_dac: bool = false, visited_fft: bool = false) -> int:
	var key = current_node + str(visited_dac) + str(visited_fft)
	if _count_at_dict_visited_both.has(key):
		return _count_at_dict_visited_both[key]
		
	if current_node == "dac":
		visited_dac = true
	elif current_node == "fft":
		visited_fft = true
	
	var neighbors := _input_graph[current_node]
	
	if neighbors[0] == "out":
		if visited_dac and visited_fft:
			_count_at_dict_visited_both[key] = 1
			return 1
		else:
			_count_at_dict_visited_both[key] = 0
			return 0

	var path_count: int = 0
	for neighbor in neighbors:
		var _count_at_neighbor = _count_path_to_out_recursive_ensure_visit_dac_fft(neighbor, visited_dac, visited_fft)
		path_count += _count_at_neighbor
	_count_at_dict_visited_both[key] = path_count
	
	return path_count
