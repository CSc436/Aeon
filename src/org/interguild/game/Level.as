package org.interguild.game {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.interguild.game.collision.CollisionGrid;
	import org.interguild.game.tiles.CollidableObject;

	/**
	 * Level will handle the actual gameplay. It's responsible for
	 * constructing itself based off of the level encoding, but it
	 * is not responsible for displaying its preloading progress
	 * to the user.
	 *
	 * Level controls the camera, game logic, etc.
	 */
	public class Level extends Sprite {

		public static const GRAVITY:Number = 4;

		private static const FRAME_RATE:uint = 30;
		private static const PERIOD:Number = 1000 / FRAME_RATE;

		private static const TEST_LEVEL_FILE:String = "../testlevel.txt";

		private var camera:Sprite;
		private var player:Player;
		private var collisionGrid:CollisionGrid;

		private var timer:Timer;

		public function Level() {
			//initialize camera
			camera = new Sprite();
			addChild(camera);

			//init player
			player = new Player();
			camera.addChild(player);

			//load test level
			var loader:LevelLoader = new LevelLoader(TEST_LEVEL_FILE, this);
			loader.start();
		}

		/**
		 * Called by LevelLoader
		 */
		public function setLevelSize(lvlWidth:Number, lvlHeight:Number):void {
			collisionGrid = new CollisionGrid(lvlWidth, lvlHeight);
		}

		/**
		 * Called by LevelLoader when complete.
		 */
		public function startGame():void {
			/*DEBUG*/
			addChild(collisionGrid);
			/*END DEBUG*/
			
			//init game loop
			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
			timer.start();
		}

		/**
		 * Called 30 frames per second.
		 */
		private function onGameLoop(evt:TimerEvent):void {
			player.onGameLoop();
			// To DO call game loop on active objects
			// 
			// To DO collision detection
		}

		/********************************
		 * Initialization methods below *
		 ********************************/

		/**
		 * Player is already initialized, but LevelLoader
		 * needs to specify its location.
		 */
		public function setPlayer(px:Number, py:Number):void {
			player.setStartPosition(px, py);
		}

		public function createCollidableObject(tile:CollidableObject):void {
			collisionGrid.addObject(tile);
			// TODO need to add tile to list of all objects
			// TODO add tiles to collision grid
			camera.addChild(tile);
		}
	}
}
