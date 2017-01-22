class Circle { //create a new class called Circle

  PVector loc; //the location of the Circle
  PVector loc2; //the location of the Circle in the new image
  PVector vel; //the velocity of the Circle
  PVector acc; //the acceleration of the Circle
  color c; //the color of the circle
  float r; //the radius of the circle
  boolean positioned; //is the circle positioned?

  Circle (PVector loc_, color c_, float r_) { //initialisation function of the Circle
    loc = loc_; //set the location to the specified location
    loc2 = new PVector(0, 0); //initialise the location in the second image to be (0, 0) (this will be changed)
    vel = new PVector(0, 0); //initialise the velocity to be zero
    acc = new PVector(0, 0); //initialise the acceleration to be zero
    c = c_; //set the colour to be the specified colour
    r = r_; //set the radius to be the specified radius
    positioned = false; //the circle is not in the right place at the start
  }

  void show() { //function to display the Circle
    strokeWeight(0); //no border on the circle
    fill(c); //the circle should be the specified colour
    ellipse(loc.x, loc.y, 2*r, 2*r); //draw an ellipe at it's location, with the Circle's radius
  }

  void newimg() { //move the circle to its place in the new image 
    PVector l1 = loc.copy(); //l1 is a copy of the location vector
    PVector l2 = loc2.copy(); //l2 is a copy of the location in the second image 
    PVector force = l2.sub(l1).setMag(25); //the force points from the location toward the second location, with magnitude 25
    vel = force.copy(); //the velocity is just set to be the force
    if ( dist(loc.x, loc.y, loc2.x, loc2.y) < 25 ) { //if the circle is close enough to where it should be in the second image
     loc = loc2; // snap the Circle to the position it should be in
     positioned = true; //the circle is now positioned
     acc.mult(0); //set the acceleration to 0
     vel.mult(0); //set the velocity to 0
    }
  }

  void applyForce() { //apply the force of gravity to a Circle
    PVector force = new PVector(random(-0.8, 0.8), 1 + random(-0.3, 0.3)); //The force points down, but also points randomly to the sides
    acc.add(force); //add the force to the acceleration
  }

  void update() { //update the velocity, position of the Circle
    vel.add(acc); //add acceleration to velocity
    loc.add(vel); //add velocity to location
    acc.mult(0); //set the acceleration to 0
    
    //the rest checks collisions with the borderes and causes the Circles to bounce
    if (loc.x - r < 0) {
      vel.x *= -1;
      loc.x = r + 1;
    }

    if (loc.x + r > width) {
      vel.x *= -1;
      loc.x = width - (r + 1);
    }

    if (loc.y - r < 0) {
      vel.y *= -1;
      loc.y = r + 1;
    }

    if (loc.y + r > height) {
      vel.y *= -1;
      loc.y = height - (r + 1);
    }
  }
}