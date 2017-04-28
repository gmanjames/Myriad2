package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import openfl.Assets;

import myriad.core.factory.ObstacleFactory;

import myriad.game.Player;
import myriad.game.Obstacle;
import myriad.game.ObstacleManager;

class PlayState extends FlxState
{
	// Global static member for the dimensions of various components
	public static var TILE_WIDTH:Int = 32;

	// Player sprite
	public var player:Player;

	// Obstacle management - loading terrain at initialization of state
	public var defaultObstacleConf:ObstacleConfiguration;
	public var vertLineObstacleConf:ObstacleConfiguration;
	public var starObstacleConf:ObstacleConfiguration;
	private var obstManager:ObstacleManager;
	private var obstacles:FlxGroup;
	private var borders:FlxGroup;

	// Areas for player movement
	private var leftSide:FlxSprite;
	private var rightSide:FlxSprite;

	override public function create():Void
	{
		super.create();

		// Create side sections where player will move
		leftSide  = new FlxSprite(0, 0);
		rightSide = new FlxSprite(FlxG.width - TILE_WIDTH * 3, 0);
		leftSide.active = rightSide.active = false;
		leftSide.makeGraphic(TILE_WIDTH * 3, FlxG.height, FlxColor.GREEN);
		rightSide.makeGraphic(TILE_WIDTH * 3, FlxG.height, FlxColor.GREEN);
		add(leftSide);
		add(rightSide);

		// Create player and add to state
		player = new Player(0, 0);
		add(player);

		// Obstacle tests
		defaultObstacleConf  = new ObstacleConfiguration(Assets.getText("assets/data/00-single.txt"));
		vertLineObstacleConf = new ObstacleConfiguration(Assets.getText("assets/data/01-vertical-line.txt"));
		starObstacleConf  = new ObstacleConfiguration(Assets.getText("assets/data/02-star.txt"));
		obstManager = new ObstacleManager();
		loadObstacles();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player, borders);
	}

	private function loadObstacles():Void
	{
		var rows = Std.int(FlxG.height / TILE_WIDTH);
		var cols = Std.int(FlxG.width  / TILE_WIDTH);

		// First load the river obstacles
		borders = new FlxGroup();
		for (i in 0...rows)
		{
			if (i % ObstacleConfiguration.CONF_SIZE == 0)
			{
				var borderLeft  = obstManager.fetch(ObstacleType.WATER, vertLineObstacleConf);
				var borderRight = obstManager.fetch(ObstacleType.WATER, vertLineObstacleConf);
				ObstacleManager.positionAtRowCol(borderLeft,  i,  2);
				ObstacleManager.positionAtRowCol(borderRight, i, 20);
				borders.add(borderLeft);
				borders.add(borderRight);
			}
		}

		add(borders);


		// Obstacles of random position and number
		//...
		obstacles = new FlxGroup();
		var rockConf = obstManager.fetch(ObstacleType.ROCK, starObstacleConf);
		ObstacleManager.positionAtRowCol(rockConf, 5, 6);
		obstacles.add(rockConf);
		add(obstacles);
	}

}
