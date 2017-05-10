package myriad.game;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import myriad.core.state.FSM;

class Drone extends FlxSprite
{
  private var speed:Float = 150;
  private var brain:FSM;
  private var arrivedAtCorner:Bool;
  private var bulldozer:Bulldozer;
  private var nextCorner:FlxPoint;
  private var fireClock:Float;

  public function new(bulldzer:Bulldozer)
  {
    super();
    makeGraphic(20, 20, FlxColor.RED);
    health = 5;
    bulldozer = bulldzer;


    x = bulldozer.x + FlxG.random.int(-1, 1, [0]) * 70;
    y = bulldozer.y + FlxG.random.int(-1, 1, [0]) * 70;
    arrivedAtCorner = true;
    nextCorner = new FlxPoint();

    getNextCorner();

    path = new FlxPath();
    velocity.x = speed;
    velocity.y = bulldozer.velocity.y;

    fireClock = 2;
  }

  public override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    fireClock -= elapsed;

    if (path.finished)
      arrivedAtCorner = true;

    if (arrivedAtCorner)
    {
      var pathTo = new FlxPath();
      var points:Array<FlxPoint> = [];
      getNextCorner();

      path = pathTo;
      points.push(new FlxPoint(x + width / 2, y + height / 2)); // current corner
      points.push(nextCorner);
      pathTo.start(points, 200, FlxPath.FORWARD, true);
      arrivedAtCorner = false;
    }

    var flipx = Math.cos(angle);
    var flipy = Math.sin(angle);

    if (flipx > 0)
      facing = FlxObject.RIGHT;
    else if (flipx < 0)
      facing = FlxObject.LEFT;

    if (flipy > 0)
      facing = FlxObject.UP;
    else if (flipy < 0)
      facing = FlxObject.DOWN;

    if (facing == FlxObject.UP || facing == FlxObject.DOWN)
    {
      if (fireClock <= 0)
      {
        if (facing == FlxObject.UP && x > cast(FlxG.state, PlayState).player.x
          || facing == FlxObject.DOWN && x < cast(FlxG.state, PlayState).player.x)
        {
          if (FlxG.random.bool(57))
            fireBullet();
        }

        fireClock = FlxG.random.float(0.2, 0.5);
      }
    }
  }

  private function getNextCorner():Void
  {
    if (x < bulldozer.x)
    {
      if (y < bulldozer.y)
      {
        nextCorner.x = (bulldozer.x + bulldozer.width / 2) + 70 + width / 2;
        nextCorner.y = (bulldozer.y + bulldozer.height / 2) - 70 - height / 2;
      }
      else
      {
        nextCorner.x = (bulldozer.x + bulldozer.width / 2) - 70 - width / 2;
        nextCorner.y = (bulldozer.y + bulldozer.height / 2) - 70 - height / 2;
      }
    }
    else if (x > bulldozer.x)
    {
      if (y < bulldozer.y)
      {
        nextCorner.x = (bulldozer.x + bulldozer.width / 2) + 70 + width / 2;
        nextCorner.y = (bulldozer.y + bulldozer.height / 2) + 70 + height / 2;
      }
      else
      {
        nextCorner.x = (bulldozer.x + bulldozer.width / 2) - 70 - width / 2;
        nextCorner.y = (bulldozer.y + bulldozer.height / 2) + 70 + height / 2;
      }
    }

    if (!bulldozer.exists)
      kill();
  }

  public function fireBullet():Void
  {
    var bullets = cast(FlxG.state, PlayState).enemyBullets;
    var bullet1 = bullets.recycle();
    var bullet2 = bullets.recycle();
    var bullet3 = bullets.recycle();

    bullet1.reset(x + width / 2, y + height / 2);
    bullet2.reset(x + width / 2, y + height / 2);
    bullet3.reset(x + width / 2, y + height / 2);

    var direction = 0;
    var player = cast(FlxG.state, PlayState).player;
    if (player.x < x)
    {
      direction = -1;
    }
    else
    {
      direction = 1;
    }

    bullet1.velocity.x = direction * 350; // straight line

    bullet2.velocity.x = direction * 350; // slightly diagonal
    bullet2.velocity.y = -100;

    bullet3.velocity.x = direction * 350; // slightly diagonal
    bullet3.velocity.y = 100;
  }

  public function placeAtCorner(corner:Int):Void
  {
    switch(corner)
    {
      case 0:
        x = bulldozer.x - 70;
        y = bulldozer.y - 70;
      case 1:
        x = bulldozer.x + 70;
        y = bulldozer.y - 70;
      case 2:
        x = bulldozer.x + 70;
        y = bulldozer.y + 70;
      case 3:
        x = bulldozer.x - 70;
        y = bulldozer.y + 70;
    }
  }
}
