extends Node

const __INIT_ZOOMED_CAMERA := Vector2(3, 3)
const __LAST_BEAT_FireEmblem := 378#385
const __DEFAULT_VIEWPORT_RECT := Vector2(1920.0, 1080.0)

const GREEN = Color(0, 1, 0)

const __BPM_FireEmblem := 212.0
const __BPM_Tutorial := 120.0

## GLOBAL VARIABLES FOR SONG FUNCTIONALITY
var track_name: String
var track_savefile: String 
#var track_bpm: float
## =======================================

func _ready() -> void:
	## DISABLE DEFAULT CLOSE REQUESTS
	get_tree().set_auto_accept_quit(false)

func _notification(what: int) -> void:
	## MANUALLY HANDLE APP CLOSING REQUESTS
	## (OBS): Alt + F4 automatically fires NOTIFICATION_WM_CLOSE_REQUEST, so no need to handle it separately
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await SaveData.save_options_data()
		
		get_tree().quit()

func fixed_intfloat_decimal(num: float) -> Variant:
	if int(num) == num: return int(num)
	return num

func clampL(l: float, maxr: float) -> float:
	if (l <= maxr): return l
	return maxr

func set_label_pivot_offset_by_text(label: Label, text: String) -> void:
	label.text = text
	label.pivot_offset = label.size / 2
	return
