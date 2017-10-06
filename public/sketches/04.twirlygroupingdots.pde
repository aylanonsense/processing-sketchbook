//setup
int MAX_DOT_DRAWERS = 500;
int WIDTH = 450;
int HEIGHT = 450;
DotDrawer[] dotDrawers;

void setup() {
	size(WIDTH, HEIGHT);
	dotDrawers = new DotDrawer[MAX_DOT_DRAWERS];
	reset();
}

//main methods
void reset() {
	background(255);
	for(int i = 0; i < MAX_DOT_DRAWERS; i++) {
		dotDrawers[i] = new DotDrawer();
	}
}

void draw() {
	noStroke();
    fill(255, 255, 255, 70);
    rect(0, 0, WIDTH, HEIGHT);

	for(int i = 0; i < MAX_DOT_DRAWERS; i++) {
		for(int j = i + 1; j < MAX_DOT_DRAWERS; j++) {
			dotDrawers[i].reactTo(dotDrawers[j]);
			dotDrawers[j].reactTo(dotDrawers[i]);
		}
	}
	for(int i = 0; i < MAX_DOT_DRAWERS; i++) {
		dotDrawers[i].update();
	}
}

void mousePressed() {
	reset();
}

//classes
float MIN_MOVE_SPEED = 0.25;
float MAX_MOVE_SPEED = 1.75;
float MAX_ROTATE_SPEED = 75.0;
float IDEAL_DIST = 1;
float FACE_SAME_DIR_STRENGTH = 10;
float BE_AT_IDEAL_DIST_STRENGTH = 30;
class DotDrawer {
	float x;
	float y;
	float speed;
	float dir;
	float dirAcc;

	DotDrawer() {
		x = random(0, WIDTH);
		y = random(0, HEIGHT);
		speed = random(MIN_MOVE_SPEED, MAX_MOVE_SPEED);
		dir = random(0.0, 360.0);
		dirAcc = 0.0;
	}

	void reactTo(other) {
		//calc distance to other DotDrawer
		float distX = x - other.x;
		if(WIDTH - distX < distX) { distX = WIDTH - distX; }
		float distY = y - other.y;
		if(HEIGHT - distY < distY) { distY = HEIGHT - distY; }
		float squareDist = distX * distX + distY * distY;

		//the closer another DotDrawer is, the more influence it has over the DotDrawer
		float influence = 1 - squareDist / (WIDTH * WIDTH / (8 * 8) + HEIGHT * HEIGHT / (8 * 8));
		if(influence > 0) {
			//DotDrawers will align to face the same direction
			float dirDiff = dir - other.dir;
			if(dirDiff > 180.0) { dirDiff -= 360.0; }
			else if(dirDiff < -180.0) { dirDiff += 360.0; }
			if(dirDiff < 0) { dirAcc += MAX_ROTATE_SPEED * FACE_SAME_DIR_STRENGTH / 5000; }
			else if(dirDiff > 0) { dirAcc -= MAX_ROTATE_SPEED * FACE_SAME_DIR_STRENGTH / 5000; }

			//DotDrawers will try to point towards far-off DotDrawers, or away from near ones
			float angleTo = degrees(atan2(distY, distX));
			float angleDiff = dir - angleTo;
			if(angleDiff > 180.0) { angleDiff -= 360.0; }
			else if(angleDiff < -180.0) { angleDiff += 360.0; }
			if(squareDist > IDEAL_DIST * IDEAL_DIST) {
				if(angleDiff > 0) { dirAcc += influence * MAX_ROTATE_SPEED * BE_AT_IDEAL_DIST_STRENGTH / 5000; }
				else if(angleDiff < 0) { dirAcc -= influence * MAX_ROTATE_SPEED * BE_AT_IDEAL_DIST_STRENGTH / 5000; }
			}
			else {
				if(angleDiff > 0) { dirAcc -= influence * MAX_ROTATE_SPEED * BE_AT_IDEAL_DIST_STRENGTH / 5000; }
				else if(angleDiff < 0) { dirAcc += influence * MAX_ROTATE_SPEED * BE_AT_IDEAL_DIST_STRENGTH / 5000; }
			}
		}
	}

	void update() {
		//rotating
		dirAcc += random(-MAX_ROTATE_SPEED / 10, MAX_ROTATE_SPEED / 10);
		dirAcc *= 0.98;
		if(dirAcc < -MAX_ROTATE_SPEED) { dirAcc = -MAX_ROTATE_SPEED; }
		else if(dirAcc > MAX_ROTATE_SPEED) { dirAcc = MAX_ROTATE_SPEED; }

		//speeding up / down
		speed += random(-(MAX_MOVE_SPEED - MIN_MOVE_SPEED) / 20,
			(MAX_MOVE_SPEED - MIN_MOVE_SPEED) / 20);
		if(speed > MAX_MOVE_SPEED) { speed = MAX_MOVE_SPEED; }
		else if(speed < MIN_MOVE_SPEED) { speed = MIN_MOVE_SPEED; }

		dir += dirAcc;
		dir = (dir % 360.0 + 360.0) % 360.0;
		x += speed * cos(radians(dir));
		y += speed * sin(radians(dir));

		//keep DotDrawer in bounds
		if(x < 0) { x += WIDTH; }
		else if(x > WIDTH) { x -= WIDTH; }
		if(y < 0) { y += HEIGHT; }
		else if(y > HEIGHT) { y -= HEIGHT; }

		//draw the DotDrawer
		stroke(0, 0, 0, 255);
		point(x, y);
	}
}