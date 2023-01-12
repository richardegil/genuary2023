function Bubble(x, y, type) {
  this.x = x;
  this.y = y;
  this.r = 48;
  this.col = color(89, 15, 112);
  this.type = type;

  this.speeds = [
    0.0125, 
    0.025,
    0.05,
    0.075
  ];

  this.randomSpeed = int(random(4));

  this.display = function() {
    noStroke();
    fill(this.col, 100);
    ellipse(this.x, this.y, this.r * 2, this.r * 2);
  }

  this.update = function() {
    if (this.type) {
      this.y = this.y;
      this.x = map(sin(frameCount * this.speeds[this.randomSpeed] * 0.5), -1, 1, 0, width);
    } else {
      this.x = this.x;
      this.y = map(sin(frameCount * this.speeds[this.randomSpeed]), -1, 1, 0, height);
    }
  }

  this.changeColor = function() {
    this.col = color(0, 255, 255);
  }

  this.resetColor = function() {
    this.col = color(89, 15, 112);
  }

  this.intersects = function(other) {
    var d = dist(this.x, this.y, other.x, other.y);
    if (d < this.r + other.r) {
      this.changeColor();
      return true;
    } else {
      this.resetColor();
      other.resetColor();
      return false;
    }
  }
}