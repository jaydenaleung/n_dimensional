////////// Declarations //////////
float delta; // delta = computed time in between frames (ensure that forces are per second, not per frame)
float t,pt;
float ground; // ground level
boolean moving = false;

enum PlayerType { PRIMARY, SECONDARY }


////////// Instances //////////
Player pp = new Player(PlayerType.PRIMARY);
Player ps = new Player(PlayerType.SECONDARY);
Player[] players = {pp,ps};

Attack spikes = new Attack("spikes", "FIRST", 1);
Attack[] attacks = {spikes};

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


////////// Game Functions //////////

void setup() {
    size(400,400,P2D);
    initDelta();
    ground = height-100;

    for (Player p : players) {
        p.shape = p.renderShape();
    }
}

void draw() {
    background(0);

    updateDelta();

    // Looping over all players
    for (Player p : players) {
        // Physics
        p.updateFlags();
        checkKeys(p);
        p.gravity();
        p.friction();
        p.updateVelocity();
        p.updatePosition();

        // Moves
        p.keywordAttack();

        // Rendering
        p.drawPlayer();
        p.drawKeyword();
        // printChecks(p);
    }
    
}
