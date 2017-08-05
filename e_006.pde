import gab.opencv.*;  //ライブラリをインポート
import processing.video.*;
import java.awt.*;
//import controlP5.*;

FlockSystem fs;
ShoeSystem ss;

float diagonal;
float shadowLen;
float shadowLenR;
float EIGHTH_PI;

PImage bg;
PImage cursor;

ArrayList<Ripple> rs;


Capture video;
OpenCV opencv;
PImage canny;

boolean showBackground = true;
boolean showVideo = false;
ArrayList<Line> lines = new ArrayList<Line>();
ArrayList<Contour> coutoners = new ArrayList<Contour>();

int MAX_DETECTION =  1000;
int CAPTURE_EMMITION = 50;
int capture_count = 0;

int th1 =20, th2 = 75; // Cannyの閾値
int th=100, minLength=40, maxLineGap=5; // Hough変換のパラメータ


void setup() {
  //size(640, 480, P2D);
  fullScreen(P2D);
  //frameRate(15);
  video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  video.start();
  
  diagonal = sqrt(sq(width) + sq(height));
  shadowLen = 15;
  shadowLenR = shadowLen * 1.5;
  EIGHTH_PI = QUARTER_PI / 2;

  bg = loadImage("background.jpg");
  bg.resize(width, height);

  cursor = loadImage("cursor.png");

  fs = new FlockSystem();
  for (int i = 0; i < 5; i++) fs.addFlock();

  ss = new ShoeSystem();
  for (int i = 0; i < 4; i++) ss.addShoe(i);
}

void draw() {
  background(255);
  image(opencv.getOutput(), 0, 0, width * 2, height * 2);
  
  strokeWeight(3);
  int shnum = 1000;
  int i = 0;
  float[] xcen;
  float[] ycen;
  xcen = new float[shnum];
  ycen = new float[shnum];
  for (Line line : lines) {
    i++;
    stroke(40, 200, 50);
    line(width - line.start.x, line.start.y, width - line.end.x, line.end.y);
    xcen[i] = (line.start.x + line.end.x)/2;
    ycen[i] = (line.start.y + line.end.y)/2;
    stroke(200,40,50);
    point(xcen[i], ycen[i]);
    
    if(i > MAX_DETECTION) { 
      break;
    }
  }
  
  rs = new ArrayList<Ripple>();

  //background(200);
  if(showBackground) {
    background(bg);
  } 

  cursor(cursor);

  fs.run();
  ss.run();

  //for (Ripple r : rs) r.displayShadow();
  for (Ripple r : rs) r.display();
  
  int j = 0;
  for(Shoe s : ss.shoes){
    j ++;
    if (xcen[j]!=0){
      s.position.x =xcen[j];
    }
    if (ycen[j]!=0){
      s.position.y =ycen[j];
    }
  }
}

void keyPressed(){
  if (key == 'b') {
    showBackground = !showBackground;
  } else if (key == 'v') {
    showVideo = !showVideo;
  }
}


void mousePressed() {
  ss.mousePressed();
}

void mouseReleased() {
  ss.mouseReleased();
}

void captureEvent(Capture c) {
  c.read();
  capture_count++;
  if(capture_count % CAPTURE_EMMITION == 0) {
  opencv.loadImage(video);
  opencv.findCannyEdges(50, 200);
  canny = opencv.getSnapshot();
  
  opencv = new OpenCV(this, canny);
  lines = opencv.findLines(th, minLength, maxLineGap);
  }
}