
class DrawingMachine {

  Particle p1;
  Particle p2;
  Particle p3;
  Pen pen;

  float len;
  float diagonal;

  int multiplier = 1;

  DistanceJointDef djd;
  DistanceJointDef djd2;
  DistanceJointDef djd3;


  DistanceJoint dj;
  DistanceJoint dj2;
  DistanceJoint dj3;

  // Chain constructor
  DrawingMachine() {
    len = width/2;

    p1 = new Particle(0, 0);
    p2 = new Particle(width, 0);
    p3 = new Particle(width/2, height);

    pen = new Pen(width/2, height/2);

    createJoints(len, len, len);
  }

  void createJoints (float l1, float l2, float l3) {

    if (dj != null) {
      box2d.world.destroyJoint(dj);                   //destroy it
      box2d.world.destroyJoint(dj2);                   //destroy it
      box2d.world.destroyJoint(dj3);                   //destroy it
    }



    djd = new DistanceJointDef();
    // Connection between previous particle and this one
    djd.bodyA = p1.body;
    djd.bodyB = pen.body;


    djd2 = new DistanceJointDef();
    djd2.bodyA = p2.body;
    djd2.bodyB = pen.body;


    djd3 = new DistanceJointDef();
    djd3.bodyA = p3.body;
    djd3.bodyB = pen.body;

    // Equilibrium length
    djd.length = box2d.scalarPixelsToWorld(l1);
    djd2.length = box2d.scalarPixelsToWorld(l2);
    djd3.length = box2d.scalarPixelsToWorld(l3);

    // These properties affect how springy the joint is
    float f = 0.2; // elasticidad -(0 for no elasticity) 1 elastico.
    float d = 0.1; // oscilacion . 0 -> flexible. 1-> duro
    djd.frequencyHz = f;
    djd.dampingRatio = d; // Ranges between 0 and 1


    djd2.frequencyHz = f;
    djd2.dampingRatio = d;

    djd3.frequencyHz = f;
    djd3.dampingRatio = d;

    // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
    // We might need to someday, but for now it's ok
    dj = (DistanceJoint) box2d.world.createJoint(djd);
    dj2 = (DistanceJoint) box2d.world.createJoint(djd2);
    dj3 = (DistanceJoint) box2d.world.createJoint(djd3);


    diagonal = sqrt(pow(width, 2)+pow(height, 2));
  }




  // Draw the bridge
  void update() {
    pen.update();
  }


  void updateForces(float force1, float force2, float force3) {

    float l1 = diagonal/2 + (-force1 * multiplier);
    float l2 = diagonal/2 + (-force2 * multiplier);
    float l3 = height/2 + (-force3 * multiplier);


    createJoints(l1, l2, l3);
  }

  void setForceMultiplier (int m) {
    multiplier = m;
  }

  void display () {
    Vec2 pos1 = box2d.getBodyPixelCoord(p1.body);
    Vec2 pos2 = box2d.getBodyPixelCoord(p2.body);
    Vec2 pos3 = box2d.getBodyPixelCoord(p3.body);


    Vec2 penPos = box2d.getBodyPixelCoord(pen.body);

    stroke(0);
    line(pos1.x, pos1.y, penPos.x, penPos.y);
    line(pos2.x, pos2.y, penPos.x, penPos.y);
    line(pos3.x, pos3.y, penPos.x, penPos.y);

    p1.display();
    p2.display();
    p3.display();
    pen.display();
  }
}
