// Pelilogiikka (pelaajat, vuorot, pisteet jne.) tänne

class Game {
    // Fields
    ArrayList<Player>   players;
    int                 turn;

    // Constructor
    Game(ArrayList<String> playerNames) {
        players = new ArrayList<Player>();

        for (int i = 0; i < playerNames.size(); ++i) {
            players.add( new Player(playerNames.get(i)) );
        }

        turn = 0;
    }


    // Methods
    Player getPlayerInTurn() {
        return players.get(turn);
    }

    // Main draw loop for the game
    void draw() {
        background(75);



        colCam.draw();
        colCam.detectCollision();

        fill(255);
        textSize(24);
        text("Playing...", 50, 50);
    }
}

class Player {
    // Fields
    String  name;
    int     points;

    // Constructor
    Player(String _name) {
        name = _name;
        points = 0;
    }

    // Methods
}

class Pin {
    PVector location;
    boolean hit;

    Pin(int x, int y) {
        location = new PVector(x, y);
        hit = false;
    }

    Pin(PVector loc) {
        location = loc;
        hit = false;
    }
}