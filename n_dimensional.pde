////////// Declarations //////////
float delta; // delta = computed time in between frames (ensure that forces are per second, not per frame)
float t,pt;
float ground; // ground level

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

void checkKeys(Player p) {
    if (keyPressed) {
        p.keyMove(key);
    }
}


////////// Game Functions //////////

void setup() {
    size(1920,1080,P2D);
    initDelta();
    ground = height-500;
    

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
        p.updatePosition();
        p.drawPlayer();
    }
    
}
