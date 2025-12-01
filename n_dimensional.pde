////////// Declarations //////////
float delta; // delta = computed time in between frames (ensure that forces are per second, not per frame)
float t,pt;
float ground; // ground level
boolean moving = false;

enum PlayerType { PRIMARY, SECONDARY }


////////// Instances //////////
Player pp = new Player(PlayerType.PRIMARY);
Player ps = new Player(PlayerType.SECONDARY);
Player[] players = {pp};


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
    println("delta: " + delta);
}

void checkKeys(Player p) { // feeder function into p.keyMove()
    if (keyPressed) {
        p.keyMove(key);
    }
}

void keyReleased() {
    moving = false;
}

void printChecks(Player p) { // activate when you want to print things
    println("v_e.x: " + p.v_e.x);
    println("v_t.x: " + p.v_t.x);
}


////////// Game Functions //////////

void setup() {
    size(400,400,P2D);
    initDelta();
    ground = height-100;
}

void draw() {
    background(0);

    updateDelta();

    // Looping over all players
    for (Player p : players) {
        p.updateFlags();
        checkKeys(p);
        p.gravity();
        p.friction();
        p.updateVelocity();
        p.updatePosition();
        p.drawPlayer();
        printChecks(p);
    }
    
}
