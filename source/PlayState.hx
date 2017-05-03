package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.Assets;
import myriad.core.factory.ObstacleFactory;
import myriad.game.Player;
import myriad.game.Bulldozer;
import myriad.game.Obstacle;
import myriad.game.ObstacleManager;

class PlayState extends FlxState
{
	// Global static member for the dimensions of various components
	public static var TILE_WIDTH:Int = 32;

	// Player sprite
	public var player:Player;
	public var playerBullets:FlxTypedGroup<FlxSprite>;

	// Enemies
	public var bulldozers:FlxTypedGroup<Bulldozer>;
	public var scouts:FlxGroup;


	public var defaultObstacleConf:ObstacleConfiguration;
	public var vertLineObstacleConf:ObstacleConfiguration;
	public var starObstacleConf:ObstacleConfiguration;
	public var sparseObstacleConf:ObstacleConfiguration;
	public var gateObstacleConf:ObstacleConfiguration;

	// Obstacle management - loading terrain at initialization of state
	private var obstManager:ObstacleManager;
	private var obstacles:FlxGroup;
	private var borders:FlxGroup;

	// Areas for player movement
	private var leftSide:FlxSprite;
	private var rightSide:FlxSprite;

	// Game flags
	private var gameOver:Bool;

	override public function create():Void
	{
		super.create();

		// Create side sections where player will move
		leftSide  = new FlxSprite(0, 0);
		rightSide = new FlxSprite(FlxG.width - TILE_WIDTH * 4, 0);
		leftSide.active = rightSide.active = false;
		leftSide.makeGraphic(TILE_WIDTH * 4, FlxG.height, FlxColor.GREEN);
		rightSide.makeGraphic(TILE_WIDTH * 4, FlxG.height, FlxColor.GREEN);

		add(leftSide);
		add(rightSide);

		// Create Enemies
		bulldozers = new FlxTypedGroup<Bulldozer>();
		var bulldozer = new Bulldozer(((FlxG.width / TILE_WIDTH) / 2) * TILE_WIDTH, 0);
		bulldozers.add(bulldozer);
		add(bulldozers);

		// Create player and add to state
		player = new Player(0, 0);
		add(player);

		playerBullets = new FlxTypedGroup<FlxSprite>(15);
		for (i in 0...15)
		{
			var bullet = new FlxSprite();
			bullet.makeGraphic(6, 6, FlxColor.YELLOW);
			bullet.exists = false;
			playerBullets.add(bullet);
		}

		add(playerBullets);

		// Load obstacle configurations to be used in level generation
		defaultObstacleConf  = new ObstacleConfiguration(Assets.getText("assets/data/00-single.txt"));
		vertLineObstacleConf = new ObstacleConfiguration(Assets.getText("assets/data/01-vertical.txt"));
		starObstacleConf     = new ObstacleConfiguration(Assets.getText("assets/data/02-star.txt"));
		sparseObstacleConf   = new ObstacleConfiguration(Assets.getText("assets/data/03-sparse.txt"));
		gateObstacleConf     = new ObstacleConfiguration(Assets.getText("assets/data/04-gate.txt"));

		// Obstacle manager to request and position obstacles
		obstManager = new ObstacleManager();
		loadObstacles();

		gameOver = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		checkEnemiesInsideBounds();
		if (!gameOver)
		{
			// Make sure player cannot cross over borders
			FlxG.collide(player, borders);

			// Enemy/obstacle interaction
			FlxG.overlap(bulldozers, obstacles, bulldozerOverlapObstacle);

			// Enemy/player bullet interaction
			FlxG.overlap(playerBullets, bulldozers, playerBulletOverlapEnemy);
		}
		else
		{
			FlxG.resetState();
		}
	}

	private function loadObstacles():Void
	{
		var rows = Std.int((FlxG.height / TILE_WIDTH) / 3) + 1;
		var cols = Std.int((FlxG.width  / TILE_WIDTH) / 3) - 1; // subtract one here to account for side sections

		// Obstacles of random position and number
		//...
		borders   = new FlxGroup();
		obstacles = new FlxGroup();

		// Invisible borders
		var hiddenLeftBorder   = new FlxObject(-3, 0, 5, FlxG.height);
		var hiddenRightBorder  = new FlxObject(FlxG.width - 2, 0, 5, FlxG.height);
		var hiddenTopBorder    = new FlxObject(0, -3, FlxG.width, 5);
		var hiddenBottomBorder = new FlxObject(0, FlxG.height - 2, FlxG.width, 5);

		hiddenLeftBorder.immovable = true;
		hiddenRightBorder.immovable = true;
		hiddenTopBorder.immovable = true;
		hiddenBottomBorder.immovable = true;

		borders.add(hiddenLeftBorder);
		borders.add(hiddenRightBorder);
		borders.add(hiddenTopBorder);
		borders.add(hiddenBottomBorder);

		for (row in 0...rows)
		{
			// First create the side river obstacles
			var borderLeft  = obstManager.fetch(ObstacleType.WATER, vertLineObstacleConf);
			var borderRight = obstManager.fetch(ObstacleType.WATER, vertLineObstacleConf);

			ObstacleManager.positionAtRowCol(borderLeft,  row * 3,  3);
			ObstacleManager.positionAtRowCol(borderRight, row * 3, 19);

			borders.add(borderLeft);
			borders.add(borderRight);

			// Traverse laterally across the map to load game obstacles
			for (col in 2...cols)
			{
				// Here, determine a random configuration
				var currentConfiguration:ObstacleConfiguration = defaultObstacleConf;
				if (FlxG.random.bool(30)) // 30% chance of configuration being of type 'star'
				{
					currentConfiguration = starObstacleConf;
				}
				if (FlxG.random.bool(25))
				{
					currentConfiguration = sparseObstacleConf;
				}

				// Here, determine a random obstacle type
				var currentType:ObstacleType = ObstacleType.BRUSH;
				if (FlxG.random.bool(30))
				{
					currentType = ObstacleType.SHRUB;
				}
				if (FlxG.random.bool(25))
				{
					currentType = ObstacleType.ROCK;
				}

				// Here, determine whether or not to place configuration
				if (FlxG.random.bool(70))
				{
					var conf = obstManager.fetch(currentType, currentConfiguration);
					ObstacleManager.positionAtRowCol(conf, (row * 3) + 1, (col * 3) - 1); // want to begin at col 4 (or 3 if 0, 1, 2...)
					obstacles.add(conf);
				}
			}
		}

		add(borders);
		add(obstacles);
	}

	private function bulldozerOverlapObstacle(bulldozer:FlxObject, obstacle:Obstacle):Void
	{
		FlxG.collide(bulldozer, obstacle);

		if (cast(obstacle, Obstacle).durability <= 0)
		{
			obstacle.kill();
		}
		else
		{
			obstacle.durability -= FlxG.elapsed;
		}
	}

	private function playerBulletOverlapEnemy(bullet:FlxObject, enemy:FlxObject):Void
	{
		enemy.health -= 1;
		trace(enemy.health);

		if (enemy.health == 0)
		{
			enemy.kill();
		}

		bullet.kill();
	}

	private function checkEnemiesInsideBounds():Void
	{
		var allBulldozersInMap = true;
		for (bulldozer in bulldozers)
		{
			if (!bulldozer.inWorldBounds())
			{
				allBulldozersInMap = false;
			}
		}

		if (!allBulldozersInMap)
		{
			gameOver = true;
		}
	}
}
