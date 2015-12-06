// Etukameraan liittyvä koodi tänne

class FrontCamera {
    //Fields
    Capture             camera;
    ArrayList<PVector>  pinLocations;
    boolean             calibrating;

    // Constructor
    FrontCamera(Capture _camera) {
        camera = _camera;
        pinLocations = new ArrayList<PVector>();
        calibrating = false;
    }

    //Methods
    void draw() {
        if (camera.available()) {
            camera.read();
        }
        image(camera, 0, 0, width, height);

        //Draw other stuff on top of the feed

        //Draw the pins
        //TODO
    }
}