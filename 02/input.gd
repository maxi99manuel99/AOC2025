class_name AOC_Input_02
extends RefCounted

class IdRange:
	var start: int
	var end: int
	
	func _init(start_: int, end_: int) -> void:
		self.start = start_
		self.end = end_
		

var input_data: String = "5529687-5587329,50-82,374-560,83-113,226375-287485,293169-368713,2034-2634,9945560-9993116,4872472-4904227,3218-5121,1074-1357,15451-26093,483468003-483498602,51513-85385,1466-1992,7600-13034,710570-789399,407363-480868,3996614725-3996662113,3-17,5414907798-5414992881,86274-120443,828669-909588,607353-700604,4242340614-4242556443,28750-44009,935177-1004747,20-41,74678832-74818251,8484825082-8484860878,2784096938-2784156610,5477-7589,621-952,2424167145-2424278200,147085-217900,93043740-93241586"


func input_to_array() -> Array[IdRange]:
	var result: Array[IdRange] = []
	for range_str in input_data.split(","):
		var start_end: PackedStringArray = range_str.split("-")
		var new_range: IdRange = IdRange.new(int(start_end[0]), int(start_end[1]))
		result.append(new_range)
	return result
	
	
	
