// Notes: 
// - When applying global velocity changes (i.e. you want to change v_t), change v_i and v_e together instead. v_t is only for updating the position.
// - Multiply by delta_time every time you update (add or subtract from) the position or velocity


class Player {
    ////////// Instance variables //////////

    // Properties
    PVector pos,v_i,v_e,v_t; // v_i = input vel, v_e = external vel, v_t = total vel
    PlayerType type;
    int initSides, sides;
    float d; // d = diameter, dist from center to a vertex
    color c;
    PShape shape;

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
        d = 50;
        c = color(255,255,255);

        initSides = 50;
        sides = initSides;
        shape = renderShape(sides, d, c);

        if (type == PlayerType.PRIMARY) {
            pos = new PVector(100,100);
        } else {
            pos = new PVector(100,width-100);
        }

        v_i = new PVector(0,0);
        v_e = new PVector(0,0);
        v_t = PVector.add(v_i, v_e);

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
        println("vy = " + v_t.y);
    }

    PShape renderShape(int sides, float d, color c) { // make the polygon shape based on # of sides
        PShape s;
        s = createShape();
        s.beginShape();
        s.fill(c);
        s.noStroke();
        
        // Computational generation of shape
        // the angle between the verticies of an n-sided regular polygon is 360/n

        s.endShape(CLOSE);
        return s;
    }

    void drawPlayer() {
        rect(pos.x,pos.y,20,20);
    }
}
