// NOTE: Attack execution functions are made to run in the constant game loop. //

class Spikes {
    // Constants & Variables
    int dmg = 1; // int amt of sides
    float r = 5.0; // 10 pixel radius of damage
    float initVel = 300.0; // 300 pixels/s
    float size = 12.5; // distance from center to the top vertex of triangle

    Player p; // player
    Player o; // opponent

    PVector ppos; // player position at time of attack activation
    PVector opos; // opponent position at time of attack activation

    boolean attacking0 = true; // if the spikes are generated before they are sent out from the player
    boolean attacking1 = false; // if the part 1 attack animation is playing
    boolean attacking12 = false; // if the spike geometry is being flipped between parts 1 and 2
    boolean attacking2 = false; // if the part 2 attack animation is playing
    boolean inFrame = true; // if the spikes are within the frame
    boolean hit = false; // if the spikes hit

    ArrayList<Projectile> spikeList = new ArrayList<Projectile>();

    Spikes(Player p, Player o) {
        this.p = p;
        this.o = o;
    }

    void attack() {
        // create the spikes
        if (attacking0) {
            ppos = p.pos.copy(); // set the positions of each player at the time of attack activation; copy() to avoid using the reference
            opos = o.pos.copy();
            
            for (int i = 0; i < 8; i++) { // 8 spikes
                // Set geometric/kinematic variables
                float angle = radians(i*45);
                float adjustedAngle = radians(i*45-90); // angle taken from the line extending vertically upwards from the origin
                PVector v = new PVector(cos(adjustedAngle), sin(adjustedAngle)); // vector velocity for each spike
                v.mult(initVel);

                // Create the shape
                PShape shape = createShape(TRIANGLE, -size, size,  0, -size,  size, size); // explicit creation so it doesn't link a reference
                shape.setFill(color(255));
                shape.setStroke(false);
                shape.rotate(angle); // rotate the shape for each spike, at 45 deg steps, returns to original rotation after loop
                
                Projectile spike = new Projectile(ppos.copy(),v,shape);
                spikeList.add(spike);
            }

            attacking0 = false;
            attacking1 = true;
        }

        // Part 1: send spikes out from the player out of the frame (does not affect opponent)
        if (attacking1) {
            // Check if all of the spikes are in the frame
            inFrame = false; // default value for the check below
            for (Projectile spike : spikeList) {
                if (spike.pos.x + (size+5) >= 0 && spike.pos.x - (size+5) <= width && spike.pos.y + (size+5) >= 0 && spike.pos.y - (size+5) <= height) { // +5 for buffer
                    inFrame = true;
                }
            }
            
            // step spikes every frame, part 1 - step until they get out of the frame
            if (inFrame) {
                for (Projectile spike : spikeList) {
                    spike.step();
                    spike.render();
                }
            } else {
                attacking1 = false;
                attacking12 = true;
                attacking2 = false;
            }
        }

        // Part 1.5: Flip the spike geometry
        if (attacking12) {
            // flip orientation & velocity horizontally and vertically
            // translate the spikes' position based on the pos difference between the player and opponent
            // step and render as long is hit boolean is false
            for (Projectile spike : spikeList) {
                spike.shape.scale(-1,-1);
                spike.pos.add(opos.copy().sub(ppos)); // shift the spikes to hit the opponent
                spike.vel.mult(-1);
            }

            attacking12 = false;
            attacking2 = true;
        }

        // Part 2: Send the spikes back into the opponent's position
        if (attacking2) {
            // Check if the spikes hit
            hit = false;
            for (Projectile spike : spikeList) {
                if (dist(opos.x, opos.y, spike.pos.x, spike.pos.y) < 5) { // attack completed if the spikes come back within 5 pixels of opos
                    hit = true;
                }
            }

            if (!hit) {
                for (Projectile spike : spikeList) {
                    spike.step();
                    spike.render();
                }
            } else { // update opponent's health if it is within attacking radius
                attacking2 = false;
                if (dist(opos.x, opos.y, o.pos.x, o.pos.y) < r) { // the pos of the opp when the attack was sent and the pos of the opp when the attack hits
                    o.sides -= dmg;
                }
            }
        }
    }
}