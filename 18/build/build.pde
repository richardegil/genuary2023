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

color[] cols = {
  pink,
	cyan,
	purple,
	fg,
	bg
};
// PROJECT ********************************************************************************************************************
Dot[] dots;
float size  = 20;
float zoom  = 0.1;
float speed = 0.001;
// float tempX = random(1, width);
// float tempY = random(1, height);

PVector[]pos;
int numberOfDots = 5;
// IMAGES  ********************************************************************************************************************

PImage img;

// SHADER ******************************************************************

PShader shader;

// UTILITIES ********************************************************************************************************************

boolean   letsRender   = false;
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
	surface.setLocation(0,0); // position
	// noiseSeed(083182);

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	PGraphics _child2;
	_child2      = child2Canvas;
	pos = new PVector[numberOfDots];
	dots = new Dot[numberOfDots];
	for (int i = 0; i < numberOfDots; ++i) {
		pos[i] = new PVector();
		pos[i].x = (int)random(1, width);
		pos[i].y = (int)random(1, height);
		dots[i] = new Dot(_child2, 100 * i, 100 * i, 50);
		// _child2, 0, 0, 50
	}

	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position

	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(2);
}

void draw() {
	background(grey);
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
	
	noFill();
	translate(0, 0);
	float x1 = noise(frameCount *  0.008) * width;
  float y1 = noise(100 + frameCount *  0.008) * height;

	_child1.beginDraw();
		_child1.clear();
		_child1.push();
		_child1.strokeWeight(2);
		_child1.stroke(pink);
		_child1.noFill();
		_child1.translate(_w / 2, 0);
		_child1.beginShape();
    for(int y = 0; y < height; y++) {      
      float n = noise(y * zoom + frameCount * speed * random(2) * wave);
      float x = map(n, -1, 1, -size, size);
      _child1.vertex(x, y);
    }  
		_child1.endShape();
		_child1.pop();
	_child1.endDraw();


	_child2.beginDraw();
		_child2.clear();
		_child2.translate(0, 0);
		float diff = random(0.1 , 1);		
		for (Dot dot : dots) {
			dot.display();
			dot.update();
		}
	_child2.endDraw();

	_whichCanvas.beginDraw();
		_whichCanvas.clear();
		_whichCanvas.image(_child1,0,0);
		_whichCanvas.image(_child2,0,0);
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