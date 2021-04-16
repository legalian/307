extends Label

var questions = [
	"Pick the motorcycle",
	"Which of these programs has 38 file descriptors open at the end of execution, including stdin, stdout, and stderr",
	"Which hair resembles an exponential equation?",
	"Which number shows the number, 1?",
	"Reverse the following SHA-256 hash: 2c0f0f4581aa813bfe2ea2128451ab86cee6b7442e17879e939751c9aa893859",
	"Find the surface area of the parametric surface r(u,v)=(2u+3v, 3u+v, 2), 0<=u<=2, 0<=v<=1",
	"What is the correct R code to generate the p value?"
]
var roundEnded = false;


var questionText = ""


func roundEnd():
	questionText = "Round Ended!"
	roundEnded = true;

func roundStart():
	roundEnded = false;

func _ready():
	self.set_text(questionText)

func setQuestion(question):
	if question>=0 && roundEnded != true:
		questionText = questions[question];
	self.set_text(questionText)



