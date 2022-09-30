
class Pen {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  color col;
  Vec2 pos;// = box2d.getBodyPixelCoord(body);

  Pen(float x, float y) {
    r = 8;

    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0;
    fd.friction = 0;//0.01;
    fd.restitution = 0;

    // Attach fixture to body
    body.createFixture(fd);
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));

    col = color(175);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }


  void update () {
    pos = box2d.getBodyPixelCoord(body);
  }

  void display() {
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    // Let's add a line so we can see the rotation
    line(0, 0, -20, 0);
    popMatrix();
  }
}
