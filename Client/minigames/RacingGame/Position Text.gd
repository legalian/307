extends Label

var colors = [Color8(247, 37, 133), Color8(114, 9, 183), Color8(58, 12, 163), \
			  Color8(67, 97, 238), Color8(76, 201, 240),Color8(252, 231, 98), \
			  Color8(255, 253, 237), Color8(255, 177, 122),Color8(227, 197, 187), \
			  Color8(223, 226, 207), Color8(142, 164, 210), Color8(98, 121, 184), \
			  Color8(73, 81, 111), Color8(73, 111, 93), Color8(76, 159, 112), \
			  Color8(235, 81, 96), Color8(255, 213, 194), Color8(242, 143, 59), \
			  Color8(200, 85, 61), Color8(249, 110, 70)]
var positionSuffix = ["ST","ND","RD","TH","TH","TH","TH","TH","TH","TH","TH","TH", "TH","TH","TH","TH","TH","TH","TH","TH"]
var rank = 3;
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
	
