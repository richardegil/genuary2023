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
float[] rings = {
	random(1, 5),
	random(1, 5),
	random(1, 5),
	random(1, 5)
};

float space = 30;
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
	smooth(4);
}

void setup() {
	background(fg);
	surface.setLocation(0,0); // position

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	shader = loadShader(pathDATA + "shaders/fragment.glsl");
	shader.set("u_resolution", 1000.0, 1000.0);

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

	translate(_w / 2, _h / 2, 0);

	_child1.beginDraw();
		_child1.clear();

		_child1.strokeWeight(2);
		_child1.stroke(cyan);
		_child1.line(0, _h / 2, _w, _h / 2);
		_child1.line(_w / 2, 0, _w / 2, _h);
		float tilesX = 2;
		float tilesY = tilesX;

		float tileW = _w / tilesX;
		float tileH = _h / tilesY;

		for (int x = 0; x < tilesX; ++x) {
			for (int y = 0; y < tilesY; ++y) {
				float posX = tileW * x;
				float posY = tileH * y;
				_child1.push();
					_child1.translate(posX, posY);
					_child1.noFill();
					_child1.stroke(bg);
					if (x == 0 && y == 0) {
						buildArcs(0, posX, posY, 0 , 0, tileW, tileH, 180, 270);
						// _child1.arc(tileW , tileH, tileW + 20, tileH + 20, radians(180), radians(270));
					} else if ( x == 1 && y == 0) {
						buildArcs(1, posX, posY, 0, 0, tileW, tileH, 270, 360);
						// _child1.arc(0, tileH, tileW, tileH, radians(270), radians(360));
					}	else if ( x == 0 && y == 1) {
						buildArcs(2, posX, posY, 0, 0, tileW, tileH, 90, 180);
						// _child1.arc(tileW, 0, tileW, tileH, radians(90), radians(180));
					} else {
						buildArcs(3, posX, posY, 0 , 0 , tileW, tileH, 0, 90);

					}
				_child1.pop();	
				
			}
		}		
	_child1.endDraw();

	// shader.set("imageBase", _child1);
	// _child1.filter(shader);

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

void buildArcs(int numOfRings, float posX, float posY, float x1, float y1, float x2, float y2, float start, float finish) {
	noFill();
	stroke(bg);
	strokeWeight(map(sin(frameCount * 0.005 * numOfRings), -1, 1, 2, 10));
	strokeCap(ROUND);
		// translate(posX, posY);
	for (int i = 0; i < rings[numOfRings]; ++i) {
		arc(x1 , y1, x2 + (i * space), y2 + (i * space), radians(start), radians(map(sin(frameCount * 0.005 * i), -1, 1, start, finish)));
	}
}