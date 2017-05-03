package myriad.core.factory;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import myriad.game.Obstacle;

class ObstacleFactory
{
  private static var POOL_SIZE:Int = 200;
  private var obstacles:FlxTypedGroup<Obstacle>;

  public function new()
  {
    obstacles = new FlxTypedGroup<Obstacle>(POOL_SIZE);

    for (i in 0...POOL_SIZE)
    {
      var obst:Obstacle = new Obstacle();
      obst.kill();
      obstacles.add(obst);
    }
  }

  public function getObstacle(type:ObstacleType):Obstacle
  {
    var obst = obstacles.getFirstAvailable();
    obst.revive();
    obst.durability = type;
    obst.immovable = true;
    switch (type)
    {
      case ObstacleType.WATER:
        obst.loadGraphic(AssetPaths.water1__png, false, 32, 32);
      case ObstacleType.ROCK:
        obst.loadGraphic(AssetPaths.rock1__png, false, 32, 32);
      case ObstacleType.SHRUB:
        obst.loadGraphic(AssetPaths.shrub1__png, false, 32, 32);
      case ObstacleType.BRUSH:
        obst.loadGraphic(AssetPaths.brush1__png, false, 32, 32);
    }

    return obst;
  }
}
