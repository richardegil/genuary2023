// SETUP ********************************************************************************************************************
// import hype.*;
// import hype.extended.layout.HGridLayout;
// import hype.extended.behavior.HOscillator;

int    stageW   = 1000;
int    stageH   = 1000;
String pathDATA = "../data/";
String timestamp;

int lastCallTime = 0;
int pauseTime = 1000; // equivalent to 0.1s

// COLORS ********************************************************************************************************************

color white  = #F1F1F1;
color pink   = #FFC0CB;
color cyan   = #00FFFF;
color purple = #590F70;
color orange = #F5610B;
color red    = #FF2E10;
color green  = #7FA140;
color bg     = #111111;
color fg     = white;

color[] colors = {
  pink,
	cyan,
	purple,
	white,
	orange,
	red,
	green
};

// PROJECT ********************************************************************************************************************

int grid   = 100;
int margin = 250;

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
	background(bg);
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

	// hint(DISABLE_TEXTURE_MIPMAPS);
	// ((PGraphicsOpenGL)g).textureSampling(2);
}

void draw() {
	int timeSinceLastCall = millis() - lastCallTime;
	// hint(DISABLE_DEPTH_TEST);

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
	float d = grid * 0.6;

	// translate(_w / 2, _h / 2, 0);

	_child1.beginDraw();
		_child1.clear();
		_child1.background(bg);
		_child1.noFill();
		for (int i = margin; i <= width-margin; i += grid) {
    for (int j = margin; j <= height-margin; j += grid) {

      int colArrayNum = (int)random(7);
      _child1.stroke(colors[colArrayNum]);
      _child1.strokeWeight(3);
      
      for (int num = 0; num < 7; num++) {
        float x1 = -random(d);
        float y1 = -random(d);
        float x2 = random(d);
        float y2 = -random(d);
        float x3 = random(d);
        float y3 = random(d);
        float x4 = -random(d);
        float y4 = random(d);

        _child1.push();
          _child1.translate(i, j);
          _child1.quad(x1, y1, x2, y2, x3, y3, x4, y4);
        _child1.pop();
      }
    }
  }
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

	if (timeSinceLastCall > pauseTime) {
		redraw();
		lastCallTime = millis();
	}

	if (frameCount == 360 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		// timestamp = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
		saveFrame("../output/sequence-####.png");
	}	
}

// void keyPressed() {
//   if (key == ' ') redraw();
// }
