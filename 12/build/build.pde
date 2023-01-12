// SETUP ********************************************************************************************************************
import hype.*;
import hype.extended.layout.HHexLayout;
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
color 	grey     	 = #5A5F79;

color[] colors = {
  pink,
	cyan,
	purple,
	fg,
	bg
};

int     colorsLen     = colors.length;

// PROJECT ********************************************************************************************************************



// THIS IS THE LAYOUT STUFFS
PVector[]pos; // store the x,y positions
PVector[]data1;

// int[]rotations = {180, 90}; 
int numAssets  = 550;
int hexSpacing = 60;
int hexOffsetX = stageW/2;  // hex starts in center - this number subtracts from center
int hexOffsetY = stageH/2;

HHexLayout layout;

HOscillator[] r1Z = new HOscillator[numAssets];


// IMAGES  ********************************************************************************************************************

PImage img;

String[] svgs       = { 
	// "h1.svg",
	// "h2.svg",
	// "h3.svg",
	"h4.svg",
	// "h5.svg",
	// "h7.svg"
};

int      svgLen     = svgs.length;
PShape[] s          = new PShape[svgLen];

boolean  savePDF    = false;
// String   renderPATH = "../renders_001/";
int      renderNum  = 1;


// SHADER ******************************************************************

PShader shader;

// UTILITIES ********************************************************************************************************************

boolean   letsRender   = true;
boolean   letsRenderHD = false;

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
	surface.setSize(stageW, stageH); // in conjunction with fullScreen / w, h
	surface.setLocation(100, 100); // position

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);

	for (int i = 0; i < svgLen; ++i) {
		s[i] = loadShape( pathDATA + svgs[i]);
		s[i].disableStyle();
	}

	layout = new HHexLayout()
		.spacing(hexSpacing)
		.offsetX(hexOffsetX)
		.offsetY(hexOffsetY)
	;

	pos    = new PVector[numAssets];
	data1  = new PVector[numAssets];

		for (int i = 0; i < numAssets; ++i) {
		pos[i] = layout.getNextPoint();
		data1[i] = new PVector();
		data1[i].x = (int)random(svgLen); // randomly pick an SVG from our list
		// data1[i].y = 1 + ( (int)random(3)*0.5 ); // scale
		data1[i].y = 1; // scale
		// data1[i].z = 60 + ( (int)random(3)*60 ); // not used
		// data1[i].z = 0; // not used
		data1[i].z = (int)random(colorsLen);
		r1Z[i] = new HOscillator().range(1, 0.65).speed(12).freq(2).currentStep( i * 3 ).waveform(H.SINE);

	}

	// randomize(pos);

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
	float wave3 = map(sin(radians(frameCount)), -1, 1, 0.75, 1);

	float n = noise( 0.01 + frameCount * 0.001);

	background(bg);
	noStroke();

	

	_child1.beginDraw();
		_child1.clear();
		_child1.push();
		_child1.translate(_w / 2, _h / 2, 0);
			for (int i = 0; i < numAssets; ++i) {
				HOscillator _z = r1Z[i]; 
				_z.nextRaw();
				PVector p  = pos[i];
				PVector d1 = data1[i];
				_child1.strokeJoin(ROUND);
				_child1.strokeCap(ROUND);
				_child1.strokeWeight(4.0/d1.y);
				_child1.stroke(colors[int(d1.z)]);
				_child1.fill(grey);
				_child1.push();
					// _child1.scale(wave3 * (int)random(1, 3));
					_child1.translate(p.x, p.y);
					_child1.scale(_z.curr());
					_child1.rotateZ((map(sin(radians(frameCount)), -1, 1, -1, 1)));
					_child1.shape(s[ (int)d1.x ], 0, 0);
				_child1.pop();
			}			
		_child1.pop();
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