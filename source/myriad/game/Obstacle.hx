package myriad.game;

import flixel.FlxSprite;

import flixel.util.FlxColor;


/**
 * ...
 * @author Garren Ijames
 */

abstract ObstacleType(Float) from Float to Float {
  public static inline var ROCK:Float  = 3;
  public static inline var SHRUB:Float = 2;
  public static inline var BRUSH:Float = 1;
}

@:forward(x, y, kill, revive)
abstract Obstacle(FlxSprite) from FlxSprite to FlxSprite
{
  public var durability(get, set):Float;

  inline public function new(?durability:Float = -1)
  {
    this = new FlxSprite();
    this.health = durability;
  }

  inline private function getThis():FlxSprite
  {
      return this;
  }

  public function get_durability():Float
  {
    return getThis().health;
  }

  public function set_durability(d:Float):Float
  {
    getThis().health = d;
    return d;
  }
}
