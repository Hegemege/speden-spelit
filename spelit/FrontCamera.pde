// Etukameraan liittyvä koodi tänne

class FrontCamera {
    //Fields
    Capture             camera;
    ArrayList<PVector>  pinLocations;
    int                 pinRadius;

    // Constructor
    FrontCamera(Capture _camera) {
        camera = _camera;
        pinLocations = new ArrayList<PVector>();
        pinRadius = 30;
    }

    //Methods
    void draw() {
        image(camera, 0, 0, width, height);

        //Draw pins - debug
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
        }
    }
}