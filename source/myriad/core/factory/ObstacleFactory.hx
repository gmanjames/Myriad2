package myriad.core.factory;

import flixel.FlxObject;
import flixel.group.FlxGroup;

import myriad.game.Obstacle;

class ObstacleFactory
{
  private static var POOL_SIZE:Int = 50;
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
    obst.type = type;
    obst.immovable = true;
    return obst;
  }
}
