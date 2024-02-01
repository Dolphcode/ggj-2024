extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "You cleared " + str(ScoreKeeper.score) + " stages"


