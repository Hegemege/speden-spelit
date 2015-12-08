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

        setupPlayersDraw(); 
        if (setupDone) {
            game = new Game(tPlayers);
            programState = GlobalState.Playing;
        }

    } else if (programState == GlobalState.Playing) {

        game.draw();

    }
}

void createViews() {
  // First view: start view with title
  views[0] = new View(0, colCam, frontCam, "title", "subtitle", "other content");
  
  // start view
  views[1] = new View(1, bgColor, "SPEDEN", "SPELIT", "Paina ENTER jatkaaksesi");
  
  // add players
  views[2] = new View(2, bgColor, "Pelaajat", "Pelaajien määrä: ", "Pelaajien nimet: ");
  
  // game cam view
  views[4] = new View(4, bgColor, "Pelaaja: ", "Pisteet: ", "Aikaa jäljellä: ");
  
  // change player turns
  views[5] = new View(5, bgColor, "Vuoro vaihtuu", "Pelaaja: ");
  
  // game over (points and did the player win) + replay
  views[6] = new View(6, bgColor, "Peli päättyy", "Pelaaja x voitti");
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
    text(views[0].title, 300, 325);
    PFont font2 = createFont("calibri.ttf", 120);
    textFont(font2);
    fill(0,205,0);
    text(views[0].title2, 550, 450);
    PFont font3 = createFont("calibri.ttf", 30);
    textFont(font3);
    fill(255,255,255);
    text(views[0].text, 475, 600);
  }

  else if (currentView == 2 || currentView == 3) {
    // texts
    PFont font1 = createFont("calibri.ttf", 40);
    textFont(font1);
    fill(255,255,255);
    text(views[1].title, 550, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[1].title2, 400, 250);
    if (currentView == 3) {
      PFont font3 = createFont("calibri.ttf", 30);
      textFont(font3);
      text(views[1].text, 400, 350);
    }
  }
  
  else if (currentView == 4) {
    // draw camera view for game
    
    // texts
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    fill(255,255,255);
    text(views[3].title + getCurrentPlayer(), 250, 100);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[3].title2 + getCurrentPoints(), 600, 100);
     if (!gamePaused) {
       PFont font3 = createFont("calibri.ttf", 30);
       textFont(font2);
       text(views[3].title3 + getCurrentPoints(), 600, 100);
       Time left: " + seconds
     }
  }
}