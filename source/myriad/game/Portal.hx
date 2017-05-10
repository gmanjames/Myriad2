package myriad.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import myriad.core.state.FSM;

import myriad.game.PlayerNormState;

class Portal extends FlxSprite
{
  public var endpoint:FlxPoint;
  public var ready(get, set):Bool;
  private var timeUntilReady:Float;

  public function new(?X:Float, ?Y:Float)
  {
    super(X, Y);
    endpoint = new FlxPoint(X, Y);
    timeUntilReady = 0;
    immovable = true;
    makeGraphic(32, 32, FlxColor.BLUE);
  }

  public override function update(elapsed:Float):Void
  {
    if (timeUntilReady > 0)
    {
      timeUntilReady -= elapsed;
    }
    else
    {
        cast(FlxG.state, PlayState).isTeleporting = false;
    }
  }

  public function get_ready():Bool
  {
    if (timeUntilReady <= 0)
      return true;

    return false;
  }

  public function set_ready(ready:Bool):Bool
  {
    if (!ready)
      timeUntilReady = 2;
    else
      timeUntilReady = 0;

    return ready;
  }

  public function teleport(player:Player):Void
  {
    player.x = endpoint.x;
    player.y = endpoint.y;
  }
}
