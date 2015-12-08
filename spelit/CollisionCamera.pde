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
        blobDetection.setConstants(20, 4000, 500); //default values 1000, 4000, 500

        pinRadius = 30;
    }
    
    void setBlobDetectionParameters(boolean light, float threshold) {
        blobDetection.setPosDiscrimination(light);
        blobDetection.setThreshold(threshold); 
    }

    //Methods
    void draw() {
        //image(img, 0, 0, width, height); //draws the blurred image
        pushMatrix();
        if (mirrored[0]) {
            scale(-1, 1);
            translate(-width, 0);
        }
        image(camera, 0, 0, width, height);
        popMatrix();
        
        //Draw other stuff on top of the feed

        //Draw pins
        if (drawDebugPins) {
            for (int i = 0; i < pinLocations.size(); i++) {
               if (!pins.get(i).hit) {
                   PVector pin = pinLocations.get(i);
                   ellipseMode(CENTER);
                   fill(255, 255, 255, 70);
                   stroke(255, 0, 0);
                   ellipse(pin.x, pin.y, pinRadius, pinRadius);
               }
            }
        }

    }

    void poll() {
        if (camera.available()) {
            camera.read();
            computeBlobs();
        }
    }
    
    void computeBlobs() {
        if (mirrored[0]) {
            PImage timg = new PImage(camera.width, camera.height);
            camera.loadPixels();
            timg.loadPixels();
            for (int y = 0; y < camera.height; y++) {
                for (int x = 0; x < camera.width; x++) {
                    timg.pixels[(camera.width - x - 1) + y*camera.width] = camera.pixels[y*camera.width+x];
                }
            }
            timg.updatePixels(); 
            img.copy(timg, 0, 0, timg.width, timg.height, 
         0, 0, img.width, img.height);
        } else {
            img.copy(camera, 0, 0, camera.width, camera.height, 
         0, 0, img.width, img.height);
        }
        fastblur(img, 2);
        blobDetection.computeBlobs(img.pixels);
    }

    //return the index of the pin
    int detectCollision() {
        for (int n = 0; n < blobDetection.getBlobNb(); n++) {
            Blob b = blobDetection.getBlob(n);
            if (b!=null) {
                //TODO: tähän blobin sanity checkausta, esim jättimäiset blobit voi skipata

                for (int i = 0; i < pinLocations.size(); i++) {
                    float radius =  pinRadius + b.w/2*width; //This simple radius only works with ellipse that is relatively close to a circle
                    float distance =  pow(pow((b.x*width) - (pinLocations.get(i).x),2) + pow((b.y*height) - (pinLocations.get(i).y), 2), 0.5);
                    if (distance <= radius) {
                        return i;
                    }
                }
            }
        }
        return -1;
    }

    void drawBlobs() {
        for (int n = 0; n < blobDetection.getBlobNb(); n++) {
            Blob b = blobDetection.getBlob(n);
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
                //TODO: tähän blobin sanity checkausta, esim jättimäiset blobit voi skipata
            
        }
    }

}