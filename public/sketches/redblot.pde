//setup
int MAX_PIPE_DRAWERS = 1000;
PipeDrawer[] pipeDrawers;

void setup() {
	size(800, 600, P3D);
	pipeDrawers = new PipeDrawer[MAX_PIPE_DRAWERS];
	reset();
}

//main methods
void reset() {
	background(255);
	for(int i = 0; i < MAX_PIPE_DRAWERS; i++) {
		pipeDrawers[i] = new PipeDrawer(400, 300);
	}
}

void draw() {
	for(int i = 0; i < MAX_PIPE_DRAWERS; i++) {
		pipeDrawers[i].update();
	}
}

void mousePressed() {
	reset();
}

//classes
class PipeDrawer {
	float x;
	float y;
	float dir;
	float movePerFrame;
	float rotatePerFrame;

	PipeDrawer(startingX, startingY) {
		x = startingX;
		y = startingY;
		dir = radians(random(0.0, 360.0));
		movePerFrame = 2.0;
		rotatePerFrame = radians(360.0);
	}

	void update() {
		dir += random(-1, 1) * rotatePerFrame;
		x += movePerFrame * cos(dir);
		y += movePerFrame * sin(dir);

		stroke(255, 0, 0, 255);
		point(x, y);
	}
}