// Pelaajien määrän ja nimien valitseminen tänne
// Game-luokalle annetaan ArrayList<String>, josta pelaaja-oliot luodaan

boolean setupDone = false;

// Use this as a regular draw until player setup is complete
void setupPlayersDraw() {
    if (playerCount != 0 && tPlayers.size() < playerCount) {
        background(75);
        fill(255);
        textSize(24);
        text("Enter name for player " + (tPlayers.size() + 1), 50, 50); 
        text(playerName, 50, 85); 
    } else if (playerCount != 0) {
        setupDone = true;
    } else {
        background(75);
        fill(255);
        textSize(24);
        text("Setting up players", 50, 50);
        text("Choose number of players (1-4)", 50, 85);
    }
}
