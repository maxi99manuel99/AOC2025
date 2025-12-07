extends GridContainer

var manifold := AOC_Input_07.new().input_to_manifold()
var _map = manifold.map
var _timeline_count_map: Array[Array]

func _ready() -> void:
	var start_point: Array[int] = manifold.start_point
	print("Result1: " + str(send_beam_downwards_and_count_splits(start_point)))
	for row in _map:
		var new_row := []
		new_row.resize(row.size())
		new_row.fill(0)
		_timeline_count_map.append(new_row)
	print("Result1: " + str(send_beam_downwards_and_count_timelines(start_point)))
	

func send_beam_downwards_and_count_splits(start_point: Array[int]) -> int:
	var current_point := start_point
	if _map[current_point[0]][current_point[1]] == "|":
		return 0
	_map[current_point[0]][current_point[1]] = "|"
	while true:
		current_point = [current_point[0]+1, current_point[1]]	
		if current_point[0] >= len(_map) or _map[current_point[0]][current_point[1]] == "|":
			return 0
		elif _map[current_point[0]][current_point[1]] == "^":
			return 1 + send_beam_downwards_and_count_splits([current_point[0], current_point[1]+1]) + send_beam_downwards_and_count_splits([current_point[0], current_point[1]-1])
		_map[current_point[0]][current_point[1]] = "|"
	
	return 0
	
func send_beam_downwards_and_count_timelines(start_point: Array[int]) -> int:
	var current_point := start_point
	while true:
		current_point = [current_point[0]+1, current_point[1]]	
		if current_point[0] >= len(_map):
			return 1
		elif _map[current_point[0]][current_point[1]] == "^":
			if _timeline_count_map[current_point[0]][current_point[1]] != 0:
				return _timeline_count_map[current_point[0]][current_point[1]]
			var right_count = send_beam_downwards_and_count_timelines([current_point[0], current_point[1]+1]) 
			var left_count = send_beam_downwards_and_count_timelines([current_point[0], current_point[1]-1])
			_timeline_count_map[current_point[0]][current_point[1]] = right_count + left_count
			return right_count + left_count
	
	return 0
	
