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
    }
}