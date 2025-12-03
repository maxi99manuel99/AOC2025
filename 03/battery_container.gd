extends GridContainer

class BatteryBank:
	var batteries: Array[Battery]
	
	func _init(batteries_: Array[Battery]) -> void:
		self.batteries = batteries_
		

@export var battery_scene: PackedScene = null
var result_label: Label = null
var _input_banks := AOC_Input_03.new().input_to_array()
var _battery_banks: Array[BatteryBank] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	result_label = $"../../Result"
	self.columns = len(_input_banks[0].batteries)
	for bank in _input_banks:
		var battery_arr: Array[Battery] = []
		for battery in bank.batteries:
			var new_battery: Battery = battery_scene.instantiate()
			new_battery.set_value(battery)
			add_child(new_battery, true)
			battery_arr.append(new_battery)
		_battery_banks.append(BatteryBank.new(battery_arr))
	turn_on_batteries_count()
		

func turn_on_batteries_count(count: int = 12):
	var result: int = 0
	
	for bank in _battery_banks:
		var bank_batteries = bank.batteries
		var curr_indices = Array(range(0, count))
		for i in curr_indices:
			bank_batteries[i].turn_on()
			
		for i in range(1, len(bank_batteries)):
			await bank_batteries[i].highlight()
			for j in len(curr_indices):
				var curr_idx = curr_indices[j]
				if curr_idx < i and i + (count - j-1) < len(bank_batteries) and bank_batteries[i].value > bank_batteries[curr_idx].value:
					var dist = 0
					var new_indices: Array[int] = []
					for x in range(j, len(curr_indices)):
						var old_idx = curr_indices[x]
						bank_batteries[old_idx].turn_off()
						var new_idx = i + dist
						new_indices.append(new_idx)
						curr_indices[x] = new_idx
						dist += 1
					for idx in new_indices:
						bank_batteries[idx].turn_on()
					break
		var exponent = 1
		var bank_result = 0
		for i in curr_indices:
			bank_result = bank_result * pow(10, exponent) + bank_batteries[i].value
		result += bank_result
		result_label.text = "Current Result: "  + str(result)
	print(result)

		
		
			
			 
	
			
