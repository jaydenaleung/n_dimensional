/* 
    NOTE: The game begins with a loading screen that is white for ~10-15 seconds. 
    This is natural as it is loading the backgrounds and music files which are somewhat large.
    AI did help me debug some of this, and I used it to help me through the particularily challenging parts,
    like the low-level audio OS code that it wrote for safePlay(). The idea and pretty much all the code
    is written by me excluding exceptions like the audio OS code I described above.
*/

import processing.sound.*; // processing's sound library for music!

////////// Variables //////////
float delta; // delta = computed time in between frames (ensure that forces are per second, not per frame)
float t,pt;
float ground; // ground level

float screenShakeIntensity = 0.0;

PImage bkg;
PImage bkg1;
PImage bkg2;
PImage bkg3;
PImage[] bkgs = {bkg1, bkg2, bkg3};

// vscode will give you an error here; ignore it as processing doesn't give you an error
SoundFile music1;
SoundFile music2;
SoundFile music3;
SoundFile[] songs = {music1, music2, music3};
int currentSongIndex = 0;
boolean soundAvailable = true; // disable music if audio device rejects requested format

PFont font1;
PFont font2;
int fontSize1 = 10;
int fontSize2 = 12;

boolean moving = false;

// screen states
boolean instructions = true;
boolean gameInit = false; // only run once - isn't run in setup() because it's specific to the game state, not the other screens
boolean gameOver = false;

int winner; // 1 is player 1, 2 is player 2

// Button sizes
float buttonW = 50;
float buttonH = 20;
float xButtonBound;
float yButtonBound;

enum PlayerType { PRIMARY, SECONDARY }


////////// Instances //////////
Player pp = new Player(PlayerType.PRIMARY);
Player ps = new Player(PlayerType.SECONDARY);
Player[] players = {pp,ps};

// list of attacks
Attack spikes = new Attack("spikes", "15243", "NYLON");
Attack darts = new Attack("darts", "54321", "PINKY");
Attack[] attacks = {spikes, darts};
ArrayList ongoingAttacks = new ArrayList();

////////// Functions //////////

void initDelta() {
    t = millis() / 1000.0; // initial
    pt = t; // initial
    delta = 0; // initial
}

void updateDelta() { // run this before running player methods
    pt = t;
    t = millis() / 1000.0;
    delta = t - pt;
}

void checkKeys(Player p) { // feeder function into p.keyMove()
    if (keyPressed) {
        p.keyMove(key);
    }
}

void printChecks(Player p) { // activate when you want to print things
    println("pos.x: " + p.pos.x);
    println("pos.y: " + p.pos.y);
}

void checkGameOver(Player p) {
    if (p.sides < 3) {
        gameOver = true; // set gameOver to true

        for (Player plyr : players) { // identify winner's number (player 1 or player 2)
            if (plyr != p) { // then plyr is the winner
                for (int i = 0; i < players.length; i++) {
                    if (players[i] == plyr) {
                        winner = i+1; // winner's number
                    }
                }
            }
        }
    }
}

void drawGround() {
    ground = height-100; // update for screen size changes
    fill(0,0); // transparent fill, white border
    stroke(255);
    strokeWeight(1);
    line(0,ground,width,ground); // ground
}

void initFont() {
    font1 = createFont("Gameplay.ttf", fontSize1);
    font2 = createFont("Gameplay.ttf", fontSize2);
}

void initVariables() { // since it needs to be run in setup()
    xButtonBound = width/2 - buttonW/2;
    yButtonBound = height/2 - buttonH/2;
    ground = height-100;
}

void instructions() {
    String instr1 = "How To Play:";
    String instr2 = "- Objective: Each player's shape is a regular polygon starting with 20 sides. Each attack decreases the amount of sides it has. You win when the other player has less than 3 sides.";
    String instr3 = "- Player 1: Use WASD to move. Player 2: Use arrow keys.";
    String instr4 = "- To activate an attack, use the keywords.  Moves auto-aim, but you can still dodge them.";
    String instr5 = "- '54321' (Player 1) or 'pinky' (Player 2) for Dart attack (1 dmg).";
    String instr6 = "- '15243' (Player 1) or 'nylon' (Player 2) for Spike attack (2 dmg).";
    String instr7 = "- Have fun!";
    
    textFont(font1);
    fill(255);
    text(instr1,width/2-200,100,400,400);
    text(instr2,width/2-200,100+fontSize1*1+10,400,400);
    text(instr3,width/2-200,100+fontSize1*5+20,400,400);
    text(instr4,width/2-200,100+fontSize1*7+30,400,400);
    text(instr5,width/2-200,100+fontSize1*9+40,400,400);
    text(instr6,width/2-200,100+fontSize1*11+50,400,400);
    text(instr7,width/2-200,100+fontSize1*13+60,400,400);

    fill(255);
    println(xButtonBound,yButtonBound);
    rect(xButtonBound,yButtonBound+100,buttonW,buttonH); // Play button

    float tw = textWidth("Play!");
    float th = fontSize1;
    fill(0);
    text("Play!",width/2-tw/2,height/2+th/2+100);
}

void endScreen() {
    textFont(font2);
    fill(255);
    String q1 = "Game Over!";
    String q2 = "Winner: Player " + winner + "!";

    text(q1, width/2-textWidth(q1)/2, height/2 - 25);
    text(q2, width/2-textWidth(q2)/2, height/2 + 25);
}


////////// Watcher Functions //////////

void mouseClicked() {
    // Play button
    if (instructions && mouseX > xButtonBound && mouseX < xButtonBound+buttonW && mouseY > yButtonBound+100 && mouseY < yButtonBound+100+buttonH) {
        instructions = false;
        gameInit = true;
    }
}

void keyPressed() {
    for (Player p : players) {
        if (p.query.length() < 5 && key != 'w' && key != 'a' && key != 's' && key != 'd' && keyCode != UP && keyCode != DOWN && keyCode != LEFT && keyCode != RIGHT) { // limited to 5 letter keywords w/o WASD & arrow keys
            if (keyCode == ENTER || key == ' ') { // enter or space
                p.query = "";
            } else {
                if ((p.type == PlayerType.PRIMARY && (key >= '0' && key <= '9')) || (p.type == PlayerType.SECONDARY && ((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')))) { // P1 can only use numbers, P2 only letters
                    p.query += key;
                }
            }
        }
    }
}

void keyReleased() {
    moving = false;
}


////////// Attack Functions //////////

void attack(int index, Player p, Player o) {
    attacks[index].attack(p,o);
}


////////// QOL Functions //////////

// NOTE: Background functions must run directly after background(). Screen-affecting functions must run directly after background functions.
void applyScreenShake() {
    translate(random(-screenShakeIntensity,screenShakeIntensity),random(-screenShakeIntensity,screenShakeIntensity));
}

void triggerScreenShake(float intensity) {
    screenShakeIntensity = intensity;
}

void decayScreenShake() {
    screenShakeIntensity /= 1.05;
}

// Music is from NCS. songs:
// wanderlust - electro
// strobe - techno
// the return - edm
void initBackgroundAndMusic() {
    // Images
    bkg1 = loadImage("bkg1.jpg");
    bkg2 = loadImage("bkg2.jpg");
    bkg3 = loadImage("bkg3.jpg");

    // Repopulate the array now that the images are loaded
    bkgs = new PImage[]{bkg1, bkg2, bkg3};

    bkg = bkg1; // default starting bkg

    // Music
    music1 = new SoundFile(this,"music1.mp3");
    music2 = new SoundFile(this,"music2.mp3");
    music3 = new SoundFile(this,"music3.mp3");

    // Repopulate the array now that the SoundFile instances exist
    songs = new SoundFile[]{music1, music2, music3};

    safePlay(songs[currentSongIndex]);
}

void loadBackgroundAndMusic() {
    // Background music
    SoundFile song = songs[currentSongIndex];

    if (song != null && soundAvailable && !song.isPlaying() && song.position() >= song.duration() - 0.05) { // if the song has ended; -0.05 to account for small delays
        if (currentSongIndex == 2) {
            currentSongIndex = 0;
        } else {
            currentSongIndex++;
        }
        safePlay(songs[currentSongIndex]); // play the next song in the repeating queue
    }

    // Background image
    image(bkgs[currentSongIndex],0,0);
}

// Play helper that tolerates audio device failures. I had to use the Copilot agent to help me through doing these low-level programming steps.
void safePlay(SoundFile sf) {
    if (!soundAvailable || sf == null) {
        return;
    }
    try {
        sf.play();
    } catch (Exception ex) { // audio device unavailable/unsupported format
        soundAvailable = false;
        println("Audio playback disabled: " + ex.getMessage());
    }
}


////////// Game Functions //////////

void setup() {
    size(720,480,P2D);

    initBackgroundAndMusic();
    initDelta();
    initFont();
    initVariables();

    for (Player p : players) {
        p.shape = p.renderShape();
    }
}

void draw() {
    if (instructions) { // instructions screen
        background(0);

        instructions();
    } else if (!gameOver) { // regular game loop
        pushMatrix(); // needed for screen shake to return to 0

        background(0);
        loadBackgroundAndMusic();

        applyScreenShake();

        updateDelta();

        drawGround();

        // Looping over all players
        for (Player p : players) {
            // Checks & Flags & Updates
            p.updateFlags();
            checkKeys(p);

            // Physics
            p.gravity();
            p.friction();
            p.updateVelocity();
            p.updatePosition();

            // Moves
            p.keywordAttack(); // initial attack and adds it to the ongoingAttacks array
            p.stepAttacks(); // continue any attacks in the ongoingAttacks array

            // make sure initial position is set when game starts
            if (gameInit) { // only run once - isn't run in setup() because it's specific to the game state, not the other screens
                p.initPosition();
            }

            // Rendering
            p.drawPlayer();
            p.drawKeyword();

            // Late Checks & Actions
            checkGameOver(p);
            decayScreenShake();
            printChecks(p);
        }

        if (gameInit) {
            gameInit = false;
        }

        popMatrix();
    } else { // blank screen with "Game Over!" and player who won
        background(0);
        
        endScreen();
    }
}
