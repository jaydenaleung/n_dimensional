// Notes: 
// - When applying global velocity changes (i.e. you want to change v_t), change v_i and v_e together instead. v_t is only for updating the position.
// - Multiply by delta_time every time you update (add or subtract from) the position or velocity


class Player {
    ////////// Instance variables //////////

    // Properties
    PVector pos,v_i,v_e,v_t; // v_i = input vel, v_e = external vel, v_t = total vel
    PlayerType type;
    PShape shape;
    int initSides, sides;
    float d; // d = DISTANCE NOT DIAMETER, dist from center to a vertex
    float distToSide; // as apposed to a vertex
    color c;
    String query; // attacking move query

    // Constants
    float g,f; // g = gravity, f = friction constant
    float xAccel,yAccel; // acceleration constants for x/y input movement
    float jumpVel,fallVel; // initial velocity constants for jumping and falling
    float maxvx,maxvy; // speed clamps

    // Flags
    boolean onGround, jumpable;


    ////////// Constructors //////////

    // PlayerType
    Player(PlayerType t) {
        // Properties
        type = t;
        d = 25;
        distToSide = d; // default
        c = color(255,255,255);

        initSides = 20; // starting # of sides
        sides = initSides;

        // Actual spawn positions are set after size() in initPosition()
        pos = new PVector(0,0);

        v_i = new PVector(0,0);
        v_e = new PVector(0,0);
        v_t = PVector.add(v_i, v_e);

        query = "";

        // Constants
        g = 150.0;
        f = 10.0;

        xAccel = 200.0;
        yAccel = 200.0;

        jumpVel = -150.0;
        fallVel = 60.0; // for down button, not gravity

        maxvx = 100.0;
        maxvy = 150.0;

        // Flags
        if (pos.y + distToSide < ground) { onGround = false; } else { onGround = true; }
        if (onGround) { jumpable = true; } else { jumpable = false; } // set other conditions later
    }

    // PlayerType, float, float
    // Player(PlayerType t, float g, float f) {
    //     // Properties
    //     type = t;

    //     if (type == PlayerType.PRIMARY) {
    //         pos = new PVector(100,100);
    //     } else {
    //         pos = new PVector(100,width-100);
    //     }

    //     v_i = new PVector(0,0);
    //     v_e = new PVector(0,0);
    //     v_t = PVector.add(v_i, v_e);

    //     // Constants
    //     this.g = g;
    //     this.f = f;

    //     xAccel = 200.0;
    //     yAccel = 200.0;

    //     jumpVel = -100.0;
    //     fallVel = 60.0; // for down button, not gravity

    //     maxvx = 100.0;
    //     maxvy = 150.0;

    //     // Flags
    //     if (pos.y < ground) { onGround = false; } else { onGround = true; }
    //     if (onGround) { jumpable = true; } else { jumpable = false; } // set other conditions later
    // }


    ////////// Methods //////////

    // Input
    void keyMove(int key) { // takes in key from keyPressed conditional in main file and runs logic. Note: key is a char which can be represented as an int.
        // WASD for Player 1 (primary) and arrow keys for Player 2 (secondary)
        if ((key == 'w' && type == PlayerType.PRIMARY) || (keyCode == UP && type == PlayerType.SECONDARY)) {
            if (jumpable) {
                v_e.y = jumpVel;
                onGround = false; // prevents code from setting v_t.y = 0
                jumpable = false;
            }
        }

        if ((key == 's' && type == PlayerType.PRIMARY) || (keyCode == DOWN && type == PlayerType.SECONDARY)) {
            if (!onGround) {
                v_i.y = fallVel;
            }
        }

        if ((key == 'a' && type == PlayerType.PRIMARY) || (keyCode == LEFT && type == PlayerType.SECONDARY)) {
            if (!moving) { v_i.x = 0; moving = true; }
            v_i.x += -xAccel * delta;
            v_i.x = constrain(v_i.x,-maxvx,maxvx);
        }

        if ((key == 'd' && type == PlayerType.PRIMARY) || (keyCode == RIGHT && type == PlayerType.SECONDARY)) {
            if (!moving) { v_i.x = 0; moving = true; }
            v_i.x += xAccel * delta;
            v_i.x = constrain(v_i.x,-maxvx,maxvx);
        }
    }

    // Physics processes
    void gravity() {
        if (!onGround) {
            v_e.y += g * delta; // use system delta
            v_e.y = constrain(v_e.y,-maxvy,maxvy);
        }
    }

    void friction() {
        if (!keyPressed) {
            // apply friction to v_i and v_e but not v_t so the total v_t will not be reset
            v_i.x *= 0.9;
            v_e.x *= 0.9;
        }
    }

    // Inits & Updates
    void initPosition() {
        float startX = (type == PlayerType.PRIMARY) ? width * 0.25 : width * 0.75;
        pos.set(startX, 100); // spawn above the ground
    }

    void updateFlags() {
        if (pos.y + distToSide < ground) { onGround = false; } else { onGround = true; }
        if (onGround) { jumpable = true; } else { jumpable = false; } // set other conditions later
    }

    void updateVelocity() {
        if (onGround) { v_i.y = 0; v_e.y = 0; v_t.y = 0; } // ground
        v_t = PVector.add(v_i, v_e); // will reset v_t every frame by adding v_i and v_e, so be careful
    }

    void updatePosition() {
        pos.add(v_t.copy().mult(delta));
    }

    // Attacks
    void keywordAttack() {
        Player p = this;
        Player o = identifyOpponent();
        
        if (o != null) { // if there is an identifiable opponent
            if (query.length() == 5) {
                query = query.toUpperCase();
                if (isValidKeyword(query)) {
                    int index = findKeywordIndex(query);
                    if (!(index < 0)) { // if valid index or attack
                        attack(index,p,o);
                    }
                }
                query = ""; // clear
            }
        }
    }

    void stepAttacks() {
        for (int i = ongoingAttacks.size()-1; i >= 0; i--) { // backwards iteration for ArrayList remove!
            Object atk = ongoingAttacks.get(i);

            Spikes a;
            Darts b;
            // other attacks of Attack b; Attack c; Attack d; etc.

            if (atk instanceof Spikes) {
                a = (Spikes)atk;

                if (!a.hit) {
                    a.attack();
                } else {
                    ongoingAttacks.remove(a);
                }
            }

            if (atk instanceof Darts) {
                b = (Darts)atk;

                if (!b.hit) {
                    b.attack();
                } else {
                    ongoingAttacks.remove(b);
                }
            }
            // with other attacks of Attack b; Attack c; Attack d; etc.
        }
    }

    void drawKeyword() {
        fill(255);
        textFont(font2);

        String q = query.toUpperCase();
        float textOffset = textWidth(q) / 2.0; // offset from player dynamically based on actual text width

        text(q,pos.x-textOffset,pos.y-35);
    }

    Player identifyOpponent() { // returns the instance of the opponent
        for (Player p : players) {
            if (p != this) { return p; }
        }
        return null;
    }

    boolean isValidKeyword(String ky) { // checks if the keyword matches an attack
        for (Attack a : attacks) {
            if ((type == PlayerType.PRIMARY && ky.equals(a.kywd1)) || (type == PlayerType.SECONDARY && ky.equals(a.kywd2))) { // independent player keywords
                return true;
            }
        }
        return false;
    }

    int findKeywordIndex(String ky) { // returns the index of the keyword's attack in the attack list
        for (Attack a : attacks) {
            if ((type == PlayerType.PRIMARY && ky.equals(a.kywd1)) || (type == PlayerType.SECONDARY && ky.equals(a.kywd2))) { // find the matching attack
                for (int i = 0; i < attacks.length; i++) { // find the attack's index
                    if (a == attacks[i]) {
                        return i;
                    }
                }
            }
        }
        return -1; // didn't find attack
    }

    // Rendering
    PShape renderShape() { // make the polygon shape based on # of sides. call when init and whenever attacked.
        PShape s;
        PVector[] v = new PVector[sides]; // array of vertices

        distToSide = d * cos(PI/sides);
        
        s = createShape();
        s.beginShape();
        s.fill(c);
        s.noStroke();
        
        // Computational generation of shape
        // the angle between the verticies of an n-sided regular polygon is 360/n
        float a = 360.0/sides;
        // if it has an odd number of sides, the first vertex is directly above the origin. if it has an even number, the first vertex is angle/2 to the side of directly above the origin. (from observation of shapes)
        if (sides % 2 == 1) { // odd
            for (int i = 0; i < sides; i++) {
                // trig calculations to get the coordinate based on the angle from the top
                float ang = 90-a*i;
                float x = d*cos(radians(ang));
                float y = -d*sin(radians(ang)); // flip the y axis with the negative as y axis points down
                v[i] = new PVector(x,y);
            }
        } else { // even
            for (int i = 0; i < sides; i++) {
                // angle + half of that angle for even-sided polygons
                float ang = (90-a*i)-a/2;
                float x = d*cos(radians(ang));
                float y = -d*sin(radians(ang));
                v[i] = new PVector(x,y);
            }
        }

        for (PVector vec : v) {
            s.vertex(vec.x, vec.y);
        }

        s.endShape(CLOSE);
        return s;
    }

    void drawPlayer() {
        shape = renderShape(); // opt
        // shape(shape,pos.x,pos.y-distToSide); // offest so it looks like it's ont he ground
        shape(shape,pos.x,pos.y);
    }
}
