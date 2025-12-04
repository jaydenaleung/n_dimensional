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
    float d; // d = diameter, dist from center to a vertex
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
        d = 20;
        c = color(255,255,255);

        initSides = 3;
        sides = initSides;

        if (type == PlayerType.PRIMARY) {
            pos = new PVector(100,100);
        } else {
            pos = new PVector(100,width-100);
        }

        v_i = new PVector(0,0);
        v_e = new PVector(0,0);
        v_t = PVector.add(v_i, v_e);

        query = "";

        // Constants
        g = 100.0;
        f = 10.0;

        xAccel = 200.0;
        yAccel = 200.0;

        jumpVel = -100.0;
        fallVel = 60.0; // for down button, not gravity

        maxvx = 100.0;
        maxvy = 150.0;

        // Flags
        if (pos.y < ground) { onGround = false; } else { onGround = true; }
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
        if (key == 'w' || keyCode == UP) {
            if (jumpable) {
                v_e.y = jumpVel;
                onGround = false; // prevents code from setting v_t.y = 0
                jumpable = false;
            }
        }

        if (key == 's' || keyCode == DOWN) {
            if (!onGround) {
                v_i.y = fallVel;
            }
        }

        if (key == 'a' || keyCode == LEFT) {
            if (!moving) { v_i.x = 0; moving = true; }
            v_i.x += -xAccel * delta;
            v_i.x = constrain(v_i.x,-maxvx,maxvx);
        }

        if (key == 'd' || keyCode == RIGHT) {
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

    // Updates
    void updateFlags() {
        if (pos.y < ground) { onGround = false; } else { onGround = true; }
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
                if (query == spikes.kywd) {
                    spikes.attack(p,o);
                }
                // else if (query == .kywd) {
                //     .attack();
                // } 
                // else if (query == .kywd) {
                //     .attack();
                // }
                query = ""; // clear
            }
        }
    }

    void drawKeyword() {
        fill(255);
        text(query.toUpperCase(),100,100);
    }

    Player identifyOpponent() {
        for (Player p : players) {
            if (p != this) { return p; }
        }
        return null;
    }

    // Rendering
    PShape renderShape() { // make the polygon shape based on # of sides. call when init and whenever attacked.
        PShape s;
        PVector[] v = new PVector[sides]; // array of vertices
        
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
        shape(shape,pos.x,pos.y);
    }
}
