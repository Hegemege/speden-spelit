//Tänne ohjelman alussa tapahtuva kalibrointi/kameroiden valinta (ei pelilogiikkaa)

// Näppäimet: 
//      y       Hyväksy kamera
//      n       Vaihda kamera

boolean calibrationDone = false;

int calibrationState = 0;   // 0 = polling cameras
                            // 1 = selecting collision camera
                            // 2 = selecting top camera
                            // 3 = calibrating collision camera
                            // 4 = calibrating top camera
                            // 5 = done

ArrayList<Capture> finalCaptures = new ArrayList<Capture>();
int calibrateCameraIndex = 0;

// Use this as a regular draw until calibration is complete
void calibrateDraw() {
    background(75);

    if (calibrationState == 0) {
        finalCaptures = getCameras();
        calibrationState = 1;
    } else if (calibrationState == 1) {
        if (finalCaptures.get(calibrateCameraIndex).available()) {
            finalCaptures.get(calibrateCameraIndex).read();
        }
        image(finalCaptures.get(calibrateCameraIndex), 0, 0, width, height);
        fill(255);
        stroke(0);
        textSize(24);
        text("Collision camera - y/n?", 50, 100);
    } else if (calibrationState == 2) {
        if (finalCaptures.get(calibrateCameraIndex).available()) {
            finalCaptures.get(calibrateCameraIndex).read();
        }
        image(finalCaptures.get(calibrateCameraIndex), 0, 0, width, height);
        fill(255);
        stroke(0);
        textSize(24);
        text("Top camera - y/n?", 50, 100);
    }
    //TODO
    
    fill(255);
    textSize(12);
    text("Calibrating cameras", 24, 24);
}

ArrayList<Capture> getCameras() {
    String[] cameras = Capture.list();
    ArrayList<CameraResult> camResults = new ArrayList<CameraResult>();
    ArrayList<Capture> finalCameras = new ArrayList<Capture>();

    if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
    } else {
        
        for (int i = 0; i < cameras.length; i++) {
            println(cameras[i]);
            /*if (cameras[i].split(",").length != 3) {
                continue;
            }*/
            camResults.add( new CameraResult(cameras[i]) );
        }
    }

    //Go through the camera results, pick two different cameras with the largest resolution at fps=30 or more

    ArrayList<CameraResult> candidates_cam1 = new ArrayList<CameraResult>();
    ArrayList<CameraResult> candidates_cam2 = new ArrayList<CameraResult>();

    String camName1 = camResults.get(0).camName;

    for (int i = 0; i < camResults.size(); i++) {
        if (camResults.get(i).camFPS >= 30) {
            if (camResults.get(i).camName.equals(camName1)) {
                candidates_cam1.add(camResults.get(i));
            } else {
                candidates_cam2.add(camResults.get(i));
            }
            
        }
    }

    //Pick top resolution camera from both candidate lists

    CameraResult top1 = candidates_cam1.get(0);
    CameraResult top2 = candidates_cam1.get(0); // TODO: REPLACE WITH CAM2 WHEN USING TWO CAMERAS

    for (int i = 0; i < candidates_cam1.size(); i++) {
        if (candidates_cam1.get(i).getRes() > top1.getRes()) {
            top1 = candidates_cam1.get(i);
        }
    }

    //TODO: REMOVE COMMENT WHEN USING TWO CAMERAS
    /*for (int i = 0; i < candidates_cam2.size(); i++) {
        if (candidates_cam2.get(i).getRes() > top2.getRes()) {
            top2 = candidates_cam2.get(i);
        }
    }

    println("Chose two cameras:");
    println(top1.rawstr);
    println(top2.rawstr);*/

    Capture cap1 = new Capture(this, top1.rawstr);
    Capture cap2 = new Capture(this, top1.rawstr); // TODO: REPLACE WITH TOP2 WHEN USING TWO CAMERAS

    cap1.start();
    cap2.start();

    finalCameras.add(cap1);
    finalCameras.add(cap2);

    return finalCameras;
}

class CameraResult {
    String camName;
    int camWidth;
    int camHeight;
    int camFPS;
    String rawstr;

    CameraResult(String camerastr) {
        String[] camInfo = camerastr.split(",");

        if (camInfo.length == 3) {
            camName = camInfo[0].substring(5);
            String[] dims = camInfo[1].substring(5).split("x");
            camWidth = Integer.parseInt(dims[0]);
            camHeight = Integer.parseInt(dims[1]);
            camFPS = Integer.parseInt(camInfo[2].substring(4));
            rawstr = camerastr;
        } else { // only for debugging, proper webcams go ^
            camName = camerastr.substring(5);
            rawstr = camerastr;
            camWidth = 1280;
            camHeight = 720;
            camFPS = 30;
        }

    }

    int getRes() {
        return camWidth * camHeight;
    }
}