package myriad.game;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

import myriad.core.state.BaseState;

class PlayerNormState extends BaseState
{
  private static var SPEED:Float = 200;

  public function new()
  {
    super();
  }

  private override function transition(object:FlxObject):Bool
  {
    var player = cast(object, Player);

    //...

    return super.transition(object);
  }

  private override function action(object:FlxObject):Void
  {
    var player = cast(object, Player);

    var up:Bool   = FlxG.keys.anyPressed([FlxKey.UP]);
    var down:Bool = FlxG.keys.anyPressed([FlxKey.DOWN]);
    var left:Bool = FlxG.keys.anyPressed([FlxKey.LEFT]);
    var rght:Bool = FlxG.keys.anyPressed([FlxKey.RIGHT]);

    player.velocity.set(0, 0);

    if (up || down || left || rght)
    {
      if (up)
      {
        player.velocity.y = -SPEED;
      }
      else if (down)
      {
        player.velocity.y = SPEED;
      }
      else if (left)
      {
        player.velocity.x = -SPEED;
      }
      else if (rght)
      {
        player.velocity.x = SPEED;
      }
    }


    super.action(object);
  }
}
