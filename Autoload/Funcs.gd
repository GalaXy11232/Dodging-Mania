extends Node

const __INIT_ZOOMED_CAMERA := Vector2(3, 3)
const __LAST_BEAT_FireEmblem := 378#385
const __BPM_FireEmblem := 212.0
const __DEFAULT_VIEWPORT_RECT := Vector2(1920.0, 1080.0)

const GREEN = Color(0, 1, 0)

func fixed_intfloat_decimal(num: float) -> Variant:
	if int(num) == num: return int(num)
	return num

func clampL(l: float, maxr: float) -> float:
	if (l <= maxr): return l
	return maxr
