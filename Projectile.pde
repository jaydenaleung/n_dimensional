class Projectile {
    PVector pos, vel;
    PShape shape;

    Projectile(PVector p, PVector v, PShape s) {
        pos = p.copy();
        vel = v.copy();
        shape = s;
    }

    void step() {
        pos.add(vel.copy().mult(delta));
    }

    void render() {
        fill(255);
        shape(shape,pos.x,pos.y);
    }
}