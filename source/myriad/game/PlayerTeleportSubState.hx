package myriad.game;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import myriad.core.state.BaseState;
import flixel.util.FlxSpriteUtil;

class PlayerTeleportSubState extends BaseState
{
  public function new(?nextState:BaseState)
  {
    super(nextState);
  }

  public override function enter(player:FlxObject):BaseState
  {
    FlxSpriteUtil.flicker(cast(player, FlxSprite), duration);
    return this;
  }

  public function reset(duration:Float):Void
  {
    this.duration = duration;
  }

  private override function action(player:FlxObject):Void
  {
    player.velocity.set(0, 0);
  }
}
