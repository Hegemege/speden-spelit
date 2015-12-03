// Syötteeseen liittyvät jutut tänne

void keyPressed() {
    switch (keyCode) {

    }
    switch (key) {
        case ' ': // TODO: implement properly
            if (programState == GlobalState.Calibrating) {
                calibrationDone = true;
            } else if (programState == GlobalState.Setup) {
                setupDone = true;
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

                    calibrateCameraIndex = (calibrateCameraIndex + 1) % 2; //defaults to the other camera for the next one
                }
            }
            break;
        case 'n':
            if (programState == GlobalState.Calibrating) {
                if (calibrationState == 1 || calibrationState == 2) { //switches the camera
                    println("switched cameras");
                    calibrateCameraIndex = (calibrateCameraIndex + 1) % 2;
                }
            }
    }
}