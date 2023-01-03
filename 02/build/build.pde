int    stageW   = 1000;
int    stageH   = 1000;
color  bg       = #111111;
color  fg       = #f1f1f1;
color  pink     = #FFC0CB;
color  cyan     = #00FFFF;
color purple = #590F70;
String pathDATA = "../data/";
boolean letsRender = true;

PImage img;

color[] colors = {            //random selects one of above colors
  pink,
	cyan,
	purple,
	pink,
	cyan,
	purple,
	pink,
	cyan,
	purple,
	purple,
	purple,
	fg,
	bg
};

PVector[]pos;



// ********************************************************************************************************************

void settings() {
	size(stageW,stageH,P3D);
}

void setup() {
	background(bg);
}

void draw() {
	background(bg);
	noStroke();
	frameRate(15);
	// noLoop();

	float tilesX = 100;
	float tilesY = 100;
	float gridSize = 10;

	float amount = 100;

	float tileW = width / tilesX;
	float tileH = height / tilesY;

	float mag = height*0.3;
	
	translate(0,0);
	

	for (int y = 0; y < stageH; y++) {
			for (int x = 0; x < stageW; x++) {
					color c1 = (colors[int(random(0,colors.length))]);
					float n = noise(x * 0.001 + frameCount * 2);
					
					fill(c1);
					noStroke();
					rect(x * gridSize, y * gridSize, gridSize * n, gridSize * n);
			}
	}

	if (frameCount == 60 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		saveFrame("../output/sequence-####.png");
	}
}