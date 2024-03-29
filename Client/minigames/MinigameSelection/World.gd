extends "res://minigame.gd"

onready var minigameAnimation = get_node("AnimationPlayer")
var done = false;

var minigameList = [["Racing", "Race Around the Track, Use Power Ups, and Pass All Other Racers To Win!", "res://minigames/MinigameSelection/MinigameSprites/RacingThumbnail.png"],
["Battle Royale", "Drop on A Huge Map, Pick Up Weapons, and Eliminate Other Players to be the Last Remaining!", "res://minigames/MinigameSelection/MinigameSprites/BattleRoyale_Icon.png"], 
["Demolition Derby", "Use Power Ups and Ram into Other Players to be the Last Remaining!", "res://minigames/MinigameSelection/MinigameSprites/CarSelectionPage.png"],
["Confusing Captcha", "Select the correct image for the given question!", "res://minigames/MinigameSelection/MinigameSprites/captcha.jpeg"]
]
var currentMinigame = 0

func _ready():
	pass
	

func _Select_Minigame(minigame):
	currentMinigame = minigame;
	_Set_Minigame();
	if OS.get_environment("MULTI_USER_TESTING")!=null and "shim" in OS.get_environment("MULTI_USER_TESTING"):
		Finished_Animation()
	else:
		minigameAnimation.play("SelectMinigameDisplay")
	

func _Set_Minigame():
	find_node("MinigameTitle").text = minigameList[currentMinigame][0]
	find_node("MinigameSummary").text = minigameList[currentMinigame][1]
	find_node("MinigameIcon").texture = load(minigameList[currentMinigame][2])

func Finished_Animation(): # Not Triggering?
	done = true;
	self.visible = false;
	self.get_node("Camera2D").current = false;



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
