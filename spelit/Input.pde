// Syötteeseen liittyvät jutut tänne
String playerName = "";

void keyPressed() {
    if (currentView == 1) {
        if (keyCode == ENTER) {
            currentView++;
          //  setupStarted = true; 
        }
    } else if (currentView == 2) {
      switch (key) {
      case '1':
          if (programState == GlobalState.Setup) {
              playerCount = 1;
              currentView++;
          }
          break;
      case '2':
          if (programState == GlobalState.Setup) {
              playerCount = 2;
              currentView++;
          }
          break;
      case '3':
          if (programState == GlobalState.Setup) {
              playerCount = 3;
              currentView++;
          }
          break;
      case '4':
          if (programState == GlobalState.Setup) {
              playerCount = 4;
              currentView++;
          }
          break;
      }
    } else if (currentView == 3) {
      if (programState == GlobalState.Setup && playerCount != 0 && tPlayers.size() < playerCount) {
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
      } else if (playerCount != 0 || skipPlayerSetup) {
        setupDone = true;
      }
    } else if (currentView == 7) {
        if (keyCode == ENTER) {
           game.newGame(); 
        } else if (key == ' ') {
          setupDone = false;
          programState = GlobalState.Setup;
          currentView = 1;
          playerCount = 0;
          turnCount = 0;
          for (int i = tPlayers.size() - 1; i >= 0; i--) {
              tPlayers.remove(i);
          }
        }
    } else if (calibrationState == 4) {
      switch(keyCode) {
        case ENTER:
             colCam.setBlobDetectionParameters(trackLight, trackingTreshold);
             calibrationState = 5;
             break;
        case UP:
             trackingTreshold += 0.1f;
             calibrateBlobDetection.setThreshold(trackingTreshold); 
             break;
        case DOWN:
             trackingTreshold -= 0.1f;
             calibrateBlobDetection.setThreshold(trackingTreshold); 
             break;
      }
    } else {
    switch (key) {
        case ' ': // TODO: implement properly
            if (programState == GlobalState.Calibrating) {
                //calibrationDone = true; // these skips are handled in booleans now (see spelit.pde)
            } else if (programState == GlobalState.Setup) {
                //setupDone = true; // these skips are handled in booleans now (see spelit.pde)
            } else if (programState == GlobalState.Playing) {
                if (game.gamePaused) {
                    currentView = 5;
                    game.gamePaused = false;
                    game.playTurn();
                } else {
                    currentView = 6;
                    game.gamePaused = true;
                    game.seconds = 15;
                    game.changeTurn();
                }
            }
            break;
        case 'y':
            if (programState == GlobalState.Calibrating) {
                if (calibrationState == 1 || calibrationState == 2) { //selecting a camera, y accepts
                    
                    if (calibrationState == 1) {
                        println("collision camera chosen");
                        colCam = new CollisionCamera(finalCaptures.get(calibrateCameraIndex));
                    } else {
                        println("front camera chosen");
                        frontCam = new FrontCamera(finalCaptures.get(calibrateCameraIndex));
                    }

                    calibrationState++;

                    calibrateCameraIndex = (calibrateCameraIndex + 1) % finalCaptures.size(); //defaults to the next camera
                } else if (calibrationState == 5 || calibrationState == 6) { // save pin location
                    savePinLocation();
                    if (calibrationState == 6) {
                        calibratePinIndex += 1;
                        calibrationState = 5;
                    } else {
                        calibrationState = 6;
                    }
                    calibratePinManual = false;
                    
                } else if (calibrationState == 3) {
                     calibrationState = 4;
                }
            }
            break;
        case 'n':
            if (programState == GlobalState.Calibrating) {
                if (calibrationState == 1 || calibrationState == 2) { //switches the camera
                    calibrateCameraIndex = (calibrateCameraIndex + 1) % finalCaptures.size();
                    println("switched camera to " + calibrateCameraIndex);
                } else if (calibrationState == 5 || calibrationState == 6) { //set manual calibration of a pin true
                    calibratePinManual = true;
                } else if (calibrationState == 3) {
                    if (trackLight) {
                        trackLight = false;
                        calibrateBlobDetection.setThreshold(0.2f); 
                        trackingTreshold = 0.2f;
                    } else {
                        trackLight = true;
                        calibrateBlobDetection.setThreshold(0.8f); 
                        trackingTreshold = 0.8f;
                    }
                    calibrateBlobDetection.setPosDiscrimination(trackLight);
                }
            }
            break;
        case 'm':
            if (programState == GlobalState.Calibrating) {
                if (calibrationState == 1 || calibrationState == 2) {
                    mirrored[calibrationState - 1] = !mirrored[calibrationState - 1];
                }
            }
            break;
        case 'a':
            if (programState == GlobalState.Playing) {
                drawDebugPins = !drawDebugPins;
            }
            break;
        case 's':
            if (programState == GlobalState.Playing) {
                drawColCam = !drawColCam;
            }
            break;
        case 'd':
            if (programState == GlobalState.Playing) {
                drawBlobOutline = !drawBlobOutline;
            }
            break;
    }
    }
}

void mousePressed() {
    if (programState == GlobalState.Calibrating) {
        if (calibrationState == 5 || calibrationState == 6) {
            calibratePinManualLocation[0] = mouseX;
            calibratePinManualLocation[1] = mouseY;
        }
    }
}