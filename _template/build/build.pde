int     stageW     = 1000;
int     stageH     = 1000;
color   bg         = #111111;
color   fg         = #F1F1F1;
color   pink       = #FFC0CB;
color   cyan       = #00FFFF;
color   purple     = #590F70;
String  pathDATA   = "../data/";
boolean letsRender = true;
PImage img;
color[] colors = {
  pink,
	cyan,
	purple,
	fg,
	bg
};

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


	if (frameCount == 60 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		saveFrame("../output/sequence-####.png");
	}
}