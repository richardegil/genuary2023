// SETUP ********************************************************************************************************************
import hype.*;
import hype.extended.layout.HGridLayout;
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

PVector[]pos; // store the x,y positions
PVector[]data1;

// int[]rotations = {180, 90}; 
int gridCols   = 40; // how many columns
int gridRows   = 40; // how many rows
int gridTotal  = gridCols * gridRows;
int gridStartX = -((stageW/2)); // where to start grid on x axis
int gridStartY = -((stageH/2)); // where to start grid on y axis
int gridSpaceX = 50; // spacing between cells on x
int gridSpaceY = 50; // spacing between cells on y

HGridLayout layout;

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
	H.init(this);
	background(bg);
	surface.setLocation(0,0); // position

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	layout = new HGridLayout().startX(gridStartX).startY(gridStartY).spacing(gridSpaceX, gridSpaceY).cols(gridCols);
	pos    = new PVector[gridTotal];

	for (int i = 0; i < gridTotal; ++i) {
		pos[i] = layout.getNextPoint();
	}

	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position

	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(2);
}

void draw() {
	background(fg);
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

	noStroke();

	translate(0, 0, 0);

	_child1.beginDraw();
		_child1.clear();
		_child1.background(grey);
		_child1.ambientLight(230, 230, 230);
			_child1.directionalLight(255, 192, 203, 0, 4, -5);
			_child1.directionalLight(255, 192, 203, 0, -4, 3);
			// _child1.directionalLight(0, 255, 255, 0, -4, -5);
			// _child1.directionalLight(0, 255, 255, 0, -3, 4);

			for (int i = 0; i < gridTotal; ++i) {
				PVector p  = pos[i];
				_child1.push();
					_child1.translate(p.x, p.y);
					_child1.fill(purple);
					// _child1.text(i, 0, 0, 0);
					_child1.push();
						
						_child1.translate(p.x + 50, p.y + 50);
						// _child1.rotate(PI/4);
						_child1.fill(pink);
						_child1.noStroke();
						if (i % 2 == 0) {
							_child1.rotateY(lerp(0, PI / 4, 1) * frameCount * 0.00005 * i);
						} else {
							_child1.rotateX(lerp(0, PI / 4, 1) * frameCount * 0.00005 * i);
						}
						_child1.rect(0, 0, 100, 100);
					_child1.pop();
					_child1.stroke(0, 255, 255, 10);
					_child1.line(p.x + 50, 0, p.x + 50, p.y + 100);
					_child1.line(0, p.y + 50, p.x + 100, p.y + 50);
					// rotate(radians(d1.z));
					// scale(d1.y);
					// shape(s[ (int)d1.x ], 0, 0);
				_child1.pop();
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

	if (frameCount == 720 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		// timestamp = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
		saveFrame("../output/sequence-####.png");
	}	
}