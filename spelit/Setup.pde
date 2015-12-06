// Pelaajien määrän ja nimien valitseminen tänne
// Game-luokalle annetaan ArrayList<String>, josta pelaaja-oliot luodaan

boolean setupDone = false;


// Use this as a regular draw until player setup is complete
void setupPlayersDraw() {
    background(75);
    fill(255);
    textSize(24);
    text("Setting up players", 50, 50);
}