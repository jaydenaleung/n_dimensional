float delta; // delta = computed time in between frames (ensure that forces are per second, not per frame)
float t,pt;
float ground; // ground level

class Move {

}

enum PlayerType { PRIMARY, SECONDARY }

class Player {
    PVector pos;
    PVector vel;
    Move[] moves;
    int hp;
    int sides;
    PlayerType type;
    PShape shape;

    Player(PlayerType type) {
        type = type;

        sides = 100;

        pos = new PVector(100,100);
        vel = new PVector(0,0);
    }
}

Player pp = new Player(PlayerType.PRIMARY);
Player ps = new Player(PlayerType.SECONDARY);
Player[] players = {pp,ps};


void updateDelta() { // run this before running player methods
    pt = t;
    t = millis() / 1000.0;
    delta = t - pt;
}

void setup() {
    size(1920,1080,P2D);

    t = millis() / 1000.0; // initial
    pt = t; // initial
    delta = 0; // initial
    ground = height-500;
    pp.shape = createShape(RECT, 0, 0, 80, 80);
    ps.shape = createShape(RECT, 0, 0, 80, 80);
}

void draw() {
    background(0);

    for (int i = 0; i < players.length; i++) {
        // main key watcher
        if (keyPressed) {
            if ((key == 'w' || keyCode == UP) && players[i].pos.y == ground) {
                players[i].vel.y -= j;
            }
        }

        // physics computations for all players
        // gravity mechanics
        if (players[i].pos.y < ground) {
            players[i].vel.y += g;
        } else {
            players[i].pos.y = ground;
            players[i].vel.y = 0;
        }

        // update pos
        players[i].pos.add(players[i].vel);

        // main rendering loop
        fill(255);
        shape(players[i].shape,players[i].pos.x,players[i].pos.y);
    }
}
