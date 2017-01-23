//A program that displays one picture as a bunch of circles.
//When the mouse is clicked the circles start to bounce around.
//When the mouse is clicked agian a second time, the circles re arrange themselves 
//into a second picture as best they can, without changing colour.

//This program runs incredibly slowly because of the insane number of circles involved.
//It can be made to run faster by increading the radius of the circles.
//If you want to use a small radius (so that the images resemble what they should :P ),
//saveFrame() can be put at the end of the draw() loop, and the frames can be stitched
//together into a video with another programm. (or you could do it in processing! :P :P )

//By Masakazu Iwasaki


PImage miah;
PImage hedgehog;
float r = 2; //radius
float d = 2 * r; // diameter
ArrayList<Circle> circles;
ArrayList<Float> ps; //list of pixels
boolean bouncy = false; //Should the circles be experiencing physics?
boolean newimg = false; //Should the circles be lining up into the new image?
float mouseclicks = 0; //How many times has the mouse been clicked?

void setup() {
  size(720, 960, P2D); //P2D to help ease the load on this demanding program (it doesn't help much :P )
  circles = new ArrayList<Circle>(); //A new ArrayList of Circle Objects
  ps = new ArrayList<Float>(); //A new ArrayList that contains the locations of certain pixels in the pixels[] arrays
  miah = loadImage("miah.jpg"); //loading the first image
  hedgehog = loadImage("hedgehog.jpg"); //loading the second image
  miah.loadPixels(); //loading the pixels of the first image
  hedgehog.loadPixels(); //loading the pixels of the second image

  for (int i = 0; i < miah.pixels.length; i++ ) {
    int column = i % width; //the column number is the remainder of i divided by the width
    int row = floor(i / width ); //the row number is i divided by the width, rounded down

    if (row % d == 0 && row != 0 && column % d == 0 && column != 0 ) { //If the row and column number is a multiple of the circle diameter
      circles.add(new Circle(new PVector(column, row), miah.pixels[i], r)); //Create a new Circle object, and place it at that row and column
      ps.add(float(i)); //Add that pixel index to the ArrayList ps (just so I don't have to calculate it again for the other picture)
    }
  }

  ArrayList<Circle> notused = new ArrayList<Circle>(circles); //Create an ArrayList called notused, that is a copy of circles

  while (ps.size() > 0 ) { //while there are still items in the ps ArrayList

    float i = ps.get(int(random(0, ps.size()))); //i is a random element of the ps ArrayList

    int column = int(i % width); //calculate which column it is, as above
    int row = floor(i / width ); //calculate which row it is, as above


    color a = hedgehog.pixels[int(i)]; //a is the color of the second image at that row, column
    float a_r = red(a); //a_r is the red part of a
    float a_g = green(a); //a_g is the green part of a
    float a_b = blue(a); //a_b is the blue part of a
    float lowest = 10000000; //initialise the lowest number to a large number
    Circle current = new Circle(new PVector(0, 0), color(0), 5); //create a temporary Circle object, it will be replaced

    for (Circle c : notused) { //for each circle in the ArrayList notused


      color b = c.c; //b is the color of that circle
      float b_r = red(b); //b_r is the red part of that circle
      float b_g = green(b); //b_g is the green part of that circle
      float b_b = blue(b); //b_b is the blue part of that circle

      float val = sqrt(pow(b_r - a_r, 2) + pow(b_g - a_g, 2) + pow(b_b - a_b, 2)); //val is the euclidean distance between the two colours
      if ( val < lowest) { //if val is less than lowest
        lowest = val; 
        current = c;
      }
    }
    current.loc2 = new PVector(column, row); //the location of that circle in the new image is set
    notused.remove(current); //remove that circle from the ArrayList notused
    println(notused.size()); //Print the length of the ArrayList notused, just because it's nice to know how long the program will take to initialise
    ps.remove(i); //remove the pixel index from the ps ArrayList
    if (notused.size() == 0 ) { //just a precaution that breaks the while loop if the size of notused is 0
      println("trying to break");
      break;
    }
  }
}

void draw() {
  background(127); //set the background colour
  for (Circle c : circles) { //for each circle c in the list of circles
    c.show(); //show the circle

    if (bouncy) { //if the circles should be bouncing around
      c.applyForce(); //apply forces to the circles
      c.update();//update the positions, velocities of the circles
    }
    if (!c.positioned) { //if a circle is not positioned
      if (newimg) { //if the circles should be moving toward the new image
        c.newimg(); //move the circle toward its location in the new image
        c.update(); //update the positions, velocities of the circles
      }
    }
  }
}

void mouseClicked() {
  if (mouseclicks == 0) { //if its the first mouse click
    bouncy = true; //the circles should be bouncing
  } else { //if it's not the first mouse click
    bouncy = false; //the balls shouldn't be bouncing
    newimg = true; //the balls should be moving toward their locations in the new image
  }

  mouseclicks++; //the number of mouse clicks is increased by one
}
