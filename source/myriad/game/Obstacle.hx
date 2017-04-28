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

@:forward(x, y, immovable, kill, revive)
abstract Obstacle(FlxSprite) from FlxSprite to FlxSprite
{
  public var type(get, set):ObstacleType;

  inline public function new(?type:Float = -1)
  {
    this = new FlxSprite();
    this.health = type;
  }

  inline private function getThis():FlxSprite
  {
      return this;
  }

  public function get_type():ObstacleType
  {
    return getThis().health;
  }

  public function set_type(type:ObstacleType):ObstacleType
  {
    getThis().health = type;
    switch (type)
    {
      case ObstacleType.WATER:
        this.loadGraphic(AssetPaths.water1__png, false, 32, 32);
      case ObstacleType.ROCK:
        this.loadGraphic(AssetPaths.rock1__png, false, 32, 32);
      case ObstacleType.SHRUB:
        this.loadGraphic(AssetPaths.water1__png);
      case ObstacleType.BRUSH:
        this.loadGraphic(AssetPaths.water1__png);
    }

    return type;
  }
}
