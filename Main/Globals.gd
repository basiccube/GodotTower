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
var golfhit = 0

var hurtcounter = 0
var hurtmilestone = 3

var srank = 0
var arank = 0
var brank = 0
var crank = 0

var bigfont = load("res://Objects/HUD/font.tres")
var smallnumberfont = load("res://Objects/HUD/smallnumber.tres")

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
	finishingblow,
	keyget,
	smirk,
	gottreasure,
	bossintro,
	tackle,
	superslam,
	slam,
	grab,
	grabbed,
	grabbing,
	punch,
	shoulder,
	uppunch,
	backkick,
	bombpep,
	skateboard,
	slipnslide,
	stun,
	turn,
	idle,
	walk,
	land,
	hit,
	charge,
	pizzagoblinthrow,
	throw,
	cheesepep,
	cheeseball,
	cheesepepstick,
	facestomp,
	ejected,
}
