class Attack {
    String name,kywd;

    Attack(String n, String ky) {
        name = n;
        kywd = ky;
    }

    void attack(Player p, Player o) {
        Spikes a;
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
        // with other attacks of Attack b; Attack c; Attack d; etc.
    }
}