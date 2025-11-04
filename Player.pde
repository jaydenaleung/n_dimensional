class Player {
    PVector pos,v_i,v_e,v_t; // v_i = input vel, v_e = external vel, v_t = total vel
    float g,f,delta; // g = gravity, f = friction constant

    Player() {
        delta = 1/frameRate; // initial (theoretical) value
    }

    void keyMove(int key) { // takes in key from keyPressed conditional in main file and runs logic. Note: key is a char which can be represented as an int.
        if (key == 'w' || key == UP) {

        }

        if (key == 's' || key == DOWN) {
            
        }

        if (key == 'a' || key == LEFT) {

        }

        if (key == 'd' || key == RIGHT) {

        }
    }

    void gravity() {

    }

    void friction() {

    }

    void updateDelta() {
        
    }

    void updateVelocity() { // run within updatePosition()
        v_t = v_i + v_e;
    }

    void updatePosition() {
        updateVelocity();

        pos += v_t * delta;
    }

}