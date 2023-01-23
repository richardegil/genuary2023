long seed;

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

boolean   letsRender   = true;

// color[] cols = {#0588A6, #F2BB13, #F2786D, #F24444, #79D1A8, #FFFFFF};
// color[] cols = {#FFFFFF};

Agent[] agents;

void setup() {
	size(1000, 1000);
	background(grey);

	agents = new Agent[1000];
	// println("noiseSeed: "+noiseSeed());
	// println("noiseSeed: "+randomSeed());


	seed = 233;
  randomSeed(seed);
	noiseSeed(seed);
  println("Seed value: " + seed);

	for (int i = 0; i < agents.length; ++i) {
		agents[i] = new Agent();
	}
}

void draw() {
	for ( Agent agent : agents ) {
		agent.display();
		agent.update();
	}

	if (frameCount == 360 && letsRender == true) {
		exit();
	}
	if (letsRender == true) {
		// timestamp = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
		saveFrame("../output/sequence-####.png");
	}	
}
