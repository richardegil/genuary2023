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

color[] colors = {
  pink,
	cyan,
	purple,
	fg,
	bg
};

// PROJECT ********************************************************************************************************************

float boxSize = 300;

// IMAGES  ********************************************************************************************************************

PImage img;
PImage imgV;

// SHADER ******************************************************************

PShader shader;
PShader shaderRGB;
PShader shader2RGB;

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
	surface.setLocation(0,0); // position

	img = loadImage(pathDATA + "images/noise.jpg");
	imgV = loadImage(pathDATA + "images/noise-vertical.jpg");

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	shader = loadShader(pathDATA + "shaders/fragment.glsl");
	shader.set("u_resolution", 1000.0, 1000.0);

	shaderRGB = loadShader(pathDATA + "shaders/frag2.glsl");
	shaderRGB.set("u_resolution", 1000.0, 1000.0);

	shader2RGB = loadShader(pathDATA + "shaders/frag2.glsl");
	shader2RGB.set("u_resolution", 1000.0, 1000.0);

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
		_child1.noStroke();
		_child1.push();
			_child1.translate(_w / 2, _h / 2);
			_child1.ambientLight(230, 230, 230);
			_child1.directionalLight(255, 192, 203, 0, 4, -5);
			_child1.directionalLight(255, 192, 203, 0, 3, -4);
			_child1.directionalLight(0, 255, 255, 0, -4, 5);
			_child1.directionalLight(0, 255, 255, 0, -3, 4);
			_child1.rotateX(frameCount * 0.01);
			_child1.rotateY(frameCount * 0.01);
			_child1.box(boxSize);
			_child1.rotateX(frameCount * -0.01);
			_child1.rotateY(frameCount * -0.01);
			_child1.box(boxSize);
		_child1.pop();
	_child1.endDraw();


	// shader.set("time", map( sin(frameCount*0.05), -1.0, 1.0, 0.0, 1.0) );
	// shader.set("progress", map(mouseX, 0, stageW,0.0, 1.0));
	
	shader.set("imageBase", _child1);
	shaderRGB.set("image", _child1);
	shaderRGB.set("progress", wave);
	shaderRGB.set("displacement", img);

	shader2RGB.set("image", _child1);
		// shader2RGB.set("progress", noise(wave));
	// shader2RGB.set("progress", noise(wave * n));
// shader2RGB.set("progress", n);
// shader2RGB.set("progress", map( sin(frameCount*0.021), -1.0, 1.0, 0.0, 1.0));
	shader2RGB.set("progress", map( sin(frameCount*0.016) / cos(frameCount*0.016), -1.0, 1.0, 0.0, 0.2));
	shader2RGB.set("displacement", img);

	// _child1.filter(shaderRGB);
	_child1.filter(shader2RGB);
	_child1.filter(shader);

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
