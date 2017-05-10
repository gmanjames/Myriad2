package myriad.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import myriad.core.state.FSM;

import myriad.game.PlayerNormState;

class Player extends FlxSprite
{
  public  var changingZones:Bool;
  private var brain:FSM;
  private var fireClock:Float;

  public function new(?X:Float, ?Y:Float)
  {
    super(X, Y);

    brain = new FSM( new PlayerNormState() );

    fireClock = 0; // zero so you can fire as soon as the game starts

    health = 5;

    changingZones = false;

    makeGraphic(32, 32, FlxColor.ORANGE);
  }

  public override function update(elapsed:Float):Void
  {
    // count down fireClock
    fireClock -= FlxG.elapsed;

    brain.update(this);
    super.update(elapsed);
  }

  public function fireBullet():Void
  {
    if (fireClock <= 0)
    {
      var state = cast(FlxG.state, PlayState);
      var bullet = state.playerBullets.recycle();
      bullet.reset(x + width / 2, y + height / 2);

      if (state.leftSide.overlaps(this))
      {
        bullet.velocity.x = 550;
      }
      else if (state.rightSide.overlaps(this))
      {
        bullet.velocity.x = -550;
      }

      fireClock = 0.5;
    }
  }
}
