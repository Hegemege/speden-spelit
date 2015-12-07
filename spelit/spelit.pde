// Imports
import processing.video.*;
import java.util.*;
import blobDetection.*;

// Global variables
CollisionCamera colCam;
FrontCamera frontCam;
Game game;

GlobalState programState;

boolean debug = false;
boolean skipPinCalibration = false;
int pinCount = 5;
ArrayList<String> tPlayers = new ArrayList<String>();
int playerCount;

// Main functions

void setup() {
    programState = GlobalState.Initializing;

    // Initialize processing-specific things
    size(640, 480);

    // Other variables are initialized in calibrate() in Calibrate.pde
    // DEBUG: remove these when inter
    if (debug) {
        ArrayList<String> tPlayers = new ArrayList<String>();
        tPlayers.add("Player 1");
        tPlayers.add("Player 2");
        tPlayers.add("Player 3");
        tPlayers.add("Player 4");
        game = new Game(tPlayers);
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
