//Tänne ohjelman alussa tapahtuva kalibrointi/kameroiden valinta (ei pelilogiikkaa)

// Näppäimet: 
//      y       Hyväksy kamera
//      n       Vaihda kamera

boolean calibrationDone = false;

int calibrationState = 0;   
/* 
0 = polling cameras
1 = selecting Collision camera
2 = selecting front camera
3 = calibrating Collision camera
4 = calibrating front camera
5 = done
*/

ArrayList<Capture> finalCaptures = new ArrayList<Capture>();
int calibrateCameraIndex = 0;
int calibratePinIndex = 1;
int[] calibratePinLocation = {0, 0}; //this is updated from the input of camera
boolean calibratePinManual = false;
int[] calibratePinManualLocation = {0, 0}; //mouse x/y is stored here when clicked
boolean trackLight;

//Blob detection
PImage calibrateImg = new PImage(200, 150);
BlobDetection calibrateBlobDetection = new BlobDetection(calibrateImg.width, calibrateImg.height);

// Use this as a regular draw until calibration is complete
void calibrateDraw() {
    background(75);

    if (calibratePinIndex > pinCount) {
        calibrationState = 5;
    }

    if (calibrationState == 0) {
        finalCaptures = getCameras();
        calibrationState = 1;

        //Setup blob detection
        calibrateBlobDetection.setPosDiscrimination(true);
        calibrateBlobDetection.setConstants(2, 4000, 500); //default values 1000, 4000, 500
        calibrateBlobDetection.setThreshold(0.8f); 

    } else if (calibrationState == 1) {
        if (finalCaptures.get(calibrateCameraIndex).available()) {
            finalCaptures.get(calibrateCameraIndex).read();
        }
        image(finalCaptures.get(calibrateCameraIndex), 0, 0, width, height);
        fill(255);
        stroke(0);
        textSize(24);
        text("Collision camera - y/n?", 20, 50);

    } else if (calibrationState == 2) {
        if (finalCaptures.get(calibrateCameraIndex).available()) {
            finalCaptures.get(calibrateCameraIndex).read();
        }
        image(finalCaptures.get(calibrateCameraIndex), 0, 0, width, height);
        fill(255);
        stroke(0);
        textSize(24);
        text("Front camera - y/n?", 20, 50);

    } else if (calibrationState == 3) {

        if (skipPinCalibration) { //skip pin calibration - use hardcoded values
            for (int i = 0; i < pinCount; i++) {
                PVector loc = new PVector(100 + 50*i, 100);
                colCam.pinLocations.add(loc);
                pins.add(new Pin(loc));
                PVector floc = new PVector(100 + 50*i, height - 100);
                frontCam.pinLocations.add(floc);
            }
            calibrationState = 5;
            return;
        }

        //col camera pin calibration
        if (colCam.camera.available()) {
            colCam.camera.read();
            calibrateComputeBlobs(colCam.camera);
        }
        image(colCam.camera, 0, 0, width, height);

        fill(255);
        stroke(0);
        textSize(24);
        text("Collision camera - Pin " + Integer.toString(calibratePinIndex) + " - y/n?", 20, 50);
        if (calibratePinManual) {
            textSize(18);
            text("Manual calibration: click on the center of the pin and press y", 20, 80);
        }
    } else if (calibrationState == 4) {
        //front camera pin calibration
        if (frontCam.camera.available()) {
            frontCam.camera.read();
            calibrateComputeBlobs(frontCam.camera);
        }
        image(frontCam.camera, 0, 0, width, height);

        fill(255);
        stroke(0);
        textSize(24);
        text("Front camera - Pin " + Integer.toString(calibratePinIndex) + " - y/n?", 20, 50);
        if (calibratePinManual) {
            textSize(18);
            text("Manual calibration: click on the center of the pin and press y", 20, 80);
        }
    } else if (calibrationState == 5) {
       if (colCam.camera.available()) {
            colCam.camera.read();
            calibrateComputeBlobs(colCam.camera);
        }
        image(colCam.camera, 0, 0, width, height);

        fill(255);
        stroke(0);
        textSize(24);
            text("Switch between tracking light and dark objects", 20, 50);
            text("Press n to switch and y to accept current tracking", 20, 85);
            drawBlobs();
    } else if (calibrationState == 6) {
        println("calibration done");
        programState = GlobalState.Setup;
    }

    //common to 3 and 4
    if (calibrationState == 3 || calibrationState == 4) {
        //analyse camera input for blobs
        //analyseCamera will update calibrationPinLocation array
        analyseCamera();
        //draw lines indicating current pin location
        int x, y;
        if (calibratePinManual) {
            x = calibratePinManualLocation[0];
            y = calibratePinManualLocation[1];
        } else {
            x = calibratePinLocation[0];
            y = calibratePinLocation[1];
        }
        stroke(0, 255, 0);
        line(0, y, width, y);
        line(x, 0, x, height);
    }
    //TODO
    
    //fill(255);
    //textSize(12);
    //text("Calibrating cameras", 24, 24);
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
          if(!cameras[i].contains("USB")) {
            camResults.add( new CameraResult(cameras[i]) );
          }
        }
    }

    //Go through the camera results, pick two different cameras with the largest resolution at fps=30 or more

    ArrayList<ArrayList<CameraResult>> candidates = new ArrayList<ArrayList<CameraResult>>();

    for (int i = 0; i < camResults.size(); i++) {
        if (camResults.get(i).camFPS >= 30) { // we use only 30fps or higher capture devices for best input
            // find if a camera type already exists in the candidates, else, add new sublist
            boolean added = false;
            for (int k = 0; k < candidates.size(); k++) {
                ArrayList<CameraResult> candlist = candidates.get(k);
                if (camResults.get(i).camName.equals(candlist.get(0).camName)) {
                    candlist.add(camResults.get(i));
                    added = true;
                    break;
                }
            }
            if (!added) {
                ArrayList<CameraResult> candidates_sublist = new ArrayList<CameraResult>();
                candidates_sublist.add(camResults.get(i));
                candidates.add(candidates_sublist);
            }
        }
    }

    //Pick top resolution camera from each candidate sublist
    ArrayList<CameraResult> toplist = new ArrayList<CameraResult>();
    for (int i = 0; i < candidates.size(); i++) {
        toplist.add(candidates.get(i).get(0));
    }

    for (int i = 0; i < candidates.size(); i++) {
        for (int j = 0; j < candidates.get(i).size(); j++) {
            CameraResult camres = candidates.get(i).get(j);
            if (camres.getRes() > toplist.get(i).getRes()) {
                toplist.set(i, camres);
            }
        }
    }

    println("Chose top cameras:");
    for (int i = 0; i < toplist.size(); i++) {
        println(toplist.get(i).rawstr);
    }

    for (int i = 0; i < toplist.size(); i++) {
        Capture cap = new Capture(this, toplist.get(i).rawstr);
        cap.start();
        finalCameras.add(cap);
    }

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

void analyseCamera() {
    Blob bigBlob = null;
    for (int n = 0; n < calibrateBlobDetection.getBlobNb(); n++) {
        Blob b = calibrateBlobDetection.getBlob(n);
        if (b != null) {
            if (debug) {
                ellipseMode(CORNER);
                strokeWeight(1); //For debugging purposes
                fill(0,0,0,0);
                stroke(0,0,255); 
                ellipse(
                b.xMin*width,b.yMin*height,
                b.w*width,b.h*height
                );
            }

            //TODO: tähän blobin sanity checkausta, esim jättimäiset blobit voi skipata

            //valitaan isoin blobi keilaksi
            if (bigBlob == null) {
                bigBlob = b;
            } else if (b.w*b.h > bigBlob.w*bigBlob.h) {
                bigBlob = b;
            }
        }
    }
    if (bigBlob != null) {
        calibratePinLocation[0] = Math.round(bigBlob.xMin*width + bigBlob.w*width/2);
        calibratePinLocation[1] = Math.round(bigBlob.yMin*height + bigBlob.h*height/2);
    }
}

void savePinLocation() {
    if (calibratePinManual) {
        if (calibrationState == 3) { // colCam
            colCam.pinLocations.add(new PVector(calibratePinManualLocation[0], calibratePinManualLocation[1]));
            pins.add(new Pin(new PVector(calibratePinManualLocation[0], calibratePinManualLocation[1])));
        } else if (calibrationState == 4) { // frontCam
            frontCam.pinLocations.add(new PVector(calibratePinManualLocation[0], calibratePinManualLocation[1]));
        }
    } else {
        if (calibrationState == 3) { // colCam
            colCam.pinLocations.add(new PVector(calibratePinLocation[0], calibratePinLocation[1]));
            pins.add(new Pin(new PVector(calibratePinManualLocation[0], calibratePinManualLocation[1])));
        } else if (calibrationState == 4) { // frontCam
            frontCam.pinLocations.add(new PVector(calibratePinLocation[0], calibratePinLocation[1]));
        }
    }
}

void calibrateComputeBlobs(Capture camera) {
    calibrateImg.copy(camera, 0, 0, camera.width, camera.height, 
     0, 0, calibrateImg.width, calibrateImg.height);
    fastblur(calibrateImg, 2);
    calibrateBlobDetection.computeBlobs(calibrateImg.pixels);
}

void drawBlobs() {
  for (int n = 0; n < calibrateBlobDetection.getBlobNb(); n++) {
    Blob b = calibrateBlobDetection.getBlob(n);
    if (b!=null) {
      ellipseMode(CORNER);
      strokeWeight(10);
      fill(0,0,0,0);
      stroke(255,255,255); 
      ellipse(
      b.xMin*width,b.yMin*height,
      b.w*width,b.h*height
      );
    }
  }
}