//setup
int MAX_DOT_DRAWERS = 10;
DotDrawers[] dotDrawers;

void setup() {
	size(800, 600, P3D);
	dotDrawers = new DotDrawers[MAX_DOT_DRAWERS];
	reset();
}

//main methods
void reset() {
	background(255);
	for(int i = 0; i < MAX_DOT_DRAWERS; i++) {
		dotDrawers[i] = new DotDrawers(400, 300);
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
class DotDrawers {
	float x;
	float y;
	float dir;
	float moveSpeed;
	float rotateSpeed;

	DotDrawers(startingX, startingY) {
		x = startingX;
		y = startingY;
		dir = radians(random(0.0, 360.0));
		moveSpeed = 2.0;
		rotateSpeed = radians(70.0);
		float r = random(0, 1);
	}

	void update() {
		dir += random(-1, 1) * rotateSpeed;
		x += moveSpeed * cos(dir);
		y += moveSpeed * sin(dir);

		stroke(0, 0, 0, 255);
		point(x, y);
	}
}