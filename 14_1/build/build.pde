// SETUP ********************************************************************************************************************
// import hype.*;
// import hype.extended.layout.HGridLayout;
// import hype.extended.behavior.HOscillator;

int     stageW     = 1000;
int     stageH     = 1000;
String  pathDATA   = "../data/";
String timestamp;

// COLORS ********************************************************************************************************************

color   bg         = #111111;
color   fg         = #F1F1F1;
color   pink       = #FFC0CB;
color   cyan       = #00FFFF;
color   purple     = #590F70;
color 	grey     	 = #5A5F79;

color[] colors = {
  pink,
	cyan,
	purple,
	fg,
	bg
};

// PROJECT ********************************************************************************************************************

PVector[] pos;
PVector[][] pos2;

final int xOff = 100;
final int yOff = 100;
final int spacing = 20;
char t;
int charIndex;
char swap;

int cols;
int rows;
int numAssets;

// String[] lines = {
// 	"What\'s happened, happened. ",
// 	" ",
// 	" ",
// 	" ",
// 	" ",
// 	"Which is an expression of ",
// 	" ",
// 	" ",
// 	" ",
// 	" ",
// 	"fate in the mechanics of the world. ",
// 	" ",
// 	" ",
// 	" ",
// 	" ",
// 	"It\'s not an excuse to do nothing. "
// };

String[] lines = {
	"Hey, kiddo, ",
	" ",
	" ",
	" ",
	" ",
	"lost track of time. ",
};

// String[]  lines = {
// 	"We used to look up at the sky ",
// 	" ",
// 	" ",
// 		" ",
// 	" ",
// 	"and wonder at our place in ",
// 		" ",
// 	" ",
// 		" ",
// 	" ",
// 	"the stars. ",
// 	" ",
// 	" ",
// 		" ",
// 	" ",
// 			" ",
// 	" ",
// 	"Now we just look down and ",
// 	" ",
// 	" ",
// 		" ",
// 	" ",
// 	"worry about our place in ",
// 	" ",
// 	" ",
// 	" ",
// 	" ",
// 	"the dirt. "
// };

PFont font;
String density = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.',";
String density2 = " ░▒▓█▀╿▁▂▃▄▅▆▇█▉▊▙▚▛▜▝▞▟▘┠┫░▒▓█▀╿▁▂▃▄▅▆▇█▉▊▙▚▛▜▝▞▟▘┠┫.',";
// String density2 = "   ░▒▓█▀╿▁▂▃▄▅▆▇█▉▊▙▚▛▜▝▞▟▘";
int densityLen = density.length();

// IMAGES  ********************************************************************************************************************

PImage img;

// SHADER ******************************************************************

PShader shader;

// UTILITIES ********************************************************************************************************************

boolean   letsRender   = true;
boolean   letsRenderHD = false;

int       renderNum    = 0;
int       renderMax    = 30;
int       renderModulo = 20;

PGraphics renderCanvas;
PGraphics child1Canvas;
PGraphics child2Canvas;

PGraphics renderCanvasHD;
PGraphics child1CanvasHD;
PGraphics child2CanvasHD;
int       renderCanvasHD_w;
int       renderCanvasHD_h;
int       renderCanvasHD_s = 1;

String    renderPATH   = "../render/";

// ********************************************************************************************************************

void settings() {
	size(stageW,stageH,P3D);
}

void setup() {
	background(grey);
	font = createFont("IBMPlexMono-Medm", 16);
	noLoop();
	surface.setLocation(0,0); // position

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position

	cols = (width - (xOff *2)) / spacing;
	rows = (height - (xOff *2)) / spacing;
	numAssets = cols * rows;

	pos = new PVector[numAssets];

	pos2 = new PVector[rows][cols];
	int i = 0;

	for (int x = 0; x < cols; ++x) {
		for (int y = 0; y < rows; ++y) {
			float xPos = (x * spacing) + xOff;
			float yPos = (y * spacing) + yOff;
			PVector v = new PVector(xPos, yPos);
			pos2[x][y] = v;
		}
	}


	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(2);
}

void draw() {
	hint(DISABLE_DEPTH_TEST);

	PGraphics _whichCanvas;
	PGraphics _child1;
	PGraphics _child2;
	int       _w; // width
	int       _h; // height
	float     _s; // scale

	if (letsRenderHD) {
		_whichCanvas = renderCanvasHD;
		_child1      = child1CanvasHD;
		_child2      = child2CanvasHD;
		_w           = renderCanvasHD_w;
		_h           = renderCanvasHD_h;
		_s           = renderCanvasHD_s;
	} else {
		_whichCanvas = renderCanvas;
		_child1      = child1Canvas;
		_child2      = child2Canvas;
		_w           = stageW;
		_h           = stageH;
		_s           = 1.0;
	}

	float wave = map(tan(radians(frameCount)), -1, 1, -0.0005, 0.75);
	float wave2 = map(cos(radians(frameCount)) + sin(radians(frameCount)), -1, 1, 0.75, -0.0005);

	float n = noise( 0.01 + frameCount * 0.001);

	background(grey);
	noStroke();

	// translate(_w / 2, _h / 2, 0);

	// _child1.beginDraw();
	// 	_child1.clear();
	// 	_child1.push();

	// 	for (int y = yOff; y < height - yOff; y += spacing) {
	// 		for (int x = xOff; x < random(width - xOff); x += spacing) {
	// 			_child1.push();
	// 				_child1.translate(x, y);
	// 				_child1.fill(pink);
	// 				_child1.textFont(font);
	// 				if (x == 50) {
	// 					t = density2.charAt((int)random(density.length()));	
	// 				} else {
	// 					t = density.charAt((int)random(density.length()));
	// 				}
	// 				_child1.text(t, 0, 0);
	// 			_child1.pop();
	// 		}			
	// 	}
	// 	_child1.pop();
	// _child1.endDraw();

	_child1.beginDraw();
		_child1.clear();
		_child1.push();
		int j = 0;
		int total = numAssets - 1;
		for (int y = 0; y <= lines.length - 1; ++y) {
			String temp = lines[y];
			int tempLength = temp.length();
			println("tempLength: "+tempLength);
			for (int x = 0; x < tempLength - 1; ++x) {
				println("pos: "+pos2[x][y]);
				_child1.push();
						_child1.translate(pos2[x][y].x, pos2[x][y].y);
						_child1.fill(pink);
						_child1.textFont(font);
						t = temp.charAt(x);
						charIndex = density.indexOf(t);
						swap = density2.charAt(charIndex);
						println("t: "+t);
						println("charIndex: "+charIndex);
						println("swap: "+swap);
						_child1.text(swap, 0, 0);
					_child1.pop();
			}
		}
		_child1.pop();
	_child1.endDraw();

	_whichCanvas.beginDraw();
		_whichCanvas.clear();
		_whichCanvas.image(_child1,0,0);
	_whichCanvas.endDraw();
	
	if (!letsRenderHD) {
		image(_whichCanvas,0,0);
	}

	surface.setTitle(
		"FPS = " + (int)frameRate
	);

	if (frameCount == 360 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		// timestamp = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
		saveFrame("../output/sequence-####.png");
	}	
}