// Yläkameraan liittyvä koodi tänne

class CollisionCamera {
    //Fields
    Capture             camera;
    ArrayList<PVector>  pinLocations;
    boolean             calibrating;

    // Constructor
    CollisionCamera(Capture _camera) {
        camera = _camera;
        pinLocations = new ArrayList<PVector>();
        calibrating = false;
    }

    //Methods
}