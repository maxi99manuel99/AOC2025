extends Control

var _machines_input := AOC_Input_10.new().input_to_list_of_machines()

class Priority_Queue:
	
	var data: Array[Dictionary] = []  
	
	func _parent(i: int) -> int:
		return (i - 1) / 2
		
	func _left(i: int) -> int:
		return 2 * i + 1
		
	func _right(i: int) -> int:
		return 2 * i + 2
		
	func insert(item, priority: int) -> void:
		self.data.append({ "item": item, "prio": priority })
		_sift_up(len(self.data) - 1)
		
	func pop_min() -> Dictionary:
		if self.data.is_empty():
			return {}

		var ret := self.data[0]
		self.data[0] = self.data[len(self.data) - 1]
		self.data.pop_back()
		_sift_down(0)
		return ret

	func _sift_up(idx: int) -> void:
		while idx > 0:
			var p := _parent(idx)
			if self.data[idx].prio < self.data[p].prio:
				var tmp := self.data[p]
				self.data[p] = self.data[idx]
				self.data[idx] = tmp
				idx = p
			else:
				break
				
	func _sift_down(idx: int) -> void:
		var size := self.data.size()
		while true:
			var l := _left(idx)
			var r := _right(idx)
			var smallest := idx
			
			if l < size and self.data[l].prio < self.data[smallest].prio:
				smallest = l
			if r < size and self.data[r].prio < self.data[smallest].prio:
				smallest = r
				
			if smallest != idx:
				var tmp := self.data[idx]
				self.data[idx] = self.data[smallest]
				self.data[smallest] = tmp
				idx = smallest
			else:
				break
				
	func is_empty() -> bool:
		return self.data.is_empty()
		
func _solve_machine_fewest_presses(light_diagram: Array[int], buttons: Array[Array]) -> int:
	var prio_queue := Priority_Queue.new()
	var visited := {} 
	
	var light_len = len(light_diagram)
	var initial_light: Array[int] = []
	var initial_buttons_pressed: Array[bool] = []
	for i in light_len:
		initial_light.append(0)
	for i in len(buttons):
		initial_buttons_pressed.append(false)
		
	prio_queue.insert([initial_light, initial_buttons_pressed], 0)
	
	visited[str(initial_light)] = true
	
	while not prio_queue.is_empty():
		var prio_obj := prio_queue.pop_min()
		var current_lights: Array[int] = prio_obj.item[0]
		var buttons_pressed: Array[bool] = prio_obj.item[1]
		var button_presses: int = prio_obj.prio
		
		if current_lights == light_diagram:
			return button_presses 
		
		var btn_idx: int = 0
		for button in buttons:
			if not buttons_pressed[btn_idx]:
				var new_lights = current_lights.duplicate(true)
				for i in len(new_lights):
					new_lights[i] = (new_lights[i] + button[i]) % 2 
				var key = str(new_lights)
				if not visited.has(key):
					visited[key] = true
					var new_buttons_pressed = buttons_pressed.duplicate(true)
					new_buttons_pressed[btn_idx] = true
					prio_queue.insert([new_lights, new_buttons_pressed], button_presses+1)
			btn_idx += 1
				
	return -1
	
func _solve_joltage_fewest_presses(joltages: Array[int], buttons: Array[Array]) -> int:
	var prio_queue := Priority_Queue.new()
	var visited := {} 
	
	var joltage_len = len(joltages)
	var initial_joltage: Array[int] = []
	for i in joltage_len:
		initial_joltage.append(0)
	
	prio_queue.insert(initial_joltage, 0)
	visited[str(initial_joltage)] = true
	
	while not prio_queue.is_empty():
		var prio_obj := prio_queue.pop_min()
		var current_joltages: Array[int] = prio_obj.item
		var button_presses: int = prio_obj.prio
		
		if current_joltages == joltages:
			return button_presses 
		
		for button in buttons:
			var new_joltages: Array[int] = []
			for i in range(joltage_len):
				new_joltages.append(current_joltages[i] + button[i])
			
			var key = str(new_joltages)
			if not visited.has(key):
				visited[key] = true
				prio_queue.insert(new_joltages, button_presses+1)
				
	return -1
	
	
func _ready() -> void:
	var total_btn_presses_lights: int = 0
	
	for machine in _machines_input:
		total_btn_presses_lights += _solve_machine_fewest_presses(machine.light_diagram, machine.buttons)
	print("Result1: " + str(total_btn_presses_lights))
	
	"""
	var total_btn_presses_joltages: int = 0
	for machine in _machines_input:
		total_btn_presses_joltages += _solve_joltage_fewest_presses(machine.joltage_requirements, machine.buttons)
	print("Result2: " + str(total_btn_presses_joltages))
	"""
