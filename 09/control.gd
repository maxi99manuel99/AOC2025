extends Control

var _red_tile_positions := AOC_Input_09.new().input_to_list_of_positions()

class Rectangle:
	var top_left: Vector2
	var top_right: Vector2
	var bot_left: Vector2
	var bot_right: Vector2
	var edges: Array[Array]
	
	func _init(tile1: Vector2, tile2: Vector2) -> void:
		self.top_left  = tile1.min(tile2)
		self.bot_right = tile1.max(tile2)
		self.top_right = Vector2(bot_right.x, top_left.y)
		self.bot_left = Vector2(top_left.x, bot_right.y)
		
		self.edges = [
			[self.top_left, self.top_right],
			[self.top_right, self.bot_right],
			[self.bot_right, self.bot_left],
			[self.bot_left, self.top_left]
		]
		
	func get_area() -> float:
		var width = top_right.x - top_left.x + 1
		var height = bot_left.y - top_left.y + 1
		return width * height

func _rect_inside_polygon(rect: Rectangle, polygon: Array[Vector2]) -> bool:
	# Ensure that all rectangle corners are inside the green polygon
	for corner in [rect.top_left, rect.top_right, rect.bot_right, rect.bot_left]:
		if not Geometry2D.is_point_in_polygon(corner, polygon):
			return false
	
	# Test intersections of rectangle edges with green polygon edges
	for rect_edge in rect.edges:
		for i in len(polygon):
			var poly_edge := [polygon[i], polygon[(i + 1) % polygon.size()]]
			
			var intersection_point = Geometry2D.segment_intersects_segment(rect_edge[0], rect_edge[1], poly_edge[0], poly_edge[1])
			if intersection_point:
				# if the intersection point is any of the endpoints the rectangle edge does not cross the polygon and therefore does not leave the polygon
				if (intersection_point != rect_edge[0]) and (intersection_point != rect_edge[1]) and (intersection_point != poly_edge[0]) and (intersection_point != poly_edge[1]):
					return false
					
	return true

func _ready() -> void:
	var biggest_area: int = 0
	var biggest_area2: int = 0
	var _n_tiles = len(_red_tile_positions)
	for i in _n_tiles:
		for j in range(i+1, _n_tiles):
			var rect := Rectangle.new(_red_tile_positions[i], _red_tile_positions[j])
			var area = rect.get_area()
			if area > biggest_area:
				biggest_area = area
			if _rect_inside_polygon(rect, _red_tile_positions):
				if area > biggest_area2:
					biggest_area2 = area
			
	print("Result1: " + str(biggest_area))
	print("Result2: " + str(biggest_area2))
