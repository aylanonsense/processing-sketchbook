//constants
int NUM_BOXES = 1;
int WIDTH = 800;
int HEIGHT = 600;
float PYTHAGOREAN_CONST = 1 / sqrt(2);

//cache math operations
int viewAngleChange;
float viewAngle;
float cosViewAngle;
float sinViewAngle;

//setup
Box[] boxes;

void setup() {
	size(WIDTH, HEIGHT);
	boxes = new Box[NUM_BOXES];
	reset();
}

//main methods
void reset() {
	//clear canvas
	background(255);

	//set angle
	viewAngle = radians(20.0);
	cosViewAngle = cos(viewAngle);
	sinViewAngle = sin(viewAngle);
	viewAngleChange = 1;

	//create base box
	boxes[0] = new Box(0, 0, 0, random(150, 250), random(100, 250), random(150, 250))

	//create boxes
	/*boxes[0] = new Box(-100, 0, 0, 100, 100, 100);
	boxes[1] = new Box(0, 0, -100, 100, 100, 100);
	boxes[2] = new Box(0, 0, 0, 100, 100, 100);
	boxes[3] = new Box(100, 0, 0, 100, 100, 100);
	boxes[4] = new Box(0, 0, 100, 100, 100, 100);*/
}

void draw() {
	//adjust angle
	if(viewAngle > radians(90)) { viewAngleChange = -1; }
	else if(viewAngle < radians(0)) { viewAngleChange = 1; }
	viewAngle += radians(viewAngleChange * 0.15);
	cosViewAngle = cos(viewAngle);
	sinViewAngle = sin(viewAngle);

	//clear canvas
	noStroke();
    fill(255, 255, 255, 255);
    rect(0, 0, WIDTH, HEIGHT);

    //draw boxes
	for(int i = 0; i < NUM_BOXES; i++) {
		boxes[i].draw();
	}
}

void mousePressed() {
	reset();
}

//useful utility functions
float renderX(x, y, z) {
	return WIDTH / 2.0 - x * PYTHAGOREAN_CONST + z * PYTHAGOREAN_CONST;
}
float renderY(x, y, z) {
	return HEIGHT * 0.57 + x * sinViewAngle * PYTHAGOREAN_CONST
		+ y * cosViewAngle + z * sinViewAngle * PYTHAGOREAN_CONST;
}

//classes
class Box {
	float x;
	float y;
	float z;
	float w; //width
	float h; //height
	float d; //depth

	/*
                 /\
  width / x --> /  \
               |\   \
 height / y -> | \  /|
               |  \/ |
  depth / z --> \  | |	
                 \ | /
               /  \|/
              +x      \
                   |   +z
                   +y
   */

	Box(x0, y0, z0, w0, h0, d0) {
		x = x0;
		y = y0;
		z = z0;
		w = w0;
		h = h0;
		d = d0;
	}

	void drawLine(x1, y1, z1, x2, y2, z2) {
		stroke(255, 0, 0);
		line(renderX(x1, y1, z1), renderY(x1, y1, z1), renderX(x2, y2, z2), renderY(x2, y2, z2));
	}

	void draw() {
		//draw right face
		fill(75, 75, 75);
		noStroke();
		beginShape();
		vertex(renderX(x+w/2, y+h/2, z+d/2), renderY(x+w/2, y+h/2, z+d/2));
		vertex(renderX(x+w/2, y-h/2, z+d/2), renderY(x+w/2, y-h/2, z+d/2));
		vertex(renderX(x-w/2, y-h/2, z+d/2), renderY(x-w/2, y-h/2, z+d/2));
		vertex(renderX(x-w/2, y+h/2, z+d/2), renderY(x-w/2, y+h/2, z+d/2));
		endShape(CLOSE);

		//draw left face
		fill(150, 150, 150);
		noStroke();
		beginShape();
		vertex(renderX(x+w/2, y+h/2, z+d/2), renderY(x+w/2, y+h/2, z+d/2));
		vertex(renderX(x+w/2, y-h/2, z+d/2), renderY(x+w/2, y-h/2, z+d/2));
		vertex(renderX(x+w/2, y-h/2, z-d/2), renderY(x+w/2, y-h/2, z-d/2));
		vertex(renderX(x+w/2, y+h/2, z-d/2), renderY(x+w/2, y+h/2, z-d/2));
		endShape(CLOSE);

		//draw top face
		fill(200, 200, 200);
		noStroke();
		beginShape();
		vertex(renderX(x+w/2, y-h/2, z+d/2), renderY(x+w/2, y-h/2, z+d/2));
		vertex(renderX(x+w/2, y-h/2, z-d/2), renderY(x+w/2, y-h/2, z-d/2));
		vertex(renderX(x-w/2, y-h/2, z-d/2), renderY(x-w/2, y-h/2, z-d/2));
		vertex(renderX(x-w/2, y-h/2, z+d/2), renderY(x-w/2, y-h/2, z+d/2));
		endShape(CLOSE);
	}
}