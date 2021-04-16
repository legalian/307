extends Label

var questions = [
	"Pick the motorcycle",
	"Which of these programs has 38 file descriptors open at the end of execution, including stdin, stdout, and stderr",
	"Which hair resembles an exponential equation?",
	"Which number shows the number, 1?"
]


var questionText = ""


func roundEnd():
	self.set_text("Round Ended!")

func _ready():
	self.set_text(questionText)

func setQuestion(question):
	if question>=0:
		questionText = questions[question];
	self.set_text(questionText)



