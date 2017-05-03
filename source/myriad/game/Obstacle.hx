package myriad.game;

import flixel.FlxSprite;
import flixel.util.FlxColor;


/**
 * ...
 * @author Garren Ijames
 */
abstract ObstacleType(Float) from Float to Float {
  public static inline var WATER:Float = 4;
  public static inline var ROCK:Float  = 3;
  public static inline var SHRUB:Float = 2;
  public static inline var BRUSH:Float = 1;
  public static inline var SOME:Float = -1;
  public static inline var NONE:Float = -2; // Represents empty cells of an ObstacleConf'
}

abstract ObstacleConfiguration(String) from String to String {
    public static inline var CONF_SIZE:Int = 3;

    inline public function new(pattern:String)
    {
      this = new EReg("\n", "g").replace(pattern, "");
    }

    inline public function at(row:Int, col:Int):ObstacleType {
      var rowOffset:Int = row * CONF_SIZE;
      var index:Int = rowOffset + col;
      if (this.charAt(index) == "1")
      {
        return ObstacleType.SOME;
      }
      return ObstacleType.NONE;
    }
}

@:forward(x, y, immovable, kill, revive, loadGraphic)
abstract Obstacle(FlxSprite) from FlxSprite to FlxSprite
{
  public var durability(get, set):ObstacleType;

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

  public function set_durability(durability:Float):ObstacleType
  {
    getThis().health = durability;
    return durability;
  }
}
