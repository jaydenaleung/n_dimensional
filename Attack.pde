class Attack {
    String name,kywd1,kywd2;

    Attack(String n, String ky1, String ky2) {
        name = n;
        kywd1 = ky1;
        kywd2 = ky2;
    }

    void attack(Player p, Player o) {
        Spikes a;
        Darts b;
        // other attacks of Attack b; Attack c; Attack d; etc.
        
        if (name.equals("spikes")) {
            a = new Spikes(p,o);

            ongoingAttacks.add(a);

            if (!a.hit) {
                a.attack();
            } else {
                ongoingAttacks.remove(a);
            }
        }

        if (name.equals("darts")) {
            b = new Darts(p,o);

            ongoingAttacks.add(b);

            if (!b.hit) {
                b.attack();
            } else {
                ongoingAttacks.remove(b);
            }
        }
        // with other attacks of Attack b; Attack c; Attack d; etc.
    }
}