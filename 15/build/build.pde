// SETUP ********************************************************************************************************************
import hype.*;
import hype.extended.layout.HGridLayout;
import hype.extended.behavior.HOscillator;

int     stageW     = 1000;
int     stageH     = 1000;
String  pathDATA   = "../data/";
String timestamp;

long seed;

// PROJECT ********************************************************************************************************************
int numberOfDiscs = 5;
int discDiamter = 300;

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
	pink,
	cyan,
	purple,
	pink,
	cyan,
	purple,
	pink,
	cyan,
	purple,
};

PVector[]selectedColors;
color[]sel = new color[numberOfDiscs];

PVector[]grid; // storing x,y positions
int gridCols   = 100; // how many columns
int gridRows   = 100; // how many rows
int gridDepth  = 20;
int numAssets  = gridCols *  gridRows * gridDepth;

int gridSpacingX = 20; // spacing between cells on x
int gridSpacingY = 20; // spacing between cells on y 
int gridSpacingZ = 10;

int gridStartX = -((gridCols - 1) * (gridSpacingX / 2));
int gridStartY = -((gridRows - 1) * (gridSpacingY / 2));
int gridStartZ = -((gridDepth - 1) * (gridSpacingZ / 2));

HGridLayout layout;

float r     = 0;

HOscillator[]   osc           = new HOscillator[numAssets];


// IMAGES  ********************************************************************************************************************

PImage img;

// SHADER ******************************************************************

// PShader shader;

// UTILITIES ********************************************************************************************************************

boolean   letsRender   = true;
boolean   letsRenderHD = false;

int       renderNum    = 1;
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
	H.init(this).use3D(true);
	background(grey);
	surface.setLocation(0,0); // position

	seed = (long)random(1000);
	randomSeed(seed);
	println("Seed value: " + seed);

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position
	selectedColors  = new PVector[numberOfDiscs];

	layout = new HGridLayout()
		.startLoc(gridStartX, gridStartY, gridStartZ)
		.spacing(gridSpacingX, gridSpacingY, gridSpacingZ)
		.cols(gridCols)
		.rows(gridRows);
	
	grid = new PVector[numAssets];

	for (int i = 0; i < numAssets; ++i) {
		grid[i] = layout.getNextPoint();
		osc[i] = new HOscillator().range(-100, 100).speed(2).freq(3).currentStep( i * -3 ).waveform(H.SINE);
	}

	for (int i = 0; i < numberOfDiscs; ++i) {
		// println("i: "+i);
		if (i != 0) {
			color prev = sel[i - 1];
			color next = colors[(int)random(colors.length)];

			if (next != prev) {
				sel[i] = next;
			} else {
				sel[i] = #ffffff;
			}
			
		} else {
			sel[i] = colors[(int)random(colors.length )];
		}
	}

	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(2);
}

void draw() {
	background(grey);
	// noLoop();
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


	noStroke();

	translate(0, 0, 0);

	_child1.beginDraw();
	_child1.background(grey);
		_child1.clear();
		for (int i = 0; i < numberOfDiscs; ++i) {
		_child1.push();
			_child1.translate(_w / 2, _h / 2, i * -1);
			color col = sel[i];
			_child1.fill(col);
			_child1.noStroke();
			// float wave3 = map(sin(radians( frameCount * (numberOfDiscs - i))), -1, 1, 0.5, 1);
			// _child1.scale(wave3);
			_child1.ellipse(0, 0, discDiamter * i, discDiamter * i);
		_child1.pop();
		}
			
	_child1.endDraw();

	
translate(0, 0, 0);
	_child2.beginDraw();
		_child2.clear();
		img = _child1.get();
		for (int i = 0; i < numAssets; ++i) {
			PVector p = grid[i];
			HOscillator _z = osc[i]; 
			_z.nextRaw();
			_child2.noStroke();
			_child2.push();
				_child2.translate(p.x, p.y, _z.curr());
				color c = img.get((int)p.x, (int)p.y);
				if (c == 0) {
					_child1.fill(#FFFFFF);
				} else {
					_child2.fill(c);
				}
				_child2.ellipse(0, 0, 10, 10);
			_child2.pop();
		}
	_child2.endDraw();

	_whichCanvas.beginDraw();
		_whichCanvas.clear();
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