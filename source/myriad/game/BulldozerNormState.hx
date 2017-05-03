package myriad.game;

import flixel.FlxG;
import flixel.FlxObject;

import myriad.core.state.BaseState;

class BulldozerNormState extends BaseState
{
  public function new()
  {
    super();
  }

  private override function action(object:FlxObject):Void
  {
    object.velocity.y = 30;
  }
}
