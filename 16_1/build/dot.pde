class Line {
  float x, y;
  float r;
  PGraphics p;
  String t;

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
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
    pink,
	cyan,
	purple,
};


int numberOfBlocks = 10;
color[]sel = new color[numberOfBlocks];


  Line(PGraphics p_, float x_, float y_) {
    x = x_;
    y = y_;
    p = p_;

    for (int i = 0; i < numberOfBlocks; ++i) {
      sel[i] = colors[(int)random(colors.length )];
	  }
 
  }

  void display() {
    p.translate(x, y);
    p.beginDraw(); 
    // p.noStroke();
    // p.stroke(255);
    for (int i = 0; i < numberOfBlocks; ++i) {
      p.pop();
      // p.noStroke();
      p.fill(colors[i]);
      p.rect(x + width / numberOfBlocks * i, y, width / numberOfBlocks, 10);
      p.push();
    }
    p.endDraw(); 
  }

  // boolean overlaps(Dot other) {
  //   float d = dist(x, y, other.x, other.y);
  //   if (d < r + other.r) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}