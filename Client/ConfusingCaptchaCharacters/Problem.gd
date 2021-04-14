extends Label

var questions = [
	"how much or how many",
	"yeah dude yeah",
	"if it were greater how much less greater it be",
	"Gustavo"
]

var questionText = ""


func _ready():
	self.set_text(questionText)

func setQuestion(question):
	if question>=0:
		questionText = questions[question];
	self.set_text(questionText)



