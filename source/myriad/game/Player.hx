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

  public function new(?X:Float, ?Y:Float)
  {
    super(X, Y);

    brain = new FSM( new PlayerNormState() );

    makeGraphic(32, 32, FlxColor.ORANGE);
  }

  public override function update(elapsed:Float):Void
  {
    brain.update(this);
    super.update(elapsed);
  }
}
