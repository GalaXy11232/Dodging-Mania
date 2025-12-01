extends HSlider

@onready var name_label: Label = $LabelName

@export var bus_name: String
@export var volume_label_name: String
var bus_index: int

func update_label_to_volume() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	self.value = AudioServer.get_bus_volume_linear( bus_index )

func _ready() -> void:
	self.max_value = 1.0
	self.step = 0.001
	
	value_changed.connect(_on_value_changed)
	name_label.text = volume_label_name


func _on_value_changed(val: float) -> void:
	SaveData.update_audio_by_name(bus_name, val)
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(val)
	)
