class Attack {
    PVector pos,ppos,opos; // positions of itself, the sending player, and the opponent player
    Player plyr,opp;
    int dmg; // bc int number of sides
    float t0,t; // initial time the move was made, the progresion time of the move
    String name,kywd;

    Attack(String n, String ky, int dm) {
        name = n;
        kywd = ky;
        dmg = dm;
    }

    void attack(Player p, Player o) {
        plyr = p;
        opp = o;

        pos = plyr.pos;
        ppos = plyr.pos;
        opos = opp.pos;

        t0 = millis();
        t = t0;
        
        if (checkSuccess()) { // move completed
            updateSides();
        } else { // else continue to step through the move
            updateAttackGraphics();
            drawAttackGraphics();
        }
    }

    boolean checkSuccess() {
        return false;
    }

    void updateSides() {

    }

    void updateAttackGraphics() {

    }

    void drawAttackGraphics() {

    }
}