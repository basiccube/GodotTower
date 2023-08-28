extends Node

var panic = false
var saveroom = []
var baddieroom = []
var targetLevel = ""
var targetRoom = ""
var targetDoor = "A"

var minutes = 0
var seconds = 59

var combo = 0
var combotime = 0
var collect = 0
var key_inv = 0
var hit = 0

var bigfont = load("res://Objects/HUD/font.tres")

enum states {
	normal,
	jump,
	backbreaker,
	crouch,
	crouchjump,
	crouchslide,
	tumble,
	freefallprep,
	freefallland,
	freefall,
	mach1,
	mach2,
	mach3,
	machfreefall,
	machslide,
	machroll,
	bump,
	comingoutdoor,
	door,
	handstandjump,
	hurt,
	climbwall,
	titlescreen,
	fireass,
	timesup,
	gameover,
	Sjumpprep,
	Sjumpland,
	Sjump,
	victory,
	knightpep,
	knightpepslopes,
	knightpepattack,
	keyget,
	smirk,
	gottreasure,
	bossintro,
	tackle,
	superslam,
	slam,
	grab,
	punch,
	shoulder,
	uppunch,
	backkick,
	bombpep,
	grabbed,
	stun,
	turn,
	walk,
	land,
	hit,
	pizzagoblinthrow,
	throw,
	cheesepep,
	cheeseball,
	cheesepepstick,
	facestomp,
}
