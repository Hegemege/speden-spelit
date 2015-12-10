// Pelilogiikka (pelaajat, vuorot, pisteet jne.) tänne

class Game {
    // Fields
    ArrayList<Player>   players;
    int                 turn;
    boolean             gamePaused; 
    boolean             timeOver;
    int                 seconds;
    Timer               countdownTimer;
    boolean             playingSound;
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
    }
    
    void startCountdownTimer() {
      countdownTimer = new Timer();
      countdownTimer.schedule(new TimerTask() {
          @Override
          public void run() {
              if (seconds == 0) {
                if (!playingSound) {
                  timeOver = true;
                  loadSong("spelit.mp3");
                  playingSound = true;
                };
              } else if (!timeOver && !gamePaused) {
                  seconds -= 1;
              }
          }
        }, 1000, 1000);
    }
    
    public void loadSong(String songName)
{
    if (song != null) {
        song.close();
        minim.stop();
    } 
    if (!playingSound) {
        song = minim.loadFile(songName, 1024);
        song.play();
    }
}
    
    void playTurn() {
        seconds = 15;
        startCountdownTimer();
    }
    
    
    void changeTurn() {
      countdownTimer.cancel(); 
      playingSound = false;
      timeOver = false;
      turn = (turn + 1) % playerCount; 
      for (int i = 0; i < pins.size(); i++) {
        pins.get(i).hit = false;
      }
      if (turn == 0) {
         turnCount ++; 
      }
    }
    
    void newGame() {
       for (int i = 0; i < players.size(); i++) {
          players.get(i).points = 0;
          turnCount = 0;
          currentView = 5;
       }
    }
    
    String getCurrentPlayer() {
  // return the name of the current player
        return players.get(turn).name;
    } 
    
    String getTopPlayer() {
      String topPlayer = players.get(0).name;
      int maxPoints = players.get(0).points;
      for (int i = 0; i < players.size(); i++) {
          int currentPoints = players.get(i).points;
          if (currentPoints > maxPoints) {
             maxPoints =  currentPoints;
             topPlayer = players.get(i).name;
          }
      }
        return topPlayer;
    } 

    int getCurrentPoints() {
  // return the points of the current player
        return players.get(turn).points;
    }
    
    int getTimeLeft() {
        return seconds; 
    }

    // Methods
    Player getPlayerInTurn() {
        return players.get(turn);
    }

    // Main draw loop for the game
    void draw() {
        background(75);


        // Poll cameras

        colCam.poll();
        frontCam.poll();
        
        // Logic 
        Player p = getPlayerInTurn();
        
        colCam.poll();
        frontCam.poll();

        // Draw

        if (drawColCam) {
            colCam.draw();
        } else {
            frontCam.draw();
        }
        
        for (int i = 0; i < pins.size(); i++)  {
            if (!pins.get(i).hit) {
                float x = frontCam.pinLocations.get(i).x;
                float y = frontCam.pinLocations.get(i).y;
                image(pinImage, x - 22, y - 120);
            }
        }
        
        if(!gamePaused && !timeOver) {
            int collisionIndex = colCam.detectCollision();
            if (collisionIndex !=  - 1 && !pins.get(collisionIndex).hit) { 
                p.points += 1;
                pins.get(collisionIndex).hit = true;
            }
        } else if (!gamePaused) {
            //ran out of time, do something
        }

        if (gamePaused) {
            //draw some stuff
        }

        if (drawBlobOutline) {
            colCam.drawBlobs();
        }

       // fill(255);
       // textSize(24);
      /*if (!gamePaused) {
           text("Current player: " + p.name + "    Points: " + p.points + "    Time left: " + seconds, 50, 50);
        } else {
            text("Current player: " + p.name + "    Points: " + p.points, 50, 50);
        }*/
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