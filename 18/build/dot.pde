class Dot {
  float x, y;
  float r;
  PGraphics p;
  String t;

  Dot(PGraphics p_, float x_, float y_, float r_) {
    x = x_;
    y = y_;
    r = r_;
    p = p_;
  }

  void display() {
    p.beginDraw(); 
    p.stroke(255);
    p.noFill();
    p.translate(x, y);
    p.fill(255);
    p.noStroke();
    p.ellipse(x, y, r*2, r*2);
    p.endDraw(); 
  }

  void update() {
    p.scale(map(sin(frameCount * 0.05), -1, 1, 0, 1));
    println("var: "+map(sin(frameCount * 0.05), -1, 1, 0, 1));
  }
}