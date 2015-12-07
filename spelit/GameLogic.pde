// Pelilogiikka (pelaajat, vuorot, pisteet jne.) tänne

class Game {
    // Fields
    ArrayList<Player>   players;
    int                 turn;
    boolean             gamePaused; 
    boolean             timeOver;
    int                 seconds;

    // Constructor
    Game(ArrayList<String> playerNames) {
        players = new ArrayList<Player>();

        for (int i = 0; i < playerNames.size(); ++i) {
            players.add( new Player(playerNames.get(i)) );
        }

        turn = 0;
        gamePaused = true;
        timeOver = false;
        seconds = 15;
        initiliazeCountdownTimer();
    }
    
    void initiliazeCountdownTimer() {
      Timer countdownTimer = new Timer();
      countdownTimer.schedule(new TimerTask() {
          @Override
          public void run() {
              if (!timeOver && !gamePaused) {
                  seconds -= 1;
              }
          }
        }, 0, 1000);
    }
    
    void playTurn() {
        Timer turnTimer = new Timer();
        turnTimer.schedule(new TimerTask() {
            @Override
            public void run() {
                timeOver = true;
            }
        }, 15000);
        if (timeOver) {
            turnTimer.cancel();
        }
    }
    
    
    void changeTurn() {
      timeOver = false;
      turn = (turn + 1) % playerCount; 
      for (int i = 0; i < pins.size(); i++) {
        pins.get(i).hit = false;
      }
    }

    // Methods
    Player getPlayerInTurn() {
        return players.get(turn);
    }

    // Main draw loop for the game
    void draw() {
        background(75);
        
        
        Player p = getPlayerInTurn();
        colCam.draw();
        if(!gamePaused && !timeOver) {
            int collisionIndex = colCam.detectCollision();
            if (collisionIndex !=  - 1 && !pins.get(collisionIndex).hit) { 
                p.points += 1;
                pins.get(collisionIndex).hit = true;
            }
        }
        fill(255);
        textSize(24);
        if (!gamePaused) {
           text("Current player: " + p.name + "    Points: " + p.points + "    Time left: " + seconds, 50, 50);
        } else {
            text("Current player: " + p.name + "    Points: " + p.points, 50, 50);
        }
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
