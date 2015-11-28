//Tänne ohjelman alussa tapahtuva kalibrointi/kameroiden valinta (ei pelilogiikkaa)

boolean calibrationDone = false;


// Use this as a regular draw until calibration is complete
void calibrateDraw() {
    background(75);
    fill(255);
    textSize(24);
    text("Calibrating cameras", 50, 50);
}