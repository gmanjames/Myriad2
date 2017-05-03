package myriad.game;

import openfl.Assets;

import myriad.core.factory.ObstacleFactory;

import myriad.game.Obstacle;

import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 *
 */
class ObstacleManager
{
  private static var OBSTACLE_SIZE:Int = 32;

  private var obstFactory:ObstacleFactory;

  public function new()
  {
    obstFactory = new ObstacleFactory();
  }

  /**
   *
   */
  public function fetch(type:ObstacleType,
    ?conf:ObstacleConfiguration):FlxTypedGroup<Obstacle>
  {
    if (conf == null)
    {
      conf = (cast FlxG.state).defaultObstacleConf;
    }

    var order = new FlxTypedGroup<Obstacle>();
    var rows = ObstacleConfiguration.CONF_SIZE;
    var cols = rows;
    for (row in 0...rows)
    {
      for (col in 0...cols)
      {
        if (conf.at(row, col) == ObstacleType.SOME)
        {
          var obst:Obstacle = obstFactory.getObstacle(type);
          obst.x = col * OBSTACLE_SIZE;
          obst.y = row * OBSTACLE_SIZE;
          order.add(obst);
        }
      }
    }

    return order;
  }

  public static function positionAtRowCol(obstacles:FlxTypedGroup<Obstacle>, row:Float, col:Float):Void
  {
    var xPos = col * PlayState.TILE_WIDTH;
    var yPos = row * PlayState.TILE_WIDTH;

    for (obst in obstacles)
    {
      obst.x += xPos;
      obst.y += yPos;
    }
  }
}
