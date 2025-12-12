// NOTE: Attack execution functions are made to run in the constant game loop. //

class Darts {
    // Constants & Variables
    int dmg; // int amt of sides
    float r; // custom pixel radius of damage, not used now
    float initVel; // 300 pixels/s
    float dartWidth; // width of rounded rectangle with a fixed HW ratio
    float dartHeight;

    Player p; // player
    Player o; // opponent

    PVector ppos; // player position at time of attack activation
    PVector opos; // opponent position at time of attack activation

    boolean attacking0; // if the spikes are generated before they are sent out from the player
    boolean attacking1; // if the part 1 attack animation is playing
    boolean inFrame; // if the spikes are within the frame
    boolean hit; // if the spikes hit

    ArrayList<Projectile> dartList;

    Darts(Player p, Player o) {
        this.p = p;
        this.o = o;

        dmg = 1;
        r = 20.0;
        initVel = 300.0;
        dartWidth = 12.5;
        dartHeight = dartWidth  / 5.0;

        attacking0 = true;
        attacking1 = false;
        inFrame = true;
        hit = false;

        dartList = new ArrayList<Projectile>();
    }

    void attack() {
        // create the spikes
        if (attacking0) {
            ppos = p.pos.copy(); // set the positions of each player at the time of attack activation; copy() to avoid using the reference
            opos = o.pos.copy();

            // Set geometric/kinematic variables
            PVector v = opos.copy().sub(ppos).normalize(); // unit vector from player to opponent, serves its velocity
            v.mult(initVel);

            float angle = atan(v.y/v.x);

            // Create the shape
            PShape shape = createShape(RECT, -dartWidth/2, -dartHeight/2, dartWidth, dartHeight, dartHeight/2); // explicit creation so it doesn't link a reference. also, offset the initial starting point so the anchor is at (0,0).
            shape.setFill(color(255));
            shape.setStroke(false);
            shape.rotate(angle); // rotate the shape for each spike, at 45 deg steps, returns to original rotation after loop
            
            Projectile dart = new Projectile(ppos.copy(),v,shape);
            dartList.add(dart);

            attacking0 = false;
            attacking1 = true;
        }

        // Part 1: send spikes out from the player out of the frame (does not affect opponent)
        if (attacking1) {
            // Check if all of the spikes are in the frame
            inFrame = false; // default value for the check below
            for (Projectile dart : dartList) {
                if (dart.pos.x + (dartWidth+5) >= 0 && dart.pos.x - (dartWidth+5) <= width && dart.pos.y + (dartHeight+5) >= 0 && dart.pos.y - (dartHeight+5) <= height) { // +5 for buffer
                    inFrame = true;
                }
            }

            // Attack completed if the dart hits etiher a player or a wall
            hit = false;
            for (Projectile dart : dartList) {
                if (dist(o.pos.x, o.pos.y, dart.pos.x, dart.pos.y) < o.d/2) {
                    hit = true; // attack completed, damage
                    attacking1 = false;

                    o.sides -= dmg;
                    triggerScreenShake(10.0); // smaller amount for smaller attack
                } else if (!inFrame) {
                    hit = true; // attack completed, no damage
                    attacking1 = false;

                    triggerScreenShake(10.0);
                } else { // else keep stepping and rendering the darts
                    dart.step();
                    dart.render();
                }
            }
        }
    }
}