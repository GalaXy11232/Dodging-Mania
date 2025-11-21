class_name staticIntInterval
extends Resource

@export var left: int
@export var right: int

func _init(l: int = 0, r: int = 1) -> void:
	left = l
	right = r


## Returns true if given number is inside the interval;
## CLOSED INTERVAL means it contains both ends
func is_inside(val: float, closed: bool = true) -> bool:
	if closed: return (left <= val and val <= right)
	else: return (left < val and val < right)

func set_ends(st: int, dr: int) -> void:
	left = st
	right = dr

func get_left_end() -> int: return left
func get_right_end() -> int: return right
