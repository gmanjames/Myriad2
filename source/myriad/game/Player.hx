package myriad.game;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import myriad.core.state.FSM;

import myriad.game.PlayerNormState;

class Player extends FlxSprite
{
  private var brain:FSM;
  private var fireClock:Float;

  public function new(?X:Float, ?Y:Float)
  {
    super(X, Y);

    brain = new FSM( new PlayerNormState() );

    fireClock = 0; // zero so you can fire as soon as the game starts

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
      var bullet = cast(FlxG.state, PlayState).playerBullets.recycle();
      bullet.reset(x + width / 2, y + height / 2);
      bullet.velocity.x = 600;

      fireClock = 1;
    }
  }
}
