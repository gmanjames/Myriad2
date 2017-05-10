# Myriad (beta) - By Garren Ijames
## Overview:
The idea for Myriad is a simple, single-player, top-down, shooter-type game, featuring a woodland sprite (the player) desperately trying to save their forest home from a demolition team of enemy characters that would otherwise destroy it.

![Image of Myriad](https://github.com/gmanjames/Myriad2/raw/master/docs/images/myriad-screen-shot.png)

## Game-play:
The player will attempt to win the game by destroying the bulldozers before they reach the bottom of the map. The player losses if any of the two events occur:
1. The bulldozers reach the bottom of the map, or
2. the player is hit five times by enemy projectiles.
The final score for the level will be the project of the number of drone enemies destroyed and the remaining distance between the bulldozers and the bottom of the map.
Move between the two bordering sections of the map through the portals.

## Getting Started
1. Make sure you have [link Haxe](http://haxe.org) and [link Haxeflixel](http://haxeflixel.com) installed on your machine.
2. Clone this repository 'git clone https://github.com/gmanjames/Myriad2.git'
3. Open a terminal or command prompt in the folder Myriad2
4. Run the command 'lime test neko'

## Game Features / Player-Enemy Interaction:
The player’s only method of attack is the firing of projectiles. The player will attempt to destroy all bulldozer enemies with these projectiles. The bulldozer enemies will be more durable than the drone enemies which the player may also choose to destroy in order to expose the bulldozers or eliminate the drones as a source of enemy fire. The drone enemies will attempt to land hits on the player with projectiles of there own. If struck by one of these projectiles, the player’s available life count will be reduced by one, and the player will enter into a temporary state of invulnerability. Enemies, and enemy fire will freeze temporarily while teleporting. Randomly positioned obstacles (where the amount of each type of obstacle is also a random number) will each offer some amount of resistance to the bulldozers. The bulldozers will be delayed for a longer period of time removing rock obstacles than removing shrubbery obstacles. Additionally there may be a third obstacle offering less resistance than the shrubbery.

## Contact
Send me an email at yms1465@gmail.com
