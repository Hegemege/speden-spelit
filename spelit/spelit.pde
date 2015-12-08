// Imports
import processing.video.*;
import java.util.*;
import blobDetection.*;
import java.util.Timer;
import java.util.TimerTask;
// Global variables
CollisionCamera colCam;
FrontCamera frontCam;
Game game;

GlobalState programState;

boolean debug = true;
boolean skipPinCalibration = false;
boolean skipPlayerSetup = false;
boolean drawColCam = false;
boolean drawBlobOutline = true;
boolean drawDebugPins = true;
int pinCount = 5;
ArrayList<String> tPlayers = new ArrayList<String>();
ArrayList<Pin> pins = new ArrayList<Pin>();
int playerCount;
int maxTurns = 2;
int turnCount = 0;
View[] views;
int currentView;
int prevView;
color bgColor;
color fontColor;

// Main functions

void setup() {
    programState = GlobalState.Initializing;
   // fullScreen();
    // Initialize processing-specific things
    size(1280, 720);
    // Other variables are initialized in calibrate() in Calibrate.pde
    if (skipPlayerSetup) {
        tPlayers.add("Player 1");
        tPlayers.add("Player 2");
        tPlayers.add("Player 3");
        tPlayers.add("Player 4");
    }
    basicSetup();
    createStartViews();
}

void basicSetup() {
  // Views setup
  currentView = 0;
  prevView = -1;
  views = new View[8];

  bgColor = color(203,204,204,1);
  fontColor = color(255,255,255,1);
  
  // set cameras
  colCam = null;
  frontCam = null;
}

void draw() {
    if (programState == GlobalState.Initializing) {
        programState = GlobalState.Calibrating;
    } else if (programState == GlobalState.Calibrating) {

        calibrateDraw();
        if (calibrationDone) {
            programState = GlobalState.Setup;
        }

    } else if (programState == GlobalState.Setup) {
        if (currentView == 0) {
           currentView = 1;
        }
        //setupPlayersDraw(); 
        drawViews();
        if (setupDone) {
            game = new Game(tPlayers);
            createPlayViews();
            currentView = 5;
            programState = GlobalState.Playing;
        }

    } else if (programState == GlobalState.Playing) {
        if (turnCount == maxTurns) {
            currentView = 7;
        }
        drawViews();
        //game.draw();

    }
}

void createStartViews() {
  // calibration
  views[0] = new View(0, colCam, frontCam, "Kameroiden kalibrointi", "subtitle", "other content");
  
  // start view
  views[1] = new View(1, bgColor, "SPEDEN", "SPELIT", "Paina ENTER jatkaaksesi");
  
  // add players
  views[2] = new View(2, bgColor, "Pelaajat", "Pelaajien määrä: ", "Pelaajien nimet: ");
  
  // game begins, which player has their turn
}

void createPlayViews() {
  views[4] = new View(4, bgColor, "Peli alkaa", "Pelaaja: " + game.getCurrentPlayer());
  
  // game cam view
  views[5] = new View(5, bgColor, "Pelaaja: ", "Pisteet: ", "Aikaa jäljellä: ");
  
  // change player turns
  views[6] = new View(6, bgColor, "Vuoro vaihtuu ", "Pelaaja: ");
  
  // game over (points and did the player win) + replay
  views[7] = new View(7, bgColor, "Peli päättyy", "Pelaaja ", "Pisteillä ");
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
    if (playerCount > 0) {
        text(playerCount, 650, 250);
    }
    if (currentView == 3) {
      PFont font3 = createFont("calibri.ttf", 30);
      textFont(font3);
      text(views[2].text, 400, 350);
      int helpIndex = 0;
      for (int i = 0; i < playerCount; i++) {
        PFont font4 = createFont("calibri.ttf", 30);
        textFont(font4);
        text("Pelaaja " + (i+1) + ":", 400, 400+(i*50));
        if (tPlayers.size() > i) {
            text(tPlayers.get(i), 650, 400+(i*50));
        } else if (tPlayers.size() == i){
            text(playerName, 650, 400+(i*50));
        }
      }
    }
  }
  
  else if (currentView == 4) {
    
  }
  
  else if (currentView == 5) {
    // draw camera view for game
    game.draw();
    // texts
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[5].title + game.getCurrentPlayer(), 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[5].title2 + game.getCurrentPoints(), 600, 100);
    if (!game.gamePaused) {
        PFont font3 = createFont("calibri.ttf", 30);
        textFont(font3);
        text(views[5].text+ game.getTimeLeft(), 250, 150);
    }
  }
  
  else if (currentView == 6) {
    // texts
    game.draw();
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[6].title, 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[6].title2 + game.getCurrentPlayer(), 600, 100);
  }
  
  else if (currentView == 7) {
    // texts
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[7].title, 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[7].title2 + game.getTopPlayer() +  " voitti", 400, 100);
    PFont font3 = createFont("calibri.ttf", 30);
    textFont(font3);
    text(views[7].text + game.getCurrentPoints(), 600, 100);
  }
}