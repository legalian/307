extends Label

var questions = [
	"Which of these programs has 38 file descriptors open at the end of execution, including stdin, stdout, and stderr",
	"Which hair resembles an exponential equation?",
	"Reverse the following SHA-256 hash: 2c0f0f4581aa813bfe2ea2128451ab86cee6b7442e17879e939751c9aa893859",
	"Find the surface area of the parametric surface r(u,v)=(2u+3v, 3u+v, 2), 0<=u<=2, 0<=v<=1",
	"I’d just like to interject for a moment. What you’re refering to as Linux, is in fact...",
	"What was the magic word for Quiz 9 of CS 240, Spring 2020?",
	"Which of the following hairstyles represents the equation: -3x^2 + 4?",
	"Dear Student/Faculty/Staff, You have a message from the Financial Department. Rev, Danny Stephens is downsizing and looking to give away her piano to a loving home. The piano is a...",
	"Type the text that you hear"
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



