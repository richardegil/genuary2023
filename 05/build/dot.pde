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
    p.rect(x - r - 5, y - r - 5, r * 2 + 10, r * 2 + 10);

    p.fill(255);
    p.noStroke();
    
    p.ellipse(x, y, r*2, r*2);
    p.translate(x, y);
    t = "[x: " + (int)x + ", " + "y: " + (int)y + "]";
    p.text(t, r, r / -2);
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