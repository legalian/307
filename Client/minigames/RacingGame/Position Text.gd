extends Label

var colors = [Color(247, 37, 133), Color(114, 9, 183), Color(58, 12, 163), \
			  Color(67, 97, 238), Color(76, 201, 240),Color(252, 231, 98), \
			  Color(255, 253, 237), Color(255, 177, 122),Color(227, 197, 187), \
			  Color(223, 226, 207), Color(142, 164, 210), Color(98, 121, 184), \
			  Color(73, 81, 111), Color(73, 111, 93), Color(76, 159, 112), \
			  Color(235, 81, 96), Color(255, 213, 194), Color(242, 143, 59), \
			  Color(200, 85, 61), Color(249, 110, 70)]
var positionSuffix = ["ST","ND","RD","TH","TH","TH","TH","TH","TH","TH","TH","TH", "TH","TH","TH","TH","TH","TH","TH","TH"]
var rank = 1;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = str(rank) + positionSuffix[rank-1]
	self.set("custom_colors/font_color", colors[rank-1])
	
