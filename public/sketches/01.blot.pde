//setup
int MAX_DOT_DRAWERS = 1000;
DotDrawer[] dotDrawers;

void setup() {
	size(450, 450, P3D);
	dotDrawers = new DotDrawer[MAX_DOT_DRAWERS];
	reset();
}

//main methods
void reset() {
	background(255);
	for(int i = 0; i < MAX_DOT_DRAWERS; i++) {
		dotDrawers[i] = new DotDrawer(225, 225);
	}
}

void draw() {
	for(int i = 0; i < MAX_DOT_DRAWERS; i++) {
		dotDrawers[i].update();
	}
}

void mousePressed() {
	reset();
}

//classes
class DotDrawer {
	float x;
	float y;
	float dir;
	float moveSpeed;
	float rotateSpeed;

	DotDrawer(startingX, startingY) {
		x = startingX;
		y = startingY;
		dir = radians(random(0.0, 360.0));
		moveSpeed = 2.0;
		rotateSpeed = radians(360.0);
	}

	void update() {
		dir += random(-1, 1) * rotateSpeed;
		x += moveSpeed * cos(dir);
		y += moveSpeed * sin(dir);

		stroke(0, 0, 0, 255);
		point(x, y);
	}
}