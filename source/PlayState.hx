package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	private static var TILE_WIDTH:Int = 32;
	public var player:Player;
	public var leftSide:FlxSprite;
	public var rightSide:FlxSprite;
	public var rocks:FlxGroup;

	override public function create():Void
	{
		super.create();

		// Two side ground graphics
		leftSide  = new FlxSprite(0, 0);
		rightSide = new FlxSprite(FlxG.width - TILE_WIDTH * 3, 0);
		leftSide.active = rightSide.active = false;
		leftSide.makeGraphic(TILE_WIDTH * 3, 480, FlxColor.GREEN);
		rightSide.makeGraphic(TILE_WIDTH * 3, 480, FlxColor.GREEN);

		add(leftSide);
		add(rightSide);

		rocks = new FlxGroup();

		// Rocks for left side barriers
		for (i in 0...15)
		{
			var rock = new FlxSprite(TILE_WIDTH * 3, i * 32);
			rock.makeGraphic(30, 30, FlxColor.BLUE);
			rock.immovable = true;
			rocks.add(rock);
		}

		// Rocks for the right side barriers
		for (i in 0...15)
		{
			var rock = new FlxSprite(FlxG.width - TILE_WIDTH * 4, i * 32);
			rock.makeGraphic(30, 30, FlxColor.BLUE);
			rock.immovable = true;
			rocks.add(rock);
		}

		add(rocks);

		// Create player and add to state
		player = new Player(0, 0);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player, rocks);
	}
}
