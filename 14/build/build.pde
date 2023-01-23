final int xOff = 150;
final int yOff = 150;
final int spacing = 50;
char t;

PFont font;
String density = "░▒▓█▀╿▁▂▃▄▅▆▇█▉▊▙▚▛▜▝▞▟";
String density2 = "   ░▒▓█▀╿▁▂▃▄▅▆▇█▉▊▙▚▛▜▝▞▟";
int densityLen = density.length();


void setup() {
	size(1000, 1000);
	font = createFont("IBMPlexMono-Medm", 16);
	noLoop();
}

void draw() {
	for (int y = yOff; y < height - yOff; y += spacing) {
		for (int x = xOff; x < random(width - xOff); x += spacing) {
			push();
				translate(x, y);
				fill(#FFFFFF);
				textFont(font);
				if (x == 50) {
					t = density2.charAt((int)random(density.length()));	
				} else {
					t = density.charAt((int)random(density.length()));
				}
				text(t, 0, 0);
			pop();
		}			
	}
}
