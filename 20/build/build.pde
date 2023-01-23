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
color bg2 = purple;

color[] cols = {
  pink,
	cyan,
	purple,
	fg,
	bg
};
// PROJECT ********************************************************************************************************************

// final int xOff = 100;
// final int yOff = 100;
// final int spacing = 0;
// char t;
// int charIndex;
// char swap;

// int cols;
// int rows;
// int numAssets;

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
	background(bg);
	surface.setLocation(0,0); // position

	renderCanvas   = createGraphics(stageW,stageH,P3D);
	renderCanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child1Canvas   = createGraphics(stageW,stageH,P3D);
	child1CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);
	child2Canvas   = createGraphics(stageW,stageH,P3D);
	child2CanvasHD = createGraphics(renderCanvasHD_w,renderCanvasHD_h,P3D);


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

	float tilesX = 6;
	float tilesY = 6;

	float tileW = 200;
	float tileH = 200;
	_child1.beginDraw();
	_child1.clear();

	for (int x = 0; x < tilesX; x++) {
		for (int y = 0; y < tilesY; y++) {
			float posX = tileW * x;
			float posY = tileH * y;

			_child1.push();
				_child1.translate(posX, posY);
				_child1.noFill();
				_child1.stroke(bg);
				_child1.noStroke();
				_child1.rotate(radians(45));
				_child1.rect(0, 0, tileW, tileH);
				_child1.strokeWeight(4);
				_child1.stroke(purple);
				_child1.rect(0, 0, tileW - 60, tileH - 60);
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(90));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(45));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(135));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();

				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(-45));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(-135));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();


				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(15));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(105));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(-15));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.rotate(radians(-105));
					_child1.rectMode(CENTER);
					_child1.noStroke();
					_child1.fill(bg2);
					// _child1.rect(0, 0, 20,110);
					_child1.fill(pink);
					_child1.rect(0, 0, 2, 300);
				_child1.pop();
				_child1.push();
					_child1.translate(70 ,70);
					_child1.fill(grey);
					_child1.noStroke();
					_child1.rect(0, 0, 40, 40);
					_child1.noFill();
					_child1.stroke(fg);
					_child1.rect(0, 0, 20, 20);
				_child1.pop();
				// _child1.translate(-40, 10);
				_child1.noFill();
				_child1.stroke(bg);
				_child1.noStroke();
				_child1.rotate(radians(-45));
				_child1.rect(0, 0, tileW, tileH);
				_child1.strokeWeight(4);
				_child1.stroke(purple);
				_child1.rect(0 - 55, 0 + 45, tileW - 90, tileH - 90);
			_child1.pop();
		}
	}			
	_child1.endDraw();

	// _child2.beginDraw();
	// _child2.clear();

	// for (int x = 0; x < tilesX; x++) {
	// 	for (int y = 0; y < tilesY; y++) {
	// 		float posX = tileW * x;
	// 		float posY = tileH * y;

	// 		_child2.push();
	// 			_child2.translate(posX, posY);
	// 			_child2.noFill();
	// 			// _child2.fill(bg);
	// 			_child2.noStroke();
	// 			_child2.rotate(radians(45));
	// 			_child2.rect(0, 0, tileW, tileH);
	// 			_child2.fill(bg2);
	// 			// _child2.noFill();
	// 			_child2.rect(0, 0, tileW - 60, tileH - 60);
	// 			_child2.pop();
	// 	}
	// }			
	// _child2.endDraw();

	// _child1.mask(_child1);

	// _child1.beginDraw();
	// 	_child1.clear();
	

	// 		_child1.translate(0, 0 , 0);
	// 		_child1.rectMode(CENTER);
	// 		_child1.push();

	// 			_child1.rect(0, 0, 100, 100)
	// 		_child1.pop();
			
	// _child1.endDraw();

	_whichCanvas.beginDraw();
		_whichCanvas.clear();
		_whichCanvas.image(_child1,0,0);
		// _whichCanvas.image(_child2,0,0);
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