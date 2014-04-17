package org.interguild.game.level {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	CONFIG::DEBUG {
		import org.interguild.KeyMan;
	}
	import org.interguild.Aeon;
	import org.interguild.game.Camera;
	import org.interguild.game.Player;
	import org.interguild.game.collision.CollisionGrid;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.GameObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Level will handle the actual gameplay. It's responsible for
	 * constructing itself based off of the level encoding, but it
	 * is not responsible for displaying its preloading progress
	 * to the user.
	 *
	 * Level controls the camera, game logic, etc.
	 */
	public class Level extends Sprite {

		public static const GRAVITY:Number = 2;

		private static const FRAME_RATE:uint = 30;
		private static const PERIOD:Number = 1000 / FRAME_RATE;

		private var myTitle:String;

		private var camera:Camera;
		private var player:Player;

		private var collisionGrid:CollisionGrid;

		private var timer:Timer;

		private var w:uint = 0;
		private var h:uint = 0;

		CONFIG::DEBUG {
			public var isDebuggingMode:Boolean = false;
			private var debugSprite:Sprite = new Sprite();
			private var isSlowdown:Boolean = false;
			private var slowDownText:TextField;
		}

		public function Level(lvlWidth:Number, lvlHeight:Number) {

			w = lvlWidth;
			h = lvlHeight;
			myTitle = "Untitled";

			//initialize camera
			camera = new Camera(player = new Player());
			camera.setLevelX(Aeon.TILE_WIDTH * lvlWidth); // need to send to camera so it knows level width
			camera.setLevelY(Aeon.TILE_HEIGHT * lvlHeight); // need to send to camera so it knows level height
			addChild(camera);

			//init player
			camera.addChild(player);

			//init collision grid
			collisionGrid = new CollisionGrid(lvlWidth, lvlHeight, this);

			CONFIG::DEBUG {
				var keys:KeyMan = KeyMan.getMe();
				keys.addSlowdownListeners(onSlowdownToggle, onSlowdownNext);
				keys.addDebugListeners(onDebugToggle);

				slowDownText = new TextField();
				slowDownText.defaultTextFormat = new TextFormat("Impact", 14, 0xFFFFFF);
				slowDownText.autoSize = TextFieldAutoSize.LEFT;
				slowDownText.selectable = false;
				slowDownText.background = true;
				slowDownText.backgroundColor = 0;
				slowDownText.text = "SLOWDOWN MODE";
				slowDownText.x = 5;
				slowDownText.y = Aeon.STAGE_HEIGHT - slowDownText.height - 5;
				slowDownText.visible = false;
				addChild(slowDownText);
			}
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

		public function createCollidableObject(tile:CollidableObject):void {
			collisionGrid.addObject(tile);
			camera.addChild(tile);
		}

		/**
		 * Called by LevelLoader when complete.
		 */
		public function startGame():void {
			CONFIG::DEBUG {
				camera.addChildAt(collisionGrid, 1);
				camera.addChild(debugSprite);
			}

			player.wasJumping = true;

			//init game loop
			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);
			timer.start();
		}

		public function stopGame():void {
			timer.stop();
		}

		CONFIG::DEBUG {
			private function onSlowdownToggle():void {
				isSlowdown = !isSlowdown;
				if (isSlowdown) {
					timer.stop();
					slowDownText.visible = true;
				} else {
					timer.start();
					slowDownText.visible = false;
				}
			}

			private function onSlowdownNext():void {
				if (isSlowdown)
					onGameLoop(null);
			}

			private function onDebugToggle():void {
				isDebuggingMode = !isDebuggingMode;
				if (isDebuggingMode) {
					debugSprite.visible = true;
				} else {
					debugSprite.visible = false;
					debugSprite.removeChildren();
				}
			}
		}

		/***************************
		 * Game Loop methods below *
		 ****************************/

		/**
		 * Called 30 frames per second.
		 */
		private function onGameLoop(evt:TimerEvent):void {
			update();
			collisions();
			cleanup();
			remove();
		}

		private function update():void {
			//update player
			player.onGameLoop();
			player.reset();

			//update active objects
			var len:uint = collisionGrid.activeObjects.length;
			for (var i:uint = 0; i < len; i++) {
				var obj:GameObject = collisionGrid.activeObjects[i];
				obj.onGameLoop();
			}
		}

		private function collisions():void {
			CONFIG::DEBUG { //draw collision wireframes
				if (isDebuggingMode) {
					var s:Sprite = player.drawHitBox(false);
					if (s)
						debugSprite.addChild(s);
//					s = player.drawHitBoxWrapper(false);
//					if (s)
//						debugSprite.addChild(s);
				}
			}

			//detect collisions for player
			collisionGrid.updateObject(player, false);

			//detect collisions for active objects
			var len:uint = collisionGrid.activeObjects.length;
			for (var i:uint = 0; i < len; i++) {
				var obj:GameObject = collisionGrid.activeObjects[i];
				if (obj is CollidableObject) {
					//TODO if obj is no longer active, pass true below, rather than false
					collisionGrid.updateObject(CollidableObject(obj), false);
				}
			}

			//test and handle collisions
			collisionGrid.detectAndHandleCollisions(player);
			if (collisionGrid.activeObjects.length > 0) {
				for (i = 0; i < collisionGrid.activeObjects.length; i++) {
					collisionGrid.detectAndHandleCollisions(CollidableObject(collisionGrid.activeObjects[i]));
				}
			}
		}

		public function remove():void {
			var remove:Array = collisionGrid.removalList;
			for (var i:int = 0; i < remove.length; i++) {
				var r:GameObject = GameObject(remove[i]);

				//remove from active objects
				var index:int = collisionGrid.activeObjects.indexOf(r);
				if (index != -1) {
					collisionGrid.activeObjects.splice(index, 1);
				}

				//remove from display list
				camera.removeChild(DisplayObject(r));

				//remove from grid tiles
				if (r is CollidableObject) {
					collisionGrid.destroyObject(CollidableObject(r));
					r.onKill();
				}
			}
			collisionGrid.resetRemovalList();

			remove = collisionGrid.deactivationList;
			for (i = 0; i < remove.length; i++) {
				r = GameObject(remove[i]);

				index = collisionGrid.activeObjects.indexOf(r);
				if (index != -1) {
					collisionGrid.activeObjects.splice(index, 1);
				}

				if (r is CollidableObject) {
					CollidableObject(r).isActive = false;
				}
			}
			collisionGrid.resetDeactivationList();
		}

		private function cleanup():void {
			//finish game loops
			player.finishGameLoop();
			if (collisionGrid.activeObjects.length > 0) {
				for (var i:uint = 0; i < collisionGrid.activeObjects.length; i++) {
					GameObject(collisionGrid.activeObjects[i]).finishGameLoop();
				}
			}
			CONFIG::DEBUG { //draw collision wireframes
				if (isDebuggingMode) {
					var s:Sprite = player.drawHitBox(true);
					if (s)
						debugSprite.addChild(s);
				}
			}

			//update camera
			camera.updateCamera();
		}

		public function activateObject(obj:CollidableObject):void {
			obj.isActive = true;
			collisionGrid.activeObjects.push(obj);
		}

		public function deactivateObject(obj:CollidableObject):void {
			var index:int = collisionGrid.activeObjects.indexOf(obj, 0);

			obj.isActive = false;
			collisionGrid.activeObjects.splice(index, 1);
			obj.finishGameLoop;
		}
	}
}
