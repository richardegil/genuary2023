class Agent {
  float x, y, z;
  float speed, size;
  color col;

  // big arcs
  // 679
	// 175
  // float noiseScale = 3000, noiseStrength = 10;
  // 81
  // 893
  // 233
  float noiseScale = 4000, noiseStrength = 20;


  Agent() {
    x = random(width);
    y = random(height);
    // x = width / 2;
    // y = height / 2;
    // size = random(0.5, 2);
    size = 1;
    speed = random(-3, 3);
    // z = random(0.1, 0.4);

    col = cols[(int)random(cols.length)];
  }

  void display() {
    strokeWeight(size);
    stroke(col, 50);
    point(x, y);
  }

  void update() {
    float angle = noise( x / noiseScale, y / noiseScale) * noiseStrength;
    x += cos(angle) * speed;
    y += sin(angle) * speed;

    // z += 0.001;
  }
}