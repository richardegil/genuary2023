int    stageW   = 1000;
int    stageH   = 1000;
color  bg       = #111111;
color  fg       = #f1f1f1;
color  pink     = #FFC0CB;
color  cyan     = #00FFFF;
String pathDATA = "../../data/";
boolean letsRender = true;
// ********************************************************************************************************************

void settings() {
	size(stageW,stageH,P3D);
	// smooth(4);
}

void setup() {
	background(bg);
	rectMode(CENTER);
}

void draw() {
	background(bg);
	fill(fg);
	noStroke();

	float amount = 100;
	float w = width / amount;
	float h = height / amount;
	float mag = height*0.3;

	translate(w / 2, 0);
	for (int i = 0; i < amount; ++i) {
		float wave = map(tan(radians(frameCount*0.5 + i*10)), -1, 1, -mag/2, mag/2);
		push();
			fill(#00FFFF);
			translate(i * w, height / 2 + wave);
			ellipse(0, 0, w, w);
		pop();
	}

	translate(0, h / 2);
	for (int i = 0; i < amount; ++i) {
		float wave = map(tan(radians(frameCount*0.5 + i*10)), -1, 1, -mag/2, mag/2);
		push();
			fill(#FFC0CB);
			translate(width / 2 + wave, i * h);
			ellipse(0, 0, w, w);
		pop();
	}

	translate(w / 2, 0);
	for (int i = 0; i < amount; ++i) {
		float wave = map(tan(radians(frameCount*0.5 + i*10)), -1, 1, mag/2, -mag/2);
		push();
			fill(#00FFFF);
			translate(i * w, height / 2 + wave);
			ellipse(0, 0, w, w);
		pop();
	}

	translate(0, h / 2);
	for (int i = 0; i < amount; ++i) {
		float wave = map(tan(radians(frameCount*0.5 + i*10)), -1, 1, mag/2, -mag/2);
		push();
			fill(#FFC0CB);
			translate(width / 2 + wave, i * h);
			ellipse(0, 0, w, w);
		pop();
	}

	if (frameCount == 720 && letsRender == true) {
		exit();
	}

	if (letsRender == true) {
		saveFrame("../output/sequence-####.png");
	}

}	