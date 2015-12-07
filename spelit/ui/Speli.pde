View[] views;
int currentView;
int prevView;

color bgColor;
color fontColor;

void setup() {
  size(1280, 720);

  basicSetup();
  createViews();
}

void basicSetup() {
  // Views setup
  currentView = 0;
  prevView = -1;
  views = new View[2];

  bgColor = color(140,221,225,1);
  fontColor = color(255,255,255,1);
}

void createViews() {
  // First view: start view with title
  views[0] = new View(0, bgColor, "SPEDEN", "SPELIT");
  views[1] = new View(1, bgColor, "title2", "subtitle2 jei");

}

void draw() {
  drawViews();
  listenKinect();
}

void drawViews() {

  // background
  background(views[1].clr);

  if (currentView == 0) {
    // texts
    PFont font1 = createFont("calibri.ttf", 120);
    textFont(font1);
    fill(255,255,255);
    text(views[0].title, 495, 325);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[0].text, 400, 600);
  }

  else if (currentView == 1) {

  }
}