// Yläkameraan liittyvä koodi tänne

class CollisionCamera {
    Capture             camera;
    ArrayList<PVector>  pinLocations;
    int                 pinRadius;

    //detection code
    PImage              img;
    BlobDetection       blobDetection;

    // Constructor
    CollisionCamera(Capture _camera) {
        camera = _camera;
        pinLocations = new ArrayList<PVector>();
        img = new PImage(200, 150);
        blobDetection = new BlobDetection(img.width, img.height);

        blobDetection.setPosDiscrimination(true);
        blobDetection.setThreshold(0.8f); 
        blobDetection.setConstants(2, 4000, 500); //default values 1000, 4000, 500

        pinRadius = 30;
    }

    //Methods
    void draw() {
        if (camera.available()) {
            camera.read();
            computeBlobs();
        }

        //image(img, 0, 0, width, height);
        image(camera, 0, 0, width, height);
        
        

        //Draw other stuff on top of the feed

        //Draw debug info
        // TODO draw blobs
        if (debug) {
            for (int i = 0; i < pinLocations.size(); i++) {
                PVector pin = pinLocations.get(i);
                ellipseMode(CENTER);
                fill(0,0,0,0);
                stroke(255, 0, 0);
                ellipse(pin.x, pin.y, pinRadius, pinRadius);
            }
        }

    }
    
    void computeBlobs() {
        img.copy(camera, 0, 0, camera.width, camera.height, 
         0, 0, img.width, img.height);
        fastblur(img, 2);
        blobDetection.computeBlobs(img.pixels);
    }

    //return the index of the pin
    int detectCollision() {
        for (int n = 0; n < blobDetection.getBlobNb(); n++) {
            Blob b = blobDetection.getBlob(n);
            if (b!=null) {
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

                for (int i = 0; i < pinLocations.size(); i++) {
                    float radius =  pow(pinRadius + b.w/2*width, 2); //This simple radius only works with ellipse that is relatively close to a circle
                    float distance =  pow((b.x*width) - (pinLocations.get(i).x),2) + pow((b.y*height) - (pinLocations.get(i).y), 2);
                    if (distance <= radius) {
                        return i;
                    }
                }
            }
        }
        return -1;
    }
}
