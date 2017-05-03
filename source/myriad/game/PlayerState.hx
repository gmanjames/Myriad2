package myriad.game;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.keyboard.FlxKey;

import myriad.core.state.BaseState;

class PlayerState extends BaseState
{
  private static var SPEED:Float = 200;

  public function new()
  {
    super();
  }

  private override function action(object:FlxObject):Void
  {
    if (FlxG.keys.anyPressed([FlxKey.SPACE]))
    {
      (cast object).fireBullet();
    }

    super.action(object);
  }
}
