class Player {
    ////////// Instance variables //////////

    // Properties
    PVector pos,v_i,v_e,v_t; // v_i = input vel, v_e = external vel, v_t = total vel
    PlayerType type;

    // Constants
    float g,f; // g = gravity, f = friction constant
    float xAccel,yAccel; // acceleration constants for x/y input movement
    float jumpVel,fallVel; // initial velocity constants for jumping and falling
    float maxvx,maxvy; // speed clamps

    // Flags
    boolean onGround;


    ////////// Constructors //////////

    // float, PlayerType
    Player(float delta, PlayerType t) {
        // Properties
        type = t;

        if (type == PRIMARY) {
            pos = new PVector(100,100);
        } else {
            pos = new PVector(100,width-100);
        }

        v_i = new PVector(0,0);
        v_e = new PVector(0,0);
        v_t = v_i + v_e;

        // Constants
        g = 9.81;
        f = 1.01;
        xAccel = 5.0;
        yAccel = 5.0;
        maxvx = 10.0;
        maxvy = 30.0;

        // Flags
        if (pos.x < ground) { onGround = false; } else { onGround = true; }
    }

    // float, PlayerType, float, float
    Player(float delta, PlayerType t, float g, float f) {
        // Properties
        type = t;

        if (type == PRIMARY) {
            pos = new PVector(100,100);
        } else {
            pos = new PVector(100,width-100);
        }

        v_i = new PVector(0,0);
        v_e = new PVector(0,0);
        v_t = v_i + v_e;

        // Constants
        this.g = g;
        this.f = f;
        xAccel = 5.0;
        yAccel = 5.0;
        maxvx = 10.0;
        maxvy = 30.0;

        // Flags
        if (pos.x < ground) { onGround = false; } else { onGround = true; }
    }


    ////////// Methods //////////

    // Input
    void keyMove(int key) { // takes in key from keyPressed conditional in main file and runs logic. Note: key is a char which can be represented as an int.
        if (key == 'w' || key == UP) {
            v_i.y = 
        }

        if (key == 's' || key == DOWN) {
            
        }

        if (key == 'a' || key == LEFT) {
            v_i.x += -xAccel * delta;
            v_i.x = constrain(v_i.x,-maxvx,maxvx);
        }

        if (key == 'd' || key == RIGHT) {
            v_i.x += xAccel * delta;
            v_i.x = constrain(v_i.x,-maxvx,maxvx);
        }
    }

    // Physics processes
    void gravity() {
        if (!onGround) {
            v_e.y += g * delta; // use system delta
            v_e.y = constrain(v_e.y,-maxvy,maxvy);
        } else {
            v_t.y = 0;
        }
    }

    void friction() {
        if (!keyPressed) {
            v_t.x /= f;
        }
    }

    // Updates
    void updateVelocity() { // run within updatePosition()
        v_t = v_i + v_e;
    }

    void updatePosition() {
        updateVelocity();

        pos += v_t * delta;
    }

    void drawPlayer() {

    }
}