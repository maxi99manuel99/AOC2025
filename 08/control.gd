extends Control

var _junction_positions := AOC_Input_08.new().input_to_list_of_positions()
var _point_objs: Array[Point] = []
var _distances: Array[Distance] = []
var _circuits: Array[Circuit] = []

class Circuit:
	var members: Array[Point]
	
class Point:
	var position: Vector3
	var circuit: Circuit = null
	
	func _init(position_: Vector3) -> void:
		self.position = position_
		
	func _to_string() -> String:
		return str(position)
		
class Distance:
	var point1: Point
	var point2: Point
	var distance: float = INF
	
	func _init(point1_: Point, point2_: Point, distance_: float) -> void:
		self.point1 = point1_
		self.point2 = point2_
		self.distance = distance_
		
		
func _sort_by_distance(a: Distance, b: Distance):
	return a.distance < b.distance	

func _compute_distances(points: Array[Vector3], top_k: int = 5) -> void:
	var n_points = len(points)
	for point in points:
		_point_objs.append(Point.new(point))

	for i in n_points:
		var top_k_neighbors: Array = []
		var max_idx_top_neighbors := -1
		var max_distance_top_neighbors := -INF
		
		for j in range(i + 1, n_points):
			var d = points[i].distance_squared_to(points[j])
			var dist_obj = Distance.new(_point_objs[i], _point_objs[j], d)
			
			if top_k:
				# running top-k neighbors
				if len(top_k_neighbors) < top_k:
					top_k_neighbors.append(dist_obj)
					if d > max_distance_top_neighbors:
						max_distance_top_neighbors = d
						max_idx_top_neighbors = len(top_k_neighbors) - 1
				else:
					if d < max_distance_top_neighbors:
						top_k_neighbors[max_idx_top_neighbors] = dist_obj
						max_distance_top_neighbors = top_k_neighbors[0].distance
						max_idx_top_neighbors = 0
						for idx in range(1, len(top_k_neighbors)):
							if top_k_neighbors[idx].distance > max_distance_top_neighbors:
								max_distance_top_neighbors = top_k_neighbors[idx].distance
								max_idx_top_neighbors = idx
			else:
				_distances.append(dist_obj)
		
		if top_k:
			for n in top_k_neighbors:
				_distances.append(n)

	_distances.sort_custom(_sort_by_distance)
	
func _sort_by_circuit_len_descending(a: Circuit, b: Circuit):
	return len(a.members) > (len(b.members))
	
func _connect_nearest_to_circuit(n_nearest: int = 0) -> void:
	if !n_nearest:
		n_nearest = 10000000000000
	for i in range(0, n_nearest):
		var point1 := _distances[i].point1
		var point2 := _distances[i].point2
		if point1.circuit == null and point2.circuit == null:
			var c := Circuit.new()
			c.members = []
			c.members.append(point1)
			c.members.append(point2)
			point1.circuit = c
			point2.circuit = c
			_circuits.append(c)
			
		elif point1.circuit != null and point2.circuit == null:
			point1.circuit.members.append(point2)
			point2.circuit = point1.circuit

		elif point1.circuit == null and point2.circuit != null:
			point2.circuit.members.append(point1)
			point1.circuit = point2.circuit

		elif point1.circuit != point2.circuit:
			var target := point1.circuit
			var source := point2.circuit

			for member in source.members:
				if not target.members.has(member):
					target.members.append(member)
					member.circuit = target
			_circuits.erase(source)
		
		if len(_circuits[0].members) == len(_point_objs):
			print("All points are now in the same circuit. The multiplication of the x coordinates of the last two points that were added is: " + str(int(point1.position.x * point2.position.x)))
			return
			
	for point in _point_objs:
		if not point.circuit:
			var c := Circuit.new()
			c.members = [point]
			point.circuit = c
			_circuits.append(c)
	
	_circuits.sort_custom(_sort_by_circuit_len_descending)

func _ready() -> void:
	var start_time = Time.get_ticks_msec()
	_compute_distances(_junction_positions)
	_connect_nearest_to_circuit(1000)
	var result1: int = 1
	for i in 3:
		result1 *= len(_circuits[i].members)
	print("Result1: " + str(result1))
	_connect_nearest_to_circuit()
	var elapsed = Time.get_ticks_msec() - start_time
	print("Elapsed: ", elapsed, " ms")
	
		
