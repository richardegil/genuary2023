// SETUP ********************************************************************************************************************

import hype.*;
import hype.extended.layout.HHexLayout;

import processing.pdf.*;

int    stageW   = 1000;
int    stageH   = 1000;
String pathDATA = "../data/";
String timestamp;
int timer;

int lastCallTime = 0;
int pauseTime = 1000; // equivalent to 0.1s

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
	// bg
};

int     colorsLen     = colors.length;

// IMAGES  ********************************************************************************************************************

String[] svgs       = { 
	// "h1.svg",
	"h2.svg",
	// "h3.svg",
	// "h4.svg",
	// "h5.svg",
	// "h7.svg"
};

int      svgLen     = svgs.length;
PShape[] s          = new PShape[svgLen];

boolean  savePDF    = false;
// String   renderPATH = "../renders_001/";
int      renderNum  = 1;

// ********************************************************************************************************************

// THIS IS THE LAYOUT STUFFS
PVector[]pos; // store the x,y positions
PVector[]data1;

// int[]rotations = {180, 90}; 
int numAssets  = 550;
int hexSpacing = 50;
int hexOffsetX = stageW/2; // hex starts in center - this number subtracts from center
int hexOffsetY = stageH/2;

HHexLayout layout;

// ********************************************************************************************************************

// UTILITIES ********************************************************************************************************************

boolean   letsRender   = true;
boolean   letsRenderHD = false;

// int       renderNum    = 0;
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

void settings() {
	size(stageW,stageH,P2D);
}

void setup() {
	H.init(this);
	background(bg);
	surface.setLocation(0,0); // position

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
	}

	randomize(pos);

	hint(DISABLE_TEXTURE_MIPMAPS);
	((PGraphicsOpenGL)g).textureSampling(2);
}

void draw() {
	// frameRate(1);
	int timeSinceLastCall = millis() - lastCallTime;
	timestamp = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
	if(savePDF) beginRecord(PDF, renderPATH + "vectors_" + timestamp + ".pdf");
	background(bg);

	pushMatrix();
		translate(stageW/2, stageH/2);

		for (int i = 0; i < numAssets; ++i) {
			PVector p  = pos[i];
			PVector d1 = data1[i];

			strokeJoin(ROUND);
			strokeCap(ROUND);
			strokeWeight(2.0/d1.y);
			// stroke(#ffffff);
			// stroke(#00ffff);
			// stroke(#FFC0CB);
			println("d1.z: "+d1.z);
			stroke(colors[int(d1.z)]);
			
				  
			// if (timeSinceLastCall > pauseTime) {
			// 	// The last call is now
				 
			// 	lastCallTime = millis();
			// }
			fill(#000000);

			pushMatrix();
				translate(p.x, p.y);
				// rotate(radians(d1.z));
				// scale();
				shape(s[ (int)d1.x ], 0, 0);
			popMatrix();
		}
	popMatrix();

	if(savePDF) {
		endRecord();
		// renderNum++;
		savePDF = false;
	}
	
	surface.setTitle(
		"FPS = " + (int)frameRate
	);

	// if (millis() - timer >= 2000) {
	// 	randomize(pos);    
	// 	timer = millis();
  // }

	if (timeSinceLastCall > pauseTime) {
		randomize(pos);   
    // The last call is now
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

// ********************************************************************************************************************

// KEY PRESS ACTIONS

void keyPressed() {
	switch (key) {
		case 'p': savePDF = true; break;
		case 'r': randomize(pos); break;
		case 'a': swapArt(); break;
	}
}

// ********************************************************************************************************************

// SHUFFLES THE ORDER OF THE ARRAY OF VECTORS

void randomize(PVector[] arrMy) {
	for (int k=0; k < arrMy.length; k++) {
		int x = (int)random(0, arrMy.length);    
		arrMy = swapValues(arrMy, k, x);
	}
}

PVector[] swapValues(PVector[] myArray, int a, int b) {
	PVector temp=myArray[a];
	myArray[a]=myArray[b];
	myArray[b]=temp;
	return myArray;
}

// ********************************************************************************************************************

void swapArt() {
	for (int i = 0; i < numAssets; ++i) {
		data1[i].x = (int)random(svgLen); // randomly pick an SVG from our list
	}
}

// ********************************************************************************************************************
