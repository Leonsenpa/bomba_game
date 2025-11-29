extends Timer

var current_time = self.wait_time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_time -= delta
	$"../Label".text = str(round(current_time*100)/100)
	pass
