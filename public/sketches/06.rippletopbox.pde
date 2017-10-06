//constants
int NUM_BOXES = 1;
float PYTHAG = 1 / sqrt(2);

//cache math operations
int viewAngleChange;
float viewAngle;
float cosViewAngle;
float sinViewAngle;

//setup
Box[] boxes;

void setup() {
	size(450, 450);
	boxes = new Box[NUM_BOXES];
	reset();
}

//main methods
void reset() {
	//clear canvas
	background(255);

	//set angle
	viewAngle = radians(30.0);
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
	viewAngle += radians(viewAngleChange * 0.35);
	cosViewAngle = cos(viewAngle);
	sinViewAngle = sin(viewAngle);

	//clear canvas
	noStroke();
    fill(255, 255, 255, 255);
    rect(0, 0, width, height);

    //draw boxes
	for(int i = 0; i < NUM_BOXES; i++) {
		boxes[i].draw();
	}

	//draw rings
	for(float radius = 5; radius <= 200; radius += 5) {
		drawRing(boxes[0], radius);
	}
}

void mousePressed() {
	reset();
}

void drawRing(box, radius) {
	noFill();
	float ringCenterX = renderX(box.x + 40, box.y-box.h/2, box.z - 20);
	float ringCenterY = renderY(box.x + 40, box.y-box.h/2, box.z - 20);

	float lineStartX = renderX(box.x+box.w/2, box.y-box.h/2, box.z-box.d/2);
	float lineStartY = renderY(box.x+box.w/2, box.y-box.h/2, box.z-box.d/2);
	float lineEndX = renderX(box.x+box.w/2, box.y-box.h/2, box.z+box.d/2);
	float lineEndY = renderY(box.x+box.w/2, box.y-box.h/2, box.z+box.d/2);
	// stroke(255, 0, 0);
	// line(lineStartX, lineStartY, lineEndX, lineEndY);
	drawClippedCircle2(ringCenterX, ringCenterY, radius, lineStartX, lineStartY, lineEndX, lineEndY);
	AnglePair pair = drawClippedCircle2(
		(width / 2.0) + box.x - 40, (height * 0.57) + box.z + 20, radius,
		(width / 2.0) + box.x - PYTHAG * box.d/2 - PYTHAG * box.w/2,
		(height * 0.57) + box.z - PYTHAG * box.d/2 + PYTHAG * box.w/2,
		(width / 2.0) + box.x + PYTHAG * box.d/2 - PYTHAG * box.w/2,
		(height * 0.57) + box.z + PYTHAG * box.d/2 + PYTHAG * box.w/2
	);
	stroke(255, 0, 0);
	arc(ringCenterX, ringCenterY, 2 * radius, 2 * radius * sinViewAngle, pair.angle1, pair.angle2);
	// PVector v1 = new PVector(lineEndX - lineStartX, lineEndY - lineStartY);
	// PVector v2 = new PVector(lineStartX - ringCenterX, lineStartY - ringCenterY);
	// boolean isBlah = blah2(v1, v2, radius);
	// line(lineStartX, lineStartY, lineEndX, lineEndY);
	// line(ringCenterX, ringCenterY, lineStartX, lineStartY);
	// if(isBlah) {
	// 	stroke(0, 0, 255);
	// }
	// else {
	// 	stroke(0, 255, 0);
	// }
	// arc(ringCenterX, ringCenterY, radius, radius * sinViewAngle, 0, TWO_PI);
}

void drawClippedCircle2(circleX, circleY, radius, x1, y1, x2, y2) {
	//this is some clever business to deal with viewing angles
	// y2 = y1 + (y2 - y1) / sinViewAngle;
	// stroke(255, 0, 0);
	// line(x1, y1, x2, y2);
	// stroke(0, 255, 0);
	// arc(circleX, circleY, 2 * radius, 2 * radius, 0, TWO_PI);
	PVector v1 = new PVector(x2 - x1, y2 - y1);
	PVector v2 = new PVector(circleX - x1, circleY - y1);
	float xyz = v1.mag();
	v1.normalize();
	v1.mult(v1.dot(v2));
	PVector v3 = new PVector(x1 + v1.x - circleX, y1 + v1.y - circleY);

	PVector d = new PVector(x2 - x1, y2 - y1);
	PVector f = new PVector(x1 - circleX, y1 - circleY);
	float r = radius;

	float a = d.dot( d ) ;
	float b = 2*f.dot( d ) ;
	float c = f.dot( f ) - r*r ;
	float discriminant = b*b-4*a*c;

	if(discriminant >= 0) {
		discriminant = sqrt( discriminant );
		float t1 = (-b - discriminant)/(2*a);
		float t2 = (-b + discriminant)/(2*a);
		PVector t2vector = new PVector(v1.x, v1.y);
		t2vector.normalize();
		t2vector.mult(xyz * t2);
		float intersectionX1 = x1 + t2vector.x;
		float intersectionY1 = y1 + t2vector.y;
		PVector t1vector = new PVector(v1.x, v1.y);
		t1vector.normalize();
		t1vector.mult(xyz * t1);
		float intersectionX2 = x1 + t1vector.x;
		float intersectionY2 = y1 + t1vector.y;
		// stroke(255, 255, 0);
		// line(intersectionX1, intersectionY1, intersectionX2, intersectionY2);
		float angle1 = atan2(intersectionY1 - circleY, intersectionX1 - circleX);
		float angle2 = atan2(intersectionY2 - circleY, intersectionX2 - circleX);
		if(angle2 > 0) { angle2 -= TWO_PI; }
		// stroke(0, 255, 0);
		// arc(circleX, circleY, 2 * radius, 2 * radius, angle2, angle1);
		// stroke(0, 0, 255);
		// arc(circleX, circleY, 2 * radius, 2 * radius * sinViewAngle, angle2, angle1);
		return new AnglePair(angle2, angle1);
	}
	else {
		// stroke(0, 255, 0);
		// arc(circleX, circleY, 2 * radius, 2 * radius, 0, TWO_PI);
		// stroke(0, 0, 255);
		// arc(circleX, circleY, 2 * radius, 2 * radius * sinViewAngle, 0, TWO_PI);
		return new AnglePair(0, TWO_PI);
	}
}

//useful utility functions
float renderX(x, y, z) {
	return width / 2.0 - x * PYTHAG + z * PYTHAG;
}
float renderY(x, y, z) {
	return height * 0.57 + x * sinViewAngle * PYTHAG
		+ y * cosViewAngle + z * sinViewAngle * PYTHAG;
}

//classes
class AnglePair {
	float angle1;
	float angle2;

	AnglePair(one, two) {
		angle1 = one;
		angle2 = two;
	}
}

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