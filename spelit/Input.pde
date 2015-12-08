// Syötteeseen liittyvät jutut tänne
String playerName = "";

void keyPressed() {
    switch (keyCode) {

    }
    if (programState == GlobalState.Setup && playerCount != 0 && tPlayers.size() < playerCount) {
        if (keyCode == ENTER) {
            tPlayers.add(playerName);
            playerName = "";
        } else if (keyCode == BACKSPACE) {
            playerName = playerName.substring(0, max(playerName.length() - 1, 0));
        } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
           playerName += key; 
        }
    } else if (calibrationState == 6) {
      switch(keyCode) {
        case ENTER:
             colCam.setBlobDetectionParameters(trackLight, trackingTreshold);
             calibrationState = 7;
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
                    game.gamePaused = false;
                    game.playTurn();
                } else {
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
                } else if (calibrationState == 3 || calibrationState == 4) { // save pin location
                    savePinLocation();
                    if (calibrationState == 4) {
                        calibratePinIndex += 1;
                        calibrationState = 3;
                    } else {
                        calibrationState = 4;
                    }
                    calibratePinManual = false;
                    
                } else if (calibrationState == 5) {
                     calibrationState = 6;
                }
            }
            break;
        case 'n':
            if (programState == GlobalState.Calibrating) {
                if (calibrationState == 1 || calibrationState == 2) { //switches the camera
                    calibrateCameraIndex = (calibrateCameraIndex + 1) % finalCaptures.size();
                    println("switched camera to " + calibrateCameraIndex);
                } else if (calibrationState == 3 || calibrationState == 4) { //set manual calibration of a pin true
                    calibratePinManual = true;
                } else if (calibrationState == 5) {
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
        if (calibrationState == 3 || calibrationState == 4) {
            calibratePinManualLocation[0] = mouseX;
            calibratePinManualLocation[1] = mouseY;
        }
    }
}