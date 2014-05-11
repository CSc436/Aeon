package org.interguild.game.level {
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	CONFIG::DEBUG {
		import org.interguild.KeyMan;
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
	}
	import org.interguild.Aeon;
	import org.interguild.game.Camera;
	import org.interguild.game.Player;
	import org.interguild.game.collision.CollisionGrid;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.GameObject;
	import org.interguild.game.tiles.TerrainView;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.FinishLine;

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
		private var portals:Vector.<FinishLine>;
		private var tv:TerrainView;
		private var bg:LevelBackground;

		private var collisionGrid:CollisionGrid;

		private var timer:Timer;

		private var w:uint = 0;
		private var h:uint = 0;

		private var hud:LevelHUD;
		private var collectableCount:int;

		private var timeDead:int = 0;

		public var onWinCallback:Function;

		CONFIG::DEBUG {
			public var isDebuggingMode:Boolean = false;
			private var debugSprite:Sprite = new Sprite();
			private var isSlowdown:Boolean = false;
			private var slowDownText:TextField;
		}

		public function Level(lvlWidth:Number, lvlHeight:Number) {
			collectableCount = 0;
			w = lvlWidth;
			h = lvlHeight;
			myTitle = "Untitled";

			//init background
			bg = new LevelBackground(widthInPixels, heightInPixels);
			addChild(bg);
			
			//init portals list
			portals = new Vector.<FinishLine>();

			//init player and camera
			player = new Player()
			camera = new Camera(player, bg, widthInPixels, heightInPixels);
			addChild(camera);
			camera.addChild(player);

			//init Terrain view
			tv = TerrainView.init(widthInPixels, heightInPixels);
			camera.addChild(tv);

			//init collision grid
			collisionGrid = new CollisionGrid(lvlWidth, lvlHeight, this);

			//init level hud
			hud = new LevelHUD();
			addChild(hud);

			//init game loop
			timer = new Timer(PERIOD);
			timer.addEventListener(TimerEvent.TIMER, onGameLoop, false, 0, true);

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

		public function finishLoading():void {
			tv.finishTerrain();
			hud.updateMax(collectableCount);
			if(hud.maxCollected == 0)
				openPortal();
		}

		public function grabbedCollectable():void {
			hud.increaseCollected();
			if(hud.collected == hud.maxCollected)
				openPortal();
		}

		public function setFinish(o:FinishLine):void {
			portals.push(o);
		}

		public function hideBackground():void {
			bg.visible = false;
		}

		public function showBackground():void {
			bg.visible = true;
		}

		public function getHUD():LevelHUD {
			return hud;
		}

		public function get title():String {
			return myTitle;
		}

		public function set title(t:String):void {
			myTitle = t;
		}

		public function set hudVisibility(show:Boolean):void {
			if (show) {
				hud.show();
			} else {
				hud.hide();
			}
		}

		public function openPortal():void {
			for each(var p:FinishLine in portals){
				p.activate();
			}
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
			if (tile is Collectable)
				collectableCount++;
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

			timer.start();
		}

		public function pauseGame():void {
			timer.stop();
		}

		public function continueGame():void {
			player.wasJumping = true;
			timer.start();
		}

		public function get isRunning():Boolean {
			return timer.running;
		}

		public function onWonGame():void {
			pauseGame();
			onWinCallback();
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
			collisionGrid.handleRemovals(camera);
		}

		private function update():void {
			if (!player.isDead) {
				//update player
				player.onGameLoop();
			}

			// restart the game after the player has been dead after time specified
			if (player.isDead) {
				this.timeDead++;
				if (40 == timeDead) {
					this.stage.focus = stage;
					// This is hardcoded right now, but we probably want some kind of
					// global reference to the current file so that we know what level
					// needs to be restarted
					Aeon.getMe().playLastLevel();
				}
			}
			// update animations
			player.updateAnimation();

			player.frameCounter++; // update counter for game frames

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
			var index:int = collisionGrid.activeObjects.indexOf(player);
			if (index != -1) {
				collisionGrid.activeObjects.splice(index, 1);
			}


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
			collisionGrid.detectAndHandleCollisions(player)
			if (collisionGrid.activeObjects.length > 0) {
				for (i = 0; i < collisionGrid.activeObjects.length; i++) {
					collisionGrid.detectAndHandleCollisions(CollidableObject(collisionGrid.activeObjects[i]));
				}
			}


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
			if (!player.isDead)
				camera.updateCamera();
		}
	}
}


