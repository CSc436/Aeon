package org.interguild.game {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.interguild.game.collision.CollisionGrid;
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

		public static const GRAVITY:Number = 4;

		private static const FRAME_RATE:uint = 30;
		private static const PERIOD:Number = 1000 / FRAME_RATE;

		private static const TEST_LEVEL_FILE:String = "../testlevel.txt";

		private var camera:Sprite;
		private var player:Player;
		
		private var collisionGrid:CollisionGrid;
		private var allObjects:Vector.<GameObject>;
		private var activeObjects:Vector.<GameObject>;

		private var timer:Timer;

		public function Level() {
			//init lists
			allObjects = new Vector.<GameObject>();
			activeObjects = new Vector.<GameObject>();
			
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
			/*DEBUG
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
			//update player
			player.onGameLoop();
			collisionGrid.updateObject(player, false);
			
			//update active objects
			var len:uint = activeObjects.length;
			for(var i:uint = 0; i < len; i++){
				var obj:GameObject = activeObjects[i];
				obj.onGameLoop();
				if(obj is CollidableObject){
					//TODO if obj is no longer active, pass true below, rather than false
					collisionGrid.updateObject(CollidableObject(obj), false);
				}
			}
			 
			//test and handle collisions
			collisionGrid.detectAndHandleCollisions(player);
			player.finishGameLoop();
			for(i = 0; i < len; i++){
				collisionGrid.detectAndHandleCollisions(activeObjects[i]);
				GameObject(activeObjects[i]).finishGameLoop();
			}
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
			collisionGrid.updateObject(player, false);
		}

		public function createCollidableObject(tile:CollidableObject, isActive:Boolean):void {
			allObjects.push(tile);
			if(isActive)
				activeObjects.push(tile);
			collisionGrid.updateObject(tile, !isActive);
			camera.addChild(tile);
		}
	}
}
