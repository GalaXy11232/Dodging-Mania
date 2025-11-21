class_name randomArrayData
extends Node

## Contains the random elements to be chosen
@export var containing_array: Array

func _init(arr: Array = []) -> void:
	containing_array = arr

func select_random() -> Variant:
	randomize()
	
	var chosen := randi_range(0, len(containing_array)-1)
	return containing_array[chosen]
