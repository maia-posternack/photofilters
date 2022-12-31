//importing everything
import controlP5.*;  
ControlP5 cp5;
import java.io.File;

//all the global vars
PImage img;
int dotNumber = -1;
int state = -1;
int[] colorTracker = new int[1]; 
boolean lines = true;
float oc = 4.5;
float avg_ds = 6;
int rs = 15;
float ds = 17;
float NAME =.01;
int NAME2 = 5;

int typ = 10;
int txp = 20;


//setup
void setup() {
  size(950, 500); //dimensions of screen
  ellipseMode(CENTER);
  cp5 = new ControlP5(this);//load cp5
  cp5.addButton("new_upload")  // button
    .setBroadcast(false)
    .setPosition(730, 10)
    .setSize(150, 29)
    .setValue(0)
    .setBroadcast(true)
    ;
  cp5.addButton("show_image")  // button
    .setBroadcast(false)
    .setPosition(730, 40)
    .setSize(150, 29)
    .setBroadcast(true)
    ;
  cp5.addButton("roy_lichtenstein")  // button
    .setBroadcast(false)
    .setPosition(730, 70)
    .setSize(150, 29)
    .setBroadcast(true)
    ;
  cp5.addButton("outline")  // button
    .setBroadcast(false)
    .setPosition(730, 100)
    .setSize(75, 19)
    .setBroadcast(true)
    ;
  cp5.addButton("no_outline")  // button
    .setBroadcast(false)
    .setPosition(806, 100)
    .setSize(74, 19)
    .setBroadcast(true)
    ;
  cp5.addSlider("outline_thickness")  // creating a slider
    .setBroadcast(false)
    .setPosition(730, 120)
    .setSize(150, 19)
    .setRange(1, 10)  
    .setValue(4.5)
    .setBroadcast(true)
    ;
  cp5.addSlider("avg_dot_size")  // creating a slider
    .setBroadcast(false)
    .setPosition(730, 140)
    .setSize(150, 19)
    .setRange(.5, 10)  
    .setValue(5)
    .setBroadcast(true)
    ;
  cp5.addButton("chuck_close")  // button
    .setBroadcast(false)
    .setPosition(730, 160)
    .setSize(150, 29)
    .setBroadcast(true)
    ;
  cp5.addSlider("rhombus_size")  // creating a slider
    .setBroadcast(false)
    .setPosition(730, 190)
    .setSize(150, 19)
    .setRange(5, 50)  
    .setValue(15)
    .setBroadcast(true)
    ;
  cp5.addSlider("dot_saturation")  // creating a slider
    .setBroadcast(false)
    .setPosition(730, 210)
    .setSize(150, 19)
    .setRange(7, 50) 
    .setValue(17)
    .setBroadcast(true)
    ;
  fill(255);
  stroke(255);
  rect(0, 0, 700, 700);
}
//if you change dot saturation
void dot_saturation (float val) {
  //ds (aka dot saturation variable) = the new value
  ds=val;
  //redraw the chuck close filter
  chuck_close();
}
//if you change outline thickness
void outline_thickness(float val) {
  //oc(aka outline thickness varaiable) = new value
  oc=val;
  //redraw lichtenstien filter 
  roy_lichtenstein();
}
//if change rhombus size
void rhombus_size(int val) {
  //set rhombus size bariable to new value
  rs = val;
  //redraw chuck_close filter
  chuck_close();
}
//if change dot size
void avg_dot_size(float val) {
  //set variable to new val
  avg_ds = val;
  //redraw lichtenstein filter
  roy_lichtenstein();
}
void new_upload() {
  //if you click button
  //select an image and then run imageChosen void
  selectInput( "Select an image", "imageChosen" );
}

void imageChosen( File f )
  //see the image chosen
{
  if ( f.exists() )
  {
    String path = f.getAbsolutePath(); //gtet name/location
    if (path.endsWith(".jpg") || path.endsWith(".jpeg") 
      || path.endsWith(".png") || path.endsWith(".gif")) { //if it's an image
      //set img to that image
      img = loadImage(path);
      //resize
      img.resize(700, 0);
    } else
      //if doesn't work, print this line
      println("Invald image format. Please try again");
  }
}
//if click show image
void show_image() {
  fill(255);
  stroke(255);
  rect(-1, -1, 700, 700);
  //draw the image
  image(img, 0, 0);
}

void outline() {
  //if click outline:
  //set boolean lines to true 
  lines = true;
  //now redraw lichtenstein with lines
  roy_lichtenstein();
}
void no_outline() {
  //if click no_outline
  //set boolean lines to false
  lines = false;
  //redraw without the outlines
  roy_lichtenstein();
}



void draw() {
  //buffering
}
//chuck close filter
void chuck_close() {
  //draw a white background 
  fill(255);
  stroke(255);
  rect(-1, -1, 700, 700);
  //load all the data from the img 
  img.loadPixels();  

  ellipseMode(CENTER);
  //based on rhombus size, go to x and y
  for (int y = 0; y < img.height; y+=(rs*2)) {
    for (int x = 0; x < img.width; x+=(rs*2)) {

      // Pixel location and color
      int i = x + y*img.width;         
      float r = red(img.pixels[i]);  // pulls the red value from the pixels in pixels[] array
      float g = green(img.pixels[i]); // pulls the green value from the pixels in pixels[] array
      float b = blue(img.pixels[i]); // pulls the blue value from the pixels in pixels[] array

      //make less bright
      r-= 15;
      g-=15;
      b-=15 ;

      noStroke();
      fill(r, g, b);
      //make rhombus that color 
      quad(x+rs+.5, y, x, y+rs+.5, x-rs-.5, y, x, y-rs-.5);

      //make 4 random numbers for small circles
      float smallWidth= random(2, rs-4);
      float smallHeight= random(2, rs-4);
      float largeWidth= random(rs-6, rs+3);
      float largeHeight= random(rs-6, rs+3);

      //figure out which are the most prominant colors
      //for the most prominent color, draw circle centered at x, y with largeWidth and largeHeight
      //for second most prominent color, draw smaller circle centered at x,y with smallWidth and smallHeight
      if ((r > g)&&(r>b)) {
        fill(r+ds*1.2, g-ds, b-ds);
        ellipse(x, y, largeWidth, largeHeight);
        if (g>b) {
          fill(r-ds, g+ds*1.2, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        } else {
          fill(r-ds, g-ds, b+ds*1.2);
          ellipse(x, y, smallWidth, smallHeight);
        }
      } else if ((g > r)&&(g>b)) {
        fill(r-ds, g+ds*1.2, b-ds);
        ellipse(x, y, largeWidth, largeHeight);     
        if (r>b) {
          fill(r+ds*1.2, g-ds, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        } else {
          fill(r-ds, g-ds, b+ds*1.2);
          ellipse(x, y, smallWidth, smallHeight);
        }
      } else {
        fill(r-ds, g-ds, b+ds*1.2);
        ellipse(x, y, largeWidth, largeHeight);
        if (r>g) {
          fill(r-ds, g+ds*1.2, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        } else {
          fill(r+ds*1.2, g-ds, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        }
      }
    }
  }
  //so in earlier for loops, only drew every other rhombus so here are the other half
  for (int y = rs; y < img.height; y+=(rs*2)) {
    for (int x = rs; x < img.width; x+=(rs*2)) {

      // Pixel location and color
      int i = x + y*img.width;         
      float r = red(img.pixels[i]); 
      float g = green(img.pixels[i]); 
      float b = blue(img.pixels[i]); 

      //make less vibrant
      r-= 15;
      g-=15;
      b-=15 ;
      noStroke();
      fill(r, g, b);
      //draw rhombus
      quad(x+rs+.5, y, x, y+rs+.5, x-rs-.5, y, x, y-rs-.5);
      //get random sizes
      float smallWidth= random(2, rs-4);
      float smallHeight= random(2, rs-4);
      float largeWidth= random(rs-6, rs+3);
      float largeHeight= random(rs-6, rs+3);

      //figure out which are the most prominant colors
      //for the most prominent color, draw circle centered at x, y with largeWidth and largeHeight
      //for second most prominent color, draw smaller circle centered at x,y with smallWidth and smallHeight
      if ((r > g)&&(r>b)) {
        fill(r+ds*1.2, g-ds, b-ds);
        ellipse(x, y, largeWidth, largeHeight);
        if (g>b) {
          fill(r-ds, g+ds*1.2, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        } else {
          fill(r-ds, g-ds, b+ds*1.2);
          ellipse(x, y, smallWidth, smallHeight);
        }
      } else if ((g > r)&&(g>b)) {
        fill(r-ds, g+ds*1.2, b-ds);
        ellipse(x, y, largeWidth, largeHeight);     
        if (r>b) {
          fill(r+ds*1.2, g-ds, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        } else {
          fill(r-ds, g-ds, b+ds*1.2);
          ellipse(x, y, smallWidth, smallHeight);
        }
      } else {
        fill(r-ds, g-ds, b+ds*1.2);
        ellipse(x, y, largeWidth, largeHeight);
        if (r>g) {
          fill(r-ds, g+ds*1.2, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        } else {
          fill(r+ds*1.2, g-ds, b-ds);
          ellipse(x, y, smallWidth, smallHeight);
        }
      }
    }
  }
  //cover raw edges with a couple white rectangles 
  fill(255);
  stroke(255);
  rect(0, img.height-rs, 700, 800);
  rect(img.width-rs, 0, rs, 800);
  fill(200);
  noStroke();
  rect(700, 0, 300, 700);
}



//lichtenstein function 
void roy_lichtenstein() {
  //draw background
  fill(255);
  stroke(255);
  rect(-1, -1, 700, 700);

  img.loadPixels();  // loading the pixels from the image

  //for every 8 pixels 
  for (int y = 10; y < img.height-10; y+=8) {
    for (int x = 10; x < img.width-10; x+=8) {


      // Pixel location and color
      int i = x + y*img.width;         
      float r = red(img.pixels[i]);  
      float g = green(img.pixels[i]); 
      float b = blue(img.pixels[i]); 
      noStroke();
      //whatver color is the strongest, make a lot brighter and then subtract from the other 2 colors
      if ((r >= g)&&(r>=b)) {
        fill(r+100, g-30, b-30);
        ellipse(x, y, avg_ds, avg_ds);
      } else if ((g >= b)&&(g>=r)) {
        fill(r-30, g+100, b-30);
        ellipse(x, y, avg_ds-2, avg_ds-2);
      } else {
        fill(r-30, g-30, b+100);
        ellipse(x, y, avg_ds+2, avg_ds+2);
      }
    }
  }

  for (int y = 10; y < img.height-10; y+=1) {
    for (int x = 10; x < img.width-10; x+=1) {

      //NOW GOING TO DO THE OUTLINE
      //get all data from pixel above

      // Pixel location and color
      int i = x + y*img.width;         
      float r = red(img.pixels[i]);  
      float g = green(img.pixels[i]); 
      float b = blue(img.pixels[i]); 
      float greyscale = 0.2126 * r + 0.7152 * g + 0.0722 * b; //used for brightness later

      //for pixel above 
      int topLoc = x + (y-1)*img.width; 
      float r2 = red(img.pixels[topLoc]);  
      float g2 = green(img.pixels[topLoc]); 
      float b2 = blue(img.pixels[topLoc]); 
      float greyscale2 = 0.2126 * r2 + 0.7152 * g2 + 0.0722 * b2;

      //do the same for the pixel on the left
      int leftLoc = x + (y-1)*img.width;
      float r3 = red(img.pixels[leftLoc]); 
      float g3 = green(img.pixels[leftLoc]); 
      float b3 = blue(img.pixels[leftLoc]); 
      float greyscale3 = 0.2126 * r3 + 0.7152 * g3 + 0.0722 * b3;

      //find difference in brightness between pixel and top pixel and pixel and left pixel 
      float dif = abs(greyscale-greyscale2);
      float dif2 = abs(greyscale3-greyscale);

      // this will pick up all the details that aren't color based (ie eyes, mouths etc) 
      //if supposed to draw outlines 
      if (lines == true) {
        //if dif is big, draw a black line
        if (dif > 30) {
          stroke(10);
          strokeWeight(oc/2); //baed on outline thickness
          line(x+1, y, x-1, y);
        }
        //if diff 2 is bif, draw black line
        if (dif2 > 30) {
          stroke(10);
          strokeWeight(oc/2); //based on outline thickness
          line(x, y+1, x, y-1);
        }

        //now getting outlines for around each color of dots
        //adjust each of the colors like we did when we were drawing them
        if ((r >= g)&&(r>=b)) {
          r+= 100;
          g-=30;
          b-=30;
        } else if ((g >= b)&&(g>=r)) {
          r-= 30;
          g+=100;
          b-=30;
        } else {
          r-= 30;
          g-=30;
          b+=100;
        }

        //adjust colors above
        if ((r2 >= g2)&&(r2>=b2)) {
          r2+= 100;
          g2-=30;
          b2-=30;
        } else if ((g2 >= b2)&&(g2>=r2)) {
          r2-= 30;
          g2+=100;
          b2-=30;
        } else {
          r2-= 30;
          g2-=30;
          b2+=100;
        }

        //adjust colors to the left
        if ((r3 >= g3)&&(r3>=b3)) {
          r3+= 100;
          g3-=30;
          b3-=30;
        } else if ((g3 >= b3)&&(g3>=r3)) {
          r3-= 30;
          g3+=100;
          b3-=30;
        } else {
          r3-= 30;
          g3-=30;
          b3+=100;
        }
        //if there is a really big difference of color (ie if the one above is green and the one below is red)
        //draw black line
        if ((abs(r-r2) > 180)||(abs(g-g2) > 110)||(abs(b-b2) > 110)) {
          stroke(10);
          strokeWeight(oc);
          line(x+1, y, x-1, y);
        }
        //if there is a really big difference of color (ie if the one to the right is green and the one to the left is red)
        //draw black line
        if ((abs(r-r3) > 180)||(abs(g-g3) > 110)||(abs(b-b3) > 110)) {
          stroke(10);
          strokeWeight(oc);
          line(x, y+1, x, y-1);
        }
      }
    }
  }
  //make a black outline around the whole image
  stroke(0);
  strokeWeight(40);
  line(0, 0, 680, 0);
  line(0, 0, 0, img.height-20);
  strokeWeight(20);
  line(0, img.height-10, img.width-10, img.height-10);
  line(img.width-10, 0, img.width-10, img.height-10);
  fill(200);
  noStroke();
  rect(700, 0, 300, 700);
}
