View[] views;
int currentView;
int prevView;

color bgColor;
color fontColor;

CollisionCamera colCam;
FrontCamera frontCam;

void setup() {
  size(1280, 720);

  basicSetup();
  createViews();
}

void basicSetup() {
  // Views setup
  currentView = 0;
  prevView = -1;
  views = new View[7];

  bgColor = color(203,204,204,1);
  fontColor = color(255,255,255,1);
  
  // set cameras
  colCam = null;
  frontCam = null;
}

void createViews() {
  // calibration
  views[0] = new View(0, colCam, frontCam, "title", "subtitle", "other content");
  
  // start view
  views[1] = new View(1, bgColor, "SPEDEN", "SPELIT", "Paina ENTER jatkaaksesi");
  
  // add players
  views[2] = new View(2, bgColor, "Pelaajat", "Pelaajien määrä: ", "Pelaajien nimet: ");
  
  // game cam view
  views[4] = new View(4, bgColor, "Pelaaja: ", "Pisteet: ");
  
  // change player turns
  views[5] = new View(5, bgColor, "Vuoro vaihtuu", "Pelaaja: " + getCurrentPlayer());
  
  // game over (points and did the player win) + replay
  views[6] = new View(6, bgColor, "Peli päättyy", "Pelaaja" + getCurrentPlayer() + "voitti");
}

void draw() {
  drawViews();
}

void drawViews() {

  // background
  background(views[1].clr);
  
  if (currentView == 0) {
    // draw camera view for calibration
  }

  else if (currentView == 1) {
    // title bg
    noStroke();
    fill(229,0,0);
    rect(275,210,430,150);
    
    // texts
    PFont font1 = createFont("calibri.ttf", 120);
    textFont(font1);
    fill(255,255,255);
    text(views[1].title, 300, 325);
    PFont font2 = createFont("calibri.ttf", 120);
    textFont(font2);
    fill(0,205,0);
    text(views[1].title2, 550, 450);
    PFont font3 = createFont("calibri.ttf", 30);
    textFont(font3);
    fill(255,255,255);
    text(views[1].text, 475, 600);
  }

  else if (currentView == 2 || currentView == 3) {
    // texts
    PFont font1 = createFont("calibri.ttf", 40);
    textFont(font1);
    fill(255,255,255);
    text(views[2].title, 550, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[2].title2, 400, 250);
    if (currentView == 3) {
      PFont font3 = createFont("calibri.ttf", 30);
      textFont(font3);
      text(views[2].text, 400, 350);
    }
  }
  
  else if (currentView == 4) {
    // draw camera view for game
    
    // texts
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[4].title + getCurrentPlayer(), 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[4].title2 + getCurrentPoints(), 600, 100);
  }
  
  else if (currentView == 5) {
    // texts
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[5].title + getCurrentPlayer(), 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[5].title2 + getCurrentPoints(), 600, 100);
  }
  
  else if (currentView == 6) {
    // texts
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[6].title + getCurrentPlayer(), 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[6].title2 + getCurrentPoints(), 600, 100);
  }
}

String getCurrentPlayer() {
  // return the name of the current player
  return "PLR";
}

int getCurrentPoints() {
  // return the points of the current player
  return -1;
}

void keyPressed() {
  if (currentView == 0) {
    if (keyCode == ENTER) {
      currentView++;
    }
  }
  
  else if (currentView == 1) {
  //if (currentView < views.length - 1) {
    if (keyCode == ENTER) {
      currentView++;
    }
  }
  
  else if (currentView == 2) {
    switch (key) {
      case '1':
          if (programState == GlobalState.Setup) {
              playerCount = 1;
          }
          break;
      case '2':
          if (programState == GlobalState.Setup) {
              playerCount = 2;
          }
          break;
      case '3':
          if (programState == GlobalState.Setup) {
              playerCount = 3;
          }
          break;
      case '4':
          if (programState == GlobalState.Setup) {
              playerCount = 4;
          }
          break;
    }
  }
  
  else if (currentView == 3) {
    if (programState == GlobalState.Setup && playerCount != 0 && tPlayers.size() < playerCount) {
      String playerName = "";
      if (keyCode == ENTER) {
        tPlayers.add(playerName);
        playerName = "";
      }
      else if (keyCode == BACKSPACE) {
        playerName =  playerName.substring(0, max(playerName.length() - 1, 0));
      }
      else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
        playerName += key; 
      }
    }
  }
  
  else if (currentView == 4) {
    if (keyCode == ENTER) {
      currentView++;
    }
  }
  
  else if (currentView == 5) {
  if (keyCode == ENTER) {
      currentView++;
    }}
  
  else if (currentView == 6) {
    if (keyCode == ENTER) {
      currentView++;
    }
  }
  
}