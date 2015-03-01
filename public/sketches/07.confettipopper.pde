//setup
int NUM_CONFETTI_PIECES = 100;
ConfettiStrand[] confetti;

void setup() {
	size(800, 600, P3D);
	confetti = new ConfettiStrand[NUM_CONFETTI_PIECES];
	reset();
}

//main methods
void reset() {
	background(255);
	for(int i = 0; i < NUM_CONFETTI_PIECES; i++) {
		confetti[i] = new ConfettiStrand(100, height / 2, random(2.5, 2.75), random(-2, -1.75));
	}
}

void draw() {
	//clear canvas
	noStroke();
    fill(255, 255, 255, 255);
    rect(0, 0, width, height);

    //draw confetti
	for(int i = 0; i < NUM_CONFETTI_PIECES; i++) {
		confetti[i].updateAndDraw();
	}
}

void mousePressed() {
	reset();
}

//classes
float STRAND_LENGTH = 30;
class ConfettiStrand {
	PVector pos;
	PVector vel;
	PVector[] prevPos;

	ConfettiStrand(startingX, startingY, startingVelX, startingVelY) {
		pos = new PVector(startingX, startingY);
		vel = new PVector(startingVelX, startingVelY);
		prevPos = new PVector[STRAND_LENGTH];
		for(int i = 0; i < STRAND_LENGTH; i++) {
			prevPos[i] = null;
		}
	}

	void updateAndDraw() {
		vel.y += 0.01;
		vel.x += random(-0.1, 0.1);
		vel.y += random(-0.1, 0.1);
		vel.mult(0.99);
		pos.add(vel);

		for(int i = STRAND_LENGTH - 1; i >= 1; i--) {
			prevPos[i] = prevPos[i - 1];
		}
		prevPos[0] = new PVector(pos.x, pos.y);

		//draw
		noFill();
		stroke(0, 0, 0);
		beginShape();
		for(int i = STRAND_LENGTH - 1; i >= 1; i--) {
			if(prevPos[i] != null) {
				vertex(prevPos[i].x, prevPos[i].y);
			}
		}
		endShape();
	}
}