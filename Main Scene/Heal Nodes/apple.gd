extends StaticBody2D

var idle_tween: Tween
const rotation_duration := 1.0

var can_be_consumed: bool = false

func _ready() -> void:
	can_be_consumed = false
	
	self.modulate.a = 0
	var fadein := create_tween()
	fadein.tween_property(self, "modulate:a", 1, 0.5)
	
	idle_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops(30)
	idle_tween.tween_property(self, 'rotation', deg_to_rad(15), rotation_duration)
	idle_tween.tween_property(self, 'rotation', deg_to_rad(-15), rotation_duration)
	
	await fadein.step_finished
	can_be_consumed = true 

func ease_out() -> void:
	var eot := create_tween()
	eot.tween_property(self, "modulate:a", 0, 0.5)
	
	await eot.step_finished
