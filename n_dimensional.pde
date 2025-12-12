////////// Variables //////////
float delta; // delta = computed time in between frames (ensure that forces are per second, not per frame)
float t,pt;
float ground; // ground level

boolean moving = false;
boolean gameOver = false;

int winner; // 1 is player 1, 2 is player 2

enum PlayerType { PRIMARY, SECONDARY }


////////// Instances //////////
Player pp = new Player(PlayerType.PRIMARY);
Player ps = new Player(PlayerType.SECONDARY);
Player[] players = {pp,ps};

// list of attacks
Attack spikes = new Attack("spikes", "GOLEM");
Attack[] attacks = {spikes};
ArrayList ongoingAttacks = new ArrayList();

////////// Functions //////////

void initDelta() {
    t = millis() / 1000.0; // initial
    pt = t; // initial
    delta = 0; // initial
}

void updateDelta() { // run this before running player methods
    pt = t;
    t = millis() / 1000.0;
    delta = t - pt;
}

void checkKeys(Player p) { // feeder function into p.keyMove()
    if (keyPressed) {
        p.keyMove(key);
    }
}

void printChecks(Player p) { // activate when you want to print things
    println("v_e.x: " + p.v_e.x);
    println("v_t.x: " + p.v_t.x);
}

void checkGameOver(Player p) {
    if (p.sides < 3) {
        gameOver = true; // set gameOver to true

        for (Player plyr : players) { // identify winner's number (player 1 or player 2)
            if (plyr != p) { // then plyr is the winner
                for (int i = 0; i < players.length; i++) {
                    if (players[i] == plyr) {
                        winner = i+1; // winner's number
                    }
                }
            }
        }
    }
}


////////// Watcher Functions //////////

void mouseClicked() { // test
    pp.sides++;
}

void keyPressed() {
    for (Player p : players) {
        if (p.query.length() < 5 && key != 'w' && key != 'a' && key != 's' && key != 'd') { // limited to 5 letter keywords w/o WASD & arrow keys
            if (keyCode == ENTER) {
                p.query = "";
            } else {
                p.query += key;
            }
        }
    }
}

void keyReleased() {
    moving = false;
}


////////// Attack Functions //////////

void attack(int index, Player p, Player o) {
    attacks[index].attack(p,o);
}


////////// Game Functions //////////

void setup() {
    size(1000,1000,P2D);
    initDelta();
    ground = height-100;

    for (Player p : players) {
        p.shape = p.renderShape();
    }
}

void draw() {
    if (!gameOver) { // regular game loop
        background(0);

        updateDelta();

        // Looping over all players
        for (Player p : players) {
            // Checks & Flags & Updates
            p.updateFlags();
            checkKeys(p);

            // Physics
            p.gravity();
            p.friction();
            p.updateVelocity();
            p.updatePosition();

            // Moves
            p.keywordAttack(); // initial attack and adds it to the ongoingAttacks array
            p.stepAttacks(); // continue any attacks in the ongoingAttacks array

            // Rendering
            p.drawPlayer();
            p.drawKeyword();

            // Late Checks
            checkGameOver(p);
            // printChecks(p);
        }
    } else { // blank screen with "Game Over!" and player who won
        background(0);
        text("Game Over!", width/2, height/2 - 25);
        text("Winner: Player " + winner + "!", width/2, height/2 + 25);
    }
}
