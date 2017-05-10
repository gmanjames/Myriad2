# Myriad (beta) - By Garren Ijames
## Overview:
The idea for Myriad is a simple, single-player, top-down, shooter-type game, featuring a woodland sprite (the player) desperately trying to save their forest home from a demolition team of enemy characters that would otherwise destroy it.

![Image of Myriad] https://github.com/gmanjames/Myriad2/raw/master/docs/images/myriad-screen-shot.png

## Game-play:
The maps for each level will have the same basic structure. This structure will consist of three main sections. Two sections, each approximately 1/5 the total window’s width will remain fixed on either side. The player’s movement will be restricted to these two sections. These two sections are able to be accessed from one another by walking off the screen. The player will be prevented from entering into the third section (described next), by a river obstacle extending from top to bottom of the map. The third main section, that is, the section lying between the two aforementioned sections and rivers bordering these sections, will contain the enemy characters. Myriad will have two types of enemy characters. The first, are the “bulldozer” types. The bulldozer types’ behavior is simple: Progress towards the bottom of the map in a straight line and clear obstacles that might be in the way. The second “drone” type of enemy character will fire projectiles at the player and attempt to defend the bulldozers from the player’s return fire. The terrain of the third section, consisting of obstacles like rocks, mud, and shrubbery will be randomly generated. With each new beginning of the level, the amounts of the various obstacles will vary, thus making it more or less difficult for the bulldozers to progress towards the bottom.

## Objective & Win/Loss Conditions:
Through the game-play previously described, the player will attempt to win the game by destroying the bulldozers before they reach the bottom of the map. The player losses if any of the two events occur:
1. The bulldozers reach the bottom of the map, or
2. the player is hit three times by enemy projectiles.
The final score for the level will be the project of the number of drone enemies destroyed and the remaining distance between the bulldozers and the bottom of the map.

## Game Features / Player-Enemy Interaction:
The player’s only method of attack is the firing of projectiles. The player will attempt to destroy all bulldozer enemies with these projectiles. The bulldozer enemies will be more durable than the drone enemies which the player may also choose to destroy in order to expose the bulldozers or eliminate the drones as a source of enemy fire. The drone enemies will attempt to land hits on the player with projectiles of there own. If struck by one of these projectiles, the player’s available life count will be reduced by one, and the player will enter into a temporary state of invulnerability. Randomly positioned obstacles (where the amount of each type of obstacle is also a random number) will each offer some amount of resistance to the bulldozers. The bulldozers will be delayed for a longer period of time removing rock obstacles than removing shrubbery obstacles. Additionally there may be a third obstacle offering less resistance than the shrubbery.
