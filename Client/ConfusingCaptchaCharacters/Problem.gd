extends Label

var questionText = "Question Text Goes Here"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_text(questionText)

func setQuestion(question):
	questionText = question;
	self.set_text(questionText)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
