### Initial Steps

To begin my project, I brainstormed a few interesting game ideas, first thinking about a game such as “Slope Unblocked” or another similar 3D game. However, I found Processing’s 3D engine not very intuitive and difficult to run on a basic IDE or computer. I switched to a fighting-based game instead, prioirtizing minimalistic and geometric designs and quality of gameplay. Below, I’ve first attempted, successfully, to implement pseudocode for a basic player with controls and physics (gravity and friction):

****NOTE: Multiply by delta_time every time you update (add or subtract from) the position or velocity. When applying global velocity changes (i.e. you want to change v_t), change v_i and v_e together instead. v_t is only for updating the position.****

- Class player

- Position vector

- Velocity input vector

- Velocity external vector

- Velocity total vector

- Gravity method, adds strength of gravity to v_e_y when not on ground, else **v_t**_y

- Friction method, divides v_t_x ONLY WHEN keys are not being pressed

- Check keys method - checks wasd and arrow keys and moves accordingly

- Horizontally: add movement accel strength * delta time to v_i_x when a/d is pressed

- Clamp v_i_x

- Vertically: set **v_i_y** to initial jump velocity when w/s is pressed

- ONLY when in a jumpable state (e.g. on ground or off a wall or double jump)

- Else  - don’t do anything to v_i_y

- Falling:

- Save in dummy variable initial fall y velocity + current total y velocity

- Set v_t_y to that dummy variable???

- Add velocity method

- Add v_i and v_e = v_t

- Update position method

- Using delta time

- Draw method - draws the player

In the actual implementation of this code, I consolidated all the controls and gravity within one Player class so it could be modularized and repeated for multiple players. Common properties were the gravity, friction, and maximum speed levels, as well as the position vector and a velocity (input; i.e. initiated by controls) vector and a velocity (external; i.e. initiated by being attacked or by gravity) vector. I organized my action items into a few key methods, including detecting and executing key presses, imposing the effect of gravity and friction, updating the velocity, and updating the position.

I will likely continue with classes for moves of different types, but most physics-based movements are consolidated within the Player class here. Properties and actions specific to the player, such as its position, are within the Player class, and global variables, such as the delta (time between frames), are outside the Player class.


### Extending the Idea and Adding Basic Attack Mechanics

I am envisioning the attack mechanics as follows:

- You start as a shape with many sides, each side is a life. <3 sides = loss.

- Each time you are attacked, you lose a life.

- Attacks are equally strong, but each consecutive use of them reduces the chance of the attack actually landing (if the opponent is still). The opponent may still dodge them as the attacks are auto-aimed toward the opponent, but does not follow them.

- Attacks are only activated by specific 5-key words (i.e. TRIPS) that exclude movement keys.

- Attack designs must prioritize quality and minimalistic geometric designs.

This is how I implemented the ‘number of sides-lives’:

- I figured out that the internal angle (call it _a) between vertices is 360 deg/number of sides.

- I also figured out from looking at regular polygons that odd-sided polygons have their first vertex directly up, while even-sided polygons have their first vertex at _a/2 to the right of the line directly up from the origin.

- Then I computed the custom vertices that would make up the shape in Processing using these formulas:

- (of each vertex) x = d*cos(radians(90-_a*i)); where i is the specific vertex it’s drawing

- y = -d*sin(radians(90-_a*i))

- Additionally, for even-sided polygons, the angle inside the radians() function was incremented by _a/2.

- I set the shape property of the player to a function that would carry out this computation and ran the function in the setup() function as well as whenever the player would be attacked.

This is how I implemented basic attack mechanics:

- A new class Attack:

- Properties pos,dmg,success,kywd and other attack-specific properties

- Methods attack(plyr,opp) (run once, does everything), checkSuccess(), updateSides(), drawAttackGraphics()

- Void Keypressed():

- Player has a temporary string query property to hold typed letters

- Native key & keyPressed detectors save typed keys and add it to the temporary string

- The key enter clears the query if not 5 letters typed

- Method keywordAttack():

- Run in the draw loop for every player where it checks its query

- Display text function with query

- If it reaches 5 letters, check if it matches anything:

- If it does, then do that action/attack. Immediately clear the query.

- If it doesn’t, then don’t do that action/attack. Immediately clear the query.


### My First Attack

Given the limited time remaining to work on the project, I decided to scale back and implement only 2-3 attacks. These attacks will still have their own class, as outlined above, where the attack behavior will be handled.

My first attack is a ‘spike attack’:

- Activation keyword (AK) is ‘GOLEM’.

- Triangular spikes come out from the user, exit the screen, and enter the screen again to hit on the spot the opponent was standing. If the opponent is within a ~10 pixel radius of that spot, they will have their number of sides decreased by 1.

- Projectiles will have their own class to optimize for modularity.

To implement this, I made a few changes:

- I removed the player, opponent, and player/opponent position variables from the Attack class as I could just access them from the player and opponent passed into the attack() method.

- I created a Spikes class to handle the spikes, and a Projectile class to handle the animation.

- I made a keywordAttack() method on the Player class, where I check if an opponent exists, whether a keyword query has reached 5 letters yet, and if it has, whether it is matches any attack keywords. If it does, then it finds the index of that attack in the attack array and passes that to the global attack() function. (There are multiple functions named attack(), this is the global one.)

- The global attack function calls the attack() method on the Attack class of the specific Attack object pertaining to a specific attack.

- In the Attack class, the type of attack is identified by checking that object’s name, creating the right specific-attack-object (i.e. a Spikes class or another specific attack class) and calling the attack() method on *that* specific attack object, which handles the animation.

- As long as the attack has not completed, the attack animation will keep running.

My next steps are:

1. Ensure the attack works (debug it).

2. Implement a screen that says Game Over and who won if one of the players’ sides goes under 3.

3. Implement two-player mode.

4. Implement game QOL (screen shake, color effects, background, etc.)

5. Ensure Spikes class has properties instantiated only in the constructor.

Here’s a video of the spike attack. A little bit laggy because of the GIF compression. Good thing you can’t hear me say: “Bam baby! WOO!”:

![Enter image alt description](Images/ebO_Image_1.gif)


### Game Over Screen

After successfully creating the spike attack, I need a game-over screen that activates when any of the players’ sides goes below 3. To do this, I will wrap the contents of the entire current draw() function in a conditional if (!gameOver), and provide an else block with just a blank screen and the text “Game Over! Winner: (winner)”.


### Two-Player Mode

The game is pretty pointless with just one player. Since I do not have time to implement an AI or algorithmic robot, I will instead split the keyboard so that two players can play simultaneously.

Here’s how I’m going to do that:

- Player 1 will use WASD, Player 2 will use arrow keys.

- Player 1’s activation keywords can only be numbers, while Player 2’s activation keywords can only be letters (mostly) on the right side of the keyboard. Both space and enter will clear the keyword query.

- This will require me to edit the conditionals governing key-controlled movement and keywords. I will also need to change the kywd property in the Attack class to kywd1 and kywd2 for the different players.


### Quality of Life Changes for a Minimalistic, High-Quality, Geometric Fighting Game

Of course, cool SFX and QOL logic are of utmost importance for a game like this. My plan to implement changes that will increase the game’s fun and aesthetic appeal is as follows:

- Screen shake

- The screen will shake using Processing’s translate() function whenever a move hits

- Background

- There are three different backgrounds that will crossfade whenever a song ends. Taken from the internet.

- Music

- There are three different songs I took from NCS that are specifically trimmed. They will play in a repeating order.

More clean-up changes:

1. Change the size of screen

2. Add a ground rectangle

3. Shapes should start with 20 sides

4. Disable mouse side adding

5. Add a simple projectile attack

6. Make shapes bigger

7. Make a text box on how to play

8. Make the text displays a lot better, including the query locations

9. Make default starting positions


### Adding an Extra Attack

Since I only have one attack right now (I think it’s pretty cool, though), I will add another simple one to increase the playability of the game. This will be a simple triangle or thin rounded rectangle that is shot at the opponent’s location when the attack is made (like the previous attack). The opponent can then dodge it.

In code, it will be performed as follows:

- class Darts {

- All the regular attack properties:

- int dmg; // int amt of sides

- float r; // 20 pixel radius of damage

- float initVel; // 300 pixels/s

- float size; // distance from center to the top vertex of triangle



- Player p; // player

- Player o; // opponent



- PVector ppos; // player position at time of attack activation

- PVector opos; // opponent position at time of attack activation



- boolean attacking0; // if the spikes are generated before they are sent out from the player

- boolean attacking1; // if the attack animation is playing

- boolean inFrame; // if the spikes are within the frame

- boolean hit; // if the spikes hit



- ArrayList<Projectile> spikeList;

- Including a calculated velocity that is initVel * a unit vector pointing from ppos to opos

- attack() method

- }


### Final Reflection

The game I made is named ‘n-dimensional’ as a tribute to the geometric and minimalistic style of the fighting game. I first conceived n-dimensional when I was thinking about the style that I wanted to structure my game around, and this style focused on minimalism and high quality. Thus, I am most proud of the little aesthetic components that I added to increase the quality of my game. This included screen shake, background music, and a custom background, but I loved the screen shake most because it provided a very aesthetically pleasing and satisfying effect.

Naturally, if I had more time, I would implement more of these. I had ideas to add a color effect for hit enemies (like Minecraft’s red color effect when players are hit) and explosions when attacks completed. In addition, I would have deepened the game mechanics as I envisioned earlier in this document. I would add more attacks, use dynamic ground terrain, and implement accuracy that would decrease if you used a specific move consecutively. These would be my next areas of improvement if there was more time.

Even though some of those effects, like the music that used Processing’s Sound renderer, were complex to implement, I would say my biggest debugging challenge lay more in the simpler errors. When I added a starting screen with a play button, the players on the next screen would disappear a seemingly random distance into the bottom of the screen. I believe this simple issue came from the complex nature of the code, which broke critical mechanisms, such as player drawing, when even simple features such as a starting screen. It ultimately forced me to add many print statements to check where the positioning was offset, leading me to find the error to be toggling a boolean flag after one player was spawned not the other.

For large projects in the future, I think it would be most helpful to investigate current coding paradigms and strategies, such as how physics is usually implemented in game engines. I tried to use pseudocode here, but it was sometimes not practical as my changes were not on the broad structure but in specific lines. Using larger or more developed coding paradigms would help mitigate needing specific changes since I would have thought of a more detailed pseudocode outline in the first place. In fact, I did explore physics engines in game development and other game development strategies, but only through ChatGPT, as I thought it could give me the most straightforward, quick, and understandable answer. Reflecting now, searching for quick answers cut out a lot of detail, which means I couldn’t learn the broader paradigms or strategies that would have saved time if I just followed them. Overall, however, I really enjoyed the process and am proud of my final product.
