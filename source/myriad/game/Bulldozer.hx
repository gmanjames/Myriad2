package myriad.game;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import myriad.core.state.FSM;

class Bulldozer extends FlxSprite
{
  private var brain:FSM;

  public function new(?X:Float, ?Y:Float, ?numDrones:Int = 1)
  {
    super(X, Y);
    makeGraphic(32, 32, FlxColor.RED);
    var initState = new BulldozerNormState();
    brain = new FSM( new BulldozerNormState().enter(this) );
    health = 15;
  }

  public override function update(elapsed:Float):Void
  {
    brain.update(this);
    super.update(elapsed);
  }
}
