// SETUP ********************************************************************************************************************
// import hype.*;
// import hype.extended.layout.HGridLayout;
// import hype.extended.behavior.HOscillator;

int     stageW     = 1000;
int     stageH     = 1000;
String  pathDATA   = "../data/";
String timestamp;


Line l;


// COLORS ********************************************************************************************************************

color   bg         = #111111;
color   fg         = #F1F1F1;
color   pink       = #FFC0CB;
color   cyan       = #00FFFF;
color   purple     = #590F70;
color 	grey     	 = #5A5F79;

color[] cols = {
  pink,
	cyan,
	purple,
	fg,
	bg
};
// PROJECT ********************************************************************************************************************

float x = random(0,500);
float x2 = random(0,500);
float y = random(0,1000);
float y2 = random(0,1000);
float xSpeed = 5;
float ySpeed = 4;
float x2Speed = 5;
float y2Speed = 4;

float boxSize = 300;


// IMAGES  ********************************************************************************************************************


PShape s = new PShape();
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
PGraphics renderCanvas2;
PGraphics child1Canvas;
PGraphics child2Canvas;

PGraphics renderCanvasHD;
PGraphics renderCanvasHD2;
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
	surface.setLocation(0,0); // position
	// ((PGraphicsOpenGL)g).textureSampling(2);

	s = loadShape(pathDATA + "dot.svg");
	s.disableStyle();

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvas2   = createGraphics(0,stageH / 2,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW / 2,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w / 2,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW / 2,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w / 2,renderCanvasHD_h,P3D);

	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position

	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(5);
}

void draw() {
	hint(DISABLE_DEPTH_TEST);
		background(grey);
// noLoop();
// background(grey);
	PGraphics _whichCanvas;
	PGraphics _whichCanvas2;
	PGraphics _child1;
	PGraphics _child2;
	int       _w; // width
	int       _h; // height
	float     _s; // scale

	if (letsRenderHD) {
		_whichCanvas = renderCanvasHD;
		_whichCanvas2 = renderCanvasHD2;
		_child1      = child1CanvasHD;
		_child2      = child2CanvasHD;
		_w           = renderCanvasHD_w;
		_h           = renderCanvasHD_h;
		_s           = renderCanvasHD_s;
	} else {
		_whichCanvas = renderCanvas;
		_whichCanvas2 = renderCanvas;
		_child1      = child1Canvas;
		_child2      = child2Canvas;
		_w           = stageW;
		_h           = stageH;
		_s           = 1.0;
	}

	float wave = map(tan(radians(frameCount)), -1, 1, -100, 100);
	float wave2 = map(cos(radians(frameCount)) + sin(radians(frameCount)), -1, 1, 0.75, -0.0005);
	

	float n = noise( 0.01 + frameCount * 0.001);

	translate(0, 0, 0);
	scale(1, 1, 1);
	noStroke();

	_child1.beginDraw();
		_child1.clear();
		_child1.push();
		_child1.noStroke();
		for (int i = 0; i < height; i += 10) {
			float wave3 = map(tan(frameCount * 0.001 * i), -1, 1, -20, 20);
			_child1.translate(_w / 2, _h / 2);
			l = new Line(_child1,wave3, 0 + i);
			l.display();
		}
		_child1.pop();
	_child1.endDraw();
	
	_child2.beginDraw();
		_child2.clear();
		_child2.push();
		img = _child1.get();
		_child2.scale(-0.5, 1);
		_child2.image(img, -_w / 2, 0);
		_child2.pop();
	_child2.endDraw();

	_whichCanvas.beginDraw();
		_whichCanvas.clear();
		_whichCanvas.image(_child1,0,0);
		_whichCanvas.image(_child2,_w / 2,0);
		// scale(1, -1, 1);
		_whichCanvas.push();
		_whichCanvas.scale(-0.5, -0.5);
				_whichCanvas.image(_child1,0,_h / 2);
		
		_whichCanvas.image(_child2,_w / 2,_h / 2);
		_whichCanvas.pop();
	_whichCanvas.endDraw();

	_whichCanvas2.beginDraw();
		_whichCanvas2.clear();
		_whichCanvas2.image(_child1,0,0);
		_whichCanvas2.image(_child2,_w / 2,0);
	_whichCanvas2.endDraw();
	
	if (!letsRenderHD) {
		image(_whichCanvas,0,0);
		scale(-1, 1);
		push();
		image(_whichCanvas,0,_h / 2);
		pop();
	}

	surface.setTitle(
		"FPS = " + (int)frameRate
	);

	if (frameCount == 720 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		// timestamp = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
		saveFrame("../output/sequence-####.png");
	}	
}