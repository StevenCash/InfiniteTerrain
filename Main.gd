extends Node2D

var velocity = 0
var tileposx = 0
var tileposy = 0
var backsizex = 0
var backsizey = 0
var oldtileposx = 0
var oldtileposy = 0
var corrx = 0
var corry = 0
var repeat = 255
var tilenum = 0
export var res = 40
var cell = 16
var gradtable = [151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,
	30,69,142,8,99,37,240,21,10,23,190, 6,148,247,120,234,75,0,26,197,62,94,252,
	219,203,117,35,11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168, 68,
	175,74,165,71,134,139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,
	220,105,92,41,55,46,245,40,244,102,143,54, 65,25,63,161, 1,216,80,73,209,76,
	132,187,208, 89,18,169,200,196,135,130,116,188,159,86,164,100,109,198,173,186,
	3,64,52,217,226,250,124,123,5,202,38,147,118,126,255,82,85,212,207,206,59,227,
	47,16,58,17,182,189,28,42,223,183,170,213,119,248,152, 2,44,154,163, 70,221,
	153,101,155,167, 43,172,9,129,22,39,253, 19,98,108,110,79,113,224,232,178,185,
	112,104,218,246,97,228,251,34,242,193,238,210,144,12,191,179,162,241, 81,51,
	145,235,249,14,239,107,49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,
	50,45,127, 4,150,254,138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,
	215,61,156,180,151,160,137,91,90,15,131,13,201,95,96,53,194,233,7,225,140,36,103,
	30,69,142,8,99,37,240,21,10,23,190, 6,148,247,120,234,75,0,26,197,62,94,252,
	219,203,117,35,11,32,57,177,33,88,237,149,56,87,174,20,125,136,171,168, 68,
	175,74,165,71,134,139,48,27,166,77,146,158,231,83,111,229,122,60,211,133,230,
	220,105,92,41,55,46,245,40,244,102,143,54, 65,25,63,161, 1,216,80,73,209,76,
	132,187,208, 89,18,169,200,196,135,130,116,188,159,86,164,100,109,198,173,186,
	3,64,52,217,226,250,124,123,5,202,38,147,118,126,255,82,85,212,207,206,59,227,
	47,16,58,17,182,189,28,42,223,183,170,213,119,248,152, 2,44,154,163, 70,221,
	153,101,155,167, 43,172,9,129,22,39,253, 19,98,108,110,79,113,224,232,178,185,
	112,104,218,246,97,228,251,34,242,193,238,210,144,12,191,179,162,241, 81,51,
	145,235,249,14,239,107,49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,
	50,45,127, 4,150,254,138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,
	215,61,156,180]

# Called when the node enters the scene tree for the first time.
func _ready():
	backsizex = floor(get_viewport().size.x/cell+2)
	backsizey = floor(get_viewport().size.y/cell+2)
	corrx = floor(get_viewport().size.x/cell/2)
	corry = floor(get_viewport().size.y/cell/2)
	for i in range (backsizex):
		for j in range (backsizey):
			tilenum = octave(float(i)/res,float(j)/res)
			print(tilenum)
			$Backgroundmap.set_cell(i,j,tileassign(tilenum))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): 
	#determine position in terms of tilemap cells
	tileposx = $Scope.position.x/cell
	tileposy = $Scope.position.y/cell
	#scope origin is 336,256
	#add new background tiles based on position
	#will need to store current tilemap extents
	if(tileposx > oldtileposx):
		var i = tileposy-backsizey/2-2 
		while i < tileposy + backsizey/2 + 2:
			tilenum = octave(float(tileposx+backsizex/2)/res,float(i)/res)
			$Backgroundmap.set_cell(tileposx+backsizex/2,i,tileassign(tilenum))
			i += 1
	if(tileposx < oldtileposx):
		var i = tileposy-backsizey/2-2 
		while i < tileposy + backsizey/2 + 2:
			tilenum = octave(float(tileposx-backsizex/2)/res,float(i)/res)
			$Backgroundmap.set_cell(tileposx-backsizex/2-1,i,tileassign(tilenum))
			i += 1
	if(tileposy > oldtileposy):
		var i = tileposx-backsizex/2-2 
		while i < tileposx + backsizex/2 + 2:
			tilenum = octave(float(i)/res,float(tileposy+backsizey/2)/res)
			$Backgroundmap.set_cell(i,tileposy+backsizey/2,tileassign(tilenum))
			i += 1
	if(tileposy < oldtileposy):
		var i = tileposx-backsizex/2-2 
		while i < tileposx + backsizex/2 + 2:
			tilenum = octave(float(i)/res,float(tileposy-backsizey/2)/res)
			$Backgroundmap.set_cell(i,tileposy-backsizey/2-1,tileassign(tilenum))
			i += 1
	
	oldtileposx = tileposx
	oldtileposy = tileposy


func hashinc(x):
	x = x+1
	if (x>=512):
		x = 0
	return(x)

	
func perlsmooth(t):
	return(t*t*t*(t*(t*6-15)+10))


func perlinterp(x,a,b):
	return(a+x*(b-a))
	
	
func dotp(hashval,x,y):
		if(hashval % 3 == 0):
			return(x+y)
		elif(hashval % 3 == 1):
			return(-x+y)
		elif(hashval % 3 == 2):
			return(x-y)
		elif(hashval % 3 == 3):
			return(-x-y)
		else:
			return(0)

func perlin(x,y):
	#print(y)
	#if value exceeds repeat wrap
	if(x >= repeat):
		x = fmod(x,repeat)
	if(y >= repeat):
		y = fmod(y,repeat)
		
	#determine the unit square of the grid in which the point lies
	var xi = floor(x)
	var yi = floor(y)
	#calculate right/top side of square
	var xir = xi+1
	var yir = yi+1
	if(xir >= repeat):
		xir = fmod(xir,repeat)
	if(yir >= repeat):
		yir = fmod(yir,repeat)
	
	#find the offset inside the unit square of the point
	var xo = x-xi
	var yo = y-yi
	
	#apply smoothing function
	var xos = perlsmooth(xo)
	var yos = perlsmooth(yo)
	
	#Hash function
	var aa = gradtable[gradtable[xi]+yi];
	var ab = gradtable[gradtable[xi]+hashinc(yi)];
	var ba = gradtable[gradtable[hashinc(xi)]+yi];
	var bb = gradtable[gradtable[hashinc(xi)]+hashinc(yi)];
	
	#now calculate and interpolate horizontally first, then vertically
	
	var x1 = perlinterp(xos,dotp(aa,xo,yo),dotp(ba,xo-1,yo))
	var x2 = perlinterp(xos,dotp(ab,xo,yo-1),dotp(bb,xo-1,yo-1))
	var x3 = perlinterp(yos,x1,x2)
	
	#print(x3)
	return(x3)
	

func octave(x, y):
	var amplitude = 1
	var persistence = .5
	var maxval = 0
	var oct = 6
	var output = 0
	for i in range (oct):
		output += perlin(x*pow(2,i),y*pow(2,i))*amplitude
		maxval += amplitude
		amplitude *= persistence
	output *= 1/maxval
	return(output)
	

func tileassign(x):
	if(x < -0.4):
		return(0)
	elif(x < -0.2):
		return(1)
	elif(x < -0.1):
		return(2)
	elif(x < 0):
		return(3)
	elif(x < 0.1):
		return(4)
	elif(x < 0.2):
		return(5)
	elif(x < 0.3):
		return(6)
	elif(x < 0.4):
		return(7)
	else:
		return(8)
