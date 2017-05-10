package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import openfl.Assets;
import myriad.core.factory.ObstacleFactory;
import myriad.game.Player;
import myriad.game.Portal;
import myriad.game.Bulldozer;
import myriad.game.Drone;
import myriad.game.Obstacle;
import myriad.game.ObstacleManager;

class PlayState extends FlxState
{
	// Global static member for the dimensions of various components
	public static var TILE_WIDTH:Int = 32;

	// Player sprite
	public var player:Player;
	public var playerBullets:FlxTypedGroup<FlxSprite>;
	public var enemyBullets:FlxTypedGroup<FlxSprite>;

	// Enemies
	public var bulldozers:FlxTypedGroup<Bulldozer>;
	public var drones:FlxTypedGroup<Drone>;
	public var enemies:FlxGroup;


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
	public var leftSide:FlxSprite;
	public var rightSide:FlxSprite;

	// Portals to move between sides
	private var portals:FlxGroup;

	// Game flags
	public  var isTeleporting:Bool;
	public  var beginTeleport:Bool;
	private var gameOver:Bool;

	override public function create():Void
	{
		super.create();

		var background = new FlxSprite(0, 0);
		var bgColor = new FlxColor();
		bgColor.setRGB(128, 255, 128);
		background.makeGraphic(FlxG.width, FlxG.height, bgColor);
		background.active = false;

		add(background);

		// Create side sections where player will move
		leftSide  = new FlxSprite(0, 0);
		rightSide = new FlxSprite(FlxG.width - TILE_WIDTH * 4, 0);
		leftSide.active = rightSide.active = false;
		leftSide.makeGraphic(TILE_WIDTH * 4, FlxG.height, FlxColor.GREEN);
		rightSide.makeGraphic(TILE_WIDTH * 4, FlxG.height, FlxColor.GREEN);
		leftSide.facing  = FlxObject.RIGHT;
		rightSide.facing = FlxObject.LEFT;

		add(leftSide);
		add(rightSide);

		// Create portals for player used
		portals = new FlxGroup();
		var leftPortal = new Portal(0, FlxG.height / 2 - TILE_WIDTH);
		var rightPortal = new Portal(FlxG.width - TILE_WIDTH, FlxG.height / 2 - TILE_WIDTH);
		leftPortal.endpoint = new FlxPoint(rightPortal.x - TILE_WIDTH, rightPortal.y);
		rightPortal.endpoint = new FlxPoint(leftPortal.x + TILE_WIDTH, leftPortal.y);

		portals.add(leftPortal);
		portals.add(rightPortal);
		add(portals);

		// Create Enemies
		bulldozers = new FlxTypedGroup<Bulldozer>();
		var bulldozer1 = new Bulldozer(((FlxG.width / TILE_WIDTH) / 2) * TILE_WIDTH, 0);
		var bulldozer2 = new Bulldozer(((FlxG.width / TILE_WIDTH) / 2) * TILE_WIDTH - 3 * TILE_WIDTH, 0);

		drones = new FlxTypedGroup<Drone>();
		var drone1 = new Drone(bulldozer1);
		var drone2 = new Drone(bulldozer2);
		//var drone3 = new Drone(bulldozer2);

		drone2.placeAtCorner(0);
		//drone3.placeAtCorner(2);

		bulldozers.add(bulldozer1);
		bulldozers.add(bulldozer2);
		add(bulldozers);

		drones.add(drone1);
		drones.add(drone2);
		//drones.add(drone3);
		add(drones);

		enemies = new FlxGroup();
		enemies.add(drones);
		enemies.add(bulldozers);

		enemyBullets = new FlxTypedGroup<FlxSprite>(15);
		for (i in 0...15)
		{
			var bullet = new FlxSprite();
			bullet.makeGraphic(6, 6, FlxColor.RED);
			bullet.exists = false;
			enemyBullets.add(bullet);
		}

		add(enemyBullets);

		// Create player and add to state
		player = new Player(5, 5);
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
		beginTeleport = false;
		isTeleporting = false;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		checkBulletsInsideBounds();
		checkEnemiesInsideBoundsOrDead();

		if (!gameOver)
		{
			beginTeleport = false;

			if (!isTeleporting)
			{
				bulldozers.active = true;
				drones.active = true;
				enemyBullets.active = true;
			}

			// Make sure player cannot cross over borders
			FlxG.collide(player, borders);

			// Enemy/obstacle interaction
			FlxG.overlap(bulldozers, obstacles, bulldozerOverlapObstacle);

			// Enemy/player bullet interaction
			FlxG.overlap(playerBullets, enemies, playerBulletOverlapEnemy);

			// Player walks into portals
			FlxG.overlap(player, portals, playerOverlapPortals);

			// Player gets hit by a bullet
			FlxG.overlap(player, enemyBullets, playerOverlapEnemyBullets);
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
				if (FlxG.random.bool(35))
				{
					currentConfiguration = sparseObstacleConf;
				}

				// Here, determine a random obstacle type
				var currentType:ObstacleType = ObstacleType.BRUSH;
				if (FlxG.random.bool(35))
				{
					currentType = ObstacleType.SHRUB;
				}
				if (FlxG.random.bool(35))
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

		if (enemy.health == 0)
		{
			enemy.kill();
		}

		bullet.kill();
	}

	private function checkEnemiesInsideBoundsOrDead():Void
	{
		var allBulldozersInMap = true;
		var allBulldozersDead = true;
		for (bulldozer in bulldozers)
		{
			if (!bulldozer.inWorldBounds())
			{
				allBulldozersInMap = false;
			}

			if (bulldozer.exists)
			{
				allBulldozersDead = false;
			}
		}

		if (!allBulldozersInMap || allBulldozersDead)
		{
			gameOver = true;
		}
	}

	private function checkBulletsInsideBounds():Void
	{
		for (bullet in enemyBullets)
		{
			if (bullet.x > FlxG.width || bullet.x < 0)
				bullet.kill();
		}
	}

	private function playerOverlapPortals(player:Player, portal:Portal):Void
	{
		if (portal.ready)
		{
			beginTeleport = true;
			isTeleporting = true;

			for (exit in portals)
			{
				cast(exit, Portal).ready = false;
			}

			bulldozers.active = false;
			drones.active = false;
			enemyBullets.active = false;
			portal.teleport(player);
		}
	}

	private function playerOverlapEnemyBullets(player:FlxObject, bullet:FlxObject):Void
	{
		if (!FlxSpriteUtil.isFlickering(player))
		{
			player.health -= 1;

			if (player.health == 0)
			{
				player.kill();
				gameOver = true;
			}
			else
			{
					FlxSpriteUtil.flicker(player, 1.5);
			}

			bullet.kill();
		}
	}
}
