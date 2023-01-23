int    stageW   = 1000;
int    stageH   = 1000;
color  bg       = #111111;
color  fg       = #f1f1f1;
color  pink     = #FFC0CB;
color  cyan     = #00FFFF;
color 	grey     	 = #5A5F79;
color purple = #590F70;
String pathDATA = "../data/";
boolean letsRender = true;

PImage img;

color[] colors = {            //random selects one of above colors
  // pink,
	// cyan,
	purple,
	grey,
	bg
};

PVector[]pos;



// ********************************************************************************************************************

void settings() {
	size(stageW,stageH,P3D);
	smooth(4);
}

void setup() {
	background(bg);
}

void draw() {
	background(bg);
	noStroke();
	frameRate(30);
	// noLoop();

	float tilesX = 100;
	float tilesY = 100;
	float gridSize = 5;

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
					rect(x * gridSize, y * gridSize, gridSize, gridSize);
			}
	}

	push();
		colorMode(HSB,360, 100, 100);
		rectMode(CENTER);
		translate(width / 2, height / 2);
		noFill();
		strokeWeight(40);
		stroke(180, 100, 100);
		rect(0, 0, width, height);
		
		for (int i = 0; i < 5; ++i) {
			strokeWeight(5);
			strokeCap(PROJECT);
			stroke(180, 100, 100 - (i * 10));
			rect(0, 0, width - (10 * i), height - (10 * i));
		}
		stroke(180, 100, 100);
		rect(0, 0, width - 100, height - 100);
	pop();
	
	push();
	ellipseMode(CENTER);
	// float w2 = map(sin(frameCount* 0.25), -1, 1, 0, 90);
	translate(width / 2, height / 2);
	noFill();
	strokeWeight(4);
	for (int i = 0; i < 4; ++i) {
		push();
		// translate(0, 50);
		stroke(pink);
		float w = map(sin(frameCount* 0.05), -1, 1, 0, 50);
		rotate(radians(90 * i));
		ellipse(0, w, 200, 200);
		pop();
	}
	pop();
	


	if (frameCount == 360 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		saveFrame("../output/sequence-####.png");
	}
}