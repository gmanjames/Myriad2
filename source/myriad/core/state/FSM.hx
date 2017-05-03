package myriad.core.state;

import flixel.FlxObject;

class FSM
{
  public var activeState:BaseState;
  public var transitionState:BaseState;

  public function new(initState:BaseState)
  {
    activeState = initState;
  }

  public function update(object:FlxObject):Void
  {
    var nextState = activeState.update(object);

    if (nextState != null)
    {
      activeState = nextState;
    }
  }
}
