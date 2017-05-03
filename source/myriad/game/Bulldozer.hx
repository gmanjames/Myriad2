package myriad.game;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import myriad.core.state.FSM;

class Bulldozer extends FlxSprite
{
  private var brain:FSM;

  public function new(?X:Float, ?Y:Float)
  {
    super(X, Y);
    makeGraphic(32, 32, FlxColor.RED);
    var initState = new BulldozerNormState();
    brain = new FSM( new BulldozerNormState().enter(this) );
    health = 20;
  }

  public override function update(elapsed:Float):Void
  {
    brain.update(this);
    super.update(elapsed);
  }
}
