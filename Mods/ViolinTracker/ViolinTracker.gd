extends Mod_Base

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Violin.transform.origin.x = 0
	$Violin.transform.origin.y = 0
	$Violin.transform.origin.z = 2.5
	$ViolinBow.transform.origin.x = 0
	$ViolinBow.transform.origin.y = 0
	$ViolinBow.transform.origin.z = 2.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
