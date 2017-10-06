//setup
int MAX_DOT_DRAWERS = 50;
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
	float pos;
	float vel;
	float acc;
	float dir;
	float rotateSpeed;

	DotDrawer(startingX, startingY) {
		pos = new PVector(startingX, startingY);
		float startingDir = radians(random(0, 360));
		vel = new PVector(0.4 * cos(startingDir), 0.4 * sin(startingDir));
		acc = 0.2;
		dir = radians(random(0, 360));
		rotateSpeed = random(5, 15);
	}

	void update() {
		dir += radians(rotateSpeed);
		vel.x += acc * cos(dir);
		vel.y += acc * sin(dir) + 0.005;
		pos.add(vel);

		stroke(0, 0, 0, 255);
		point(pos.x, pos.y);
	}
}