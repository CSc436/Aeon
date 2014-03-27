package org.interguild.game.level {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.game.Camera;
	import org.interguild.game.Player;
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

		private var myTitle:String;

		private var camera:Camera;
		private var player:Player;

		private var collisionGrid:CollisionGrid;
		private var allObjects:Vector.<GameObject>;
		private var activeObjects:Vector.<GameObject>;

		private var timer:Timer;

		private var w:uint = 0;
		private var h:uint = 0;

		public function Level(lvlWidth:Number, lvlHeight:Number) {
			w = lvlWidth;
			h = lvlHeight;
			myTitle = "Untitled";

			//init lists
			allObjects = new Vector.<GameObject>();
			activeObjects = new Vector.<GameObject>();

			//initialize camera
			camera = new Camera(player = new Player());
			camera.setLevelX( Aeon.TILE_WIDTH * lvlWidth ); // need to send to camera so it knows level width
			camera.setLevelY( Aeon.TILE_HEIGHT * lvlHeight ); // need to send to camera so it knows level height
			addChild(camera);

			//init player
			camera.addChild(player);

			//init collision grid
			collisionGrid = new CollisionGrid(lvlWidth, lvlHeight);
		}

		public function get title():String {
			return myTitle;
		}

		public function set title(t:String):void {
			myTitle = t;
		}

		/**
		 * Returns the width of the level as measured
		 * in the number of tiles.
		 */

		public function get widthInTiles():uint {
			return w;
		}

		/**
		 * Returns the hight of the level as measured
		 * in the number of tiles.
		 */
		public function get heightInTiles():uint {
			return h;
		}

		/**
		 * Returns the width of the level as measured
		 * in pixels. Basically: widthInTiles * 32
		 */
		public function get widthInPixels():uint {
			return w * Aeon.TILE_WIDTH;
		}

		/**
		 * Returns the width of the level as measured
		 * in pixels. Basically: widthInTiles * 32
		 */
		public function get heightInPixels():uint {
			return h * Aeon.TILE_HEIGHT;
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
			CONFIG::DEBUG{
				addChildAt(collisionGrid, 1);
			}

			player.wasJumping = true;

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
			
			//update camera
			camera.updateCamera();
			
			// reset isStanding
			player.reset();
			
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
				remove = collisionGrid.detectAndHandleCollisions(CollidableObject(activeObjects[i]));
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
	}
}
