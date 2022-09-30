
class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;

  color col;

  Particle(float x, float y) {
    r = 8;

    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.STATIC;
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1000;
    fd.friction = 1000;//0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));

    col = color(255);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }



  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    // Get its angle of rotation
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y);
    fill(col);
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    line(0, 0, r, 0);
    popMatrix();
  }
}
