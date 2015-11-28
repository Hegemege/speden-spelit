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
}