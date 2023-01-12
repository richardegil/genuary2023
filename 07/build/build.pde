// SETUP ********************************************************************************************************************
import hype.*;
import hype.extended.layout.HGridLayout;
import hype.extended.behavior.HOscillator;

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

color[] colors = {
  pink,
	cyan,
	purple,
	fg,
	bg
};

// PROJECT ********************************************************************************************************************
String[] svgs       = { 
	// "h2.svg",
	// "h7.svg"
	"shape_r_4.svg",
	"shape_r_5.svg"
};

PVector[]grid; // storing x,y positions

PVector[]data1; // store some numbers for stuff

int[]sourceColor;

int cellSize = 100;

int gridCols   = 10; // how many columns
int gridRows   = 10; // how many rows
int gridTotal  = gridCols *  gridRows;
int gridStartX = 50; // where to start grid on x axis
int gridStartY = 50; // where to start grid on y axis
int gridSpaceX = 100; // spacing between cells on x
int gridSpaceY = 100; // spacing between cells on y 

HGridLayout layout;

// IMAGES  ********************************************************************************************************************

PImage img;

int      svgLen     = svgs.length;
PShape[] s          = new PShape[svgLen];

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

	img = loadImage(pathDATA + "fragile.jpg");
	for (int i = 0; i < svgLen; ++i) {
		s[i] = loadShape( pathDATA + svgs[i]);
		s[i].disableStyle();
	}

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	layout = new HGridLayout().startX(gridStartX).startY(gridStartY).spacing(gridSpaceX, gridSpaceY).cols(gridCols);
	grid = new PVector[gridTotal];
	data1 = new PVector[gridTotal];

	for (int i = 0; i < gridTotal; ++i) {
		grid[i] = layout.getNextPoint();
		// PVector temp1 = new PVector();
		// temp1.x = (int)random(3) * 90;// this is our rotation
		// temp1.y = 50 + ((int)random(3) * 50);// scale 50, 100, 150
		data1[i] = new PVector();
		data1[i].x = 1 + ( (int)random(3)*0.5 ); // scale the artwork
		data1[i].y = 0; // not used
		data1[i].z = (int)random(svgLen);
		
	}

	// println("sourceColor: "+sourceColor);

	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position

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

	background(bg);
	noStroke();

	// translate(_w / 2, _h / 2, 0);

	_child1.beginDraw();
		_child1.clear();
		_child1.image(img, 0, 0);
		_child1.tint(0, 0, 0, 0);
		_child1.background(bg);
			for (int i = 0; i < gridTotal; ++i) {
				PVector p = grid[i];
				PVector d1 = data1[i];
				color c = img.get((int)p.x, (int)p.y);
				_child1.push();
				_child1.noFill();
					_child1.stroke(c);
					_child1.translate(p.x, p.y, 0);
					// _child1.rotate(d1.y);
					_child1.scale(d1.x);
					_child1.shape(s[ (int)d1.z ], 0, 0);
					// _child1.rect(0 + wave2, 0, cellSize, cellSize);
				_child1.pop();
			}
	_child1.endDraw();

	_whichCanvas.beginDraw();
		_whichCanvas.clear();
		_whichCanvas.image(_child1,0,0);
	_whichCanvas.endDraw();
	

	background(bg);

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