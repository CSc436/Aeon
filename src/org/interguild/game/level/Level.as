package org.interguild.game.level {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import flexunit.utils.ArrayList;

	import org.interguild.Aeon;
	import org.interguild.game.Player;
	import org.interguild.game.collision.CollisionGrid;
	import org.interguild.game.collision.GridTile;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.GameObject;

	/**
	 * Level will handle the actual gameplay. It's responsible for
	 * constructing itself based off of the level encoding, but it
	 * is not responsible for displaying its preloading progress
	 * to the user.
	 *
	 * Level controls the camera, game logic, etc.
	 */
	public class Level extends Sprite {

		private static var staticCall:Boolean = false;
		private static var instance:Level;

		/**
		 * We're following a variant of the singleton pattern here.
		 * Multiple instances of Level will be created throughout
		 * the program's lifetime, but only one Level will be allowed
		 * to exist at a time.
		 *
		 * Call getMe() to get a reference to the current Level.
		 * If one doesn't exist, it will return null, so watch out!
		 *
		 * Call createMe() to discard the old level and create a new
		 * one from scratch.
		 */
		public static function getMe():Level {
			return instance;
		}

		/**
		 * Discards the old level and makes a new one.
		 * Returns the newly created level.
		 */
		public static function createMe():Level {
			staticCall = true;
			instance = new Level();
			return instance;
		}

		public static const GRAVITY:Number = 4;

		private static const FRAME_RATE:uint = 30;
		private static const PERIOD:Number = 1000 / FRAME_RATE;

		private static const TEST_LEVEL_FILE:String = "../gamesaves/testlevel.txt";

		private var camera:Sprite;
		private var player:Player;

		private var progressBar:LevelProgressBar;

		private var collisionGrid:CollisionGrid;
		private var allObjects:Vector.<GameObject>;
		private var activeObjects:Vector.<GameObject>;

		private var timer:Timer;

		/**
		 * DO NOT CALL THIS CONSTRUCTOR
		 */
		public function Level() {
			if (!staticCall) {
				throw new Error("You are not allowed to call Level's constructor. Use Level.createMe() or Level.getMe() instead.");
			}
			staticCall = false;

			//init lists
			allObjects = new Vector.<GameObject>();
			activeObjects = new Vector.<GameObject>();

			//initialize camera
			camera = new Sprite();
			addChild(camera);

			//init player
			player = new Player();
			camera.addChild(player);

			//init progress bar
			progressBar = new LevelProgressBar();
			progressBar.x = Aeon.STAGE_WIDTH / 2 - progressBar.width / 2;
			progressBar.y = Aeon.STAGE_HEIGHT / 2 - progressBar.height / 2;
			addChild(progressBar);

			//load test level
			var loader:LevelLoader = new LevelLoader(TEST_LEVEL_FILE, this, progressBar);
			loader.start();
		}


		/********************************
		 * Initialization methods below *
		 * (all called by LevelLoader)	*
		 ********************************/

		public function setLevelSize(lvlWidth:Number, lvlHeight:Number):void {
			collisionGrid = new CollisionGrid(lvlWidth, lvlHeight);
		}

		/**
		 * Player is already initialized, but LevelLoader
		 * needs to specify its location.
		 */
		public function setPlayer(px:Number, py:Number):void {
			player.setStartPosition(px, py);
			collisionGrid.updateObject(player, false);
		}

		public function createCollidableObject(tile:CollidableObject, isActive:Boolean):void {
			allObjects.push(tile);
			if (isActive)
				activeObjects.push(tile);
			collisionGrid.updateObject(tile, !isActive);
			camera.addChild(tile);
		}

		/**
		 * Called by LevelLoader when complete.
		 */
		public function startGame():void {
			removeChild(progressBar);

			/*DEBUG*/
			addChildAt(collisionGrid, 1);
			/*END DEBUG*/

			//init game loop
			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
			timer.start();
		}

		/***************************
		 * Game Loop methods below *
		 ****************************/

		/**
		 * Called 30 frames per second.
		 */
		private function onGameLoop(evt:TimerEvent):void {
			//update player
			player.onGameLoop();
			collisionGrid.updateObject(player, false);

			//update active objects
			var len:uint = activeObjects.length;
			for (var i:uint = 0; i < len; i++) {
				var obj:GameObject = activeObjects[i];
				obj.onGameLoop();
				if (obj is CollidableObject) {
					//TODO if obj is no longer active, pass true below, rather than false
					collisionGrid.updateObject(CollidableObject(obj), false);
				}
			}

			//test and handle collisions
			var remove:ArrayList = collisionGrid.detectAndHandleCollisions(player);
			removeObjects(remove);
			collisionGrid.resetRemovalList();
			player.finishGameLoop();
			for (i = 0; i < len; i++) {
				remove = collisionGrid.detectAndHandleCollisions(activeObjects[i]);
				removeObjects(remove);
				collisionGrid.resetRemovalList();
				GameObject(activeObjects[i]).finishGameLoop();
			}
		}

		public function removeObjects(remove:ArrayList):void {
			var r:GameObject;
			for (var i:int = 0; i < remove.length(); i++) {
				r = GameObject(remove.getItemAt(i));

				//remove from allObjects list
				var index:int = allObjects.indexOf(r, 0);
				allObjects.splice(index, 1);

				//remove from activeObjects list
				index = activeObjects.indexOf(r, 0);
				if (index != -1) {
					activeObjects.splice(index, 1);
				}

				//remove from display list
				camera.removeChild(DisplayObject(r));

				//remove from grid tiles
				if (r is CollidableObject)
					CollidableObject(r).removeSelf();
			}
		}

		/**
		 * When an object is removed from the game,
		 * this method might be called by its GridTiles
		 * in order to unblock the neighboring GridTiles.
		 */
		public function unblockNeighbors(g:GridTile):void {
			collisionGrid.unblockNeighbors(g);
		}

		public function setTitle(param0:String):void {
			
		}
	}
}
