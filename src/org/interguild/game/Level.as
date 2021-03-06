package org.interguild.game {
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
	import org.interguild.game.collision.CollisionGrid;
	import org.interguild.game.tiles.CollidableObject;
	import org.interguild.game.tiles.TerrainView;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.EndGate;
	import org.interguild.game.gui.LevelHUD;
	import flash.utils.getTimer;
	import org.interguild.game.tiles.Player;

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

		private static const PORTAL_ANIMATION_DELAY:uint = 8;

		private var myTitle:String;

		private var camera:Camera;
		private var player:Player;
		private var tv:TerrainView;
		private var bg:LevelBackground;

		private var portals:Array;
		private var portalAnim:uint;

		private var collisionGrid:CollisionGrid;

		private var timer:Timer;

		private var w:uint = 0;
		private var h:uint = 0;

		private var hud:LevelHUD;
		private var collectableCount:int;

		private var timeDead:int = 0;

		private var hasWon:Boolean;
		public var onWinCallback:Function;

		CONFIG::DEBUG {
			public var isDebuggingMode:Boolean = false;
			private var debugSprite:Sprite = new Sprite();
			private var isSlowdown:Boolean = false;
			private var slowDownText:TextField;
			private var fpsText:TextField;
		}

		public function Level(lvlWidth:Number, lvlHeight:Number, bgID:uint) {
			collectableCount = 0;
			w = lvlWidth;
			h = lvlHeight;
			myTitle = "Untitled";

			//init background
			bg = new LevelBackground(widthInPixels, heightInPixels, bgID);
			addChild(bg);

			//init portals list
			portals = new Array();

			//init collision grid
			collisionGrid = new CollisionGrid(lvlWidth, lvlHeight, this);

			//init player and camera
			player = new Player(collisionGrid);
			camera = new Camera(player, bg, widthInPixels, heightInPixels);
			addChild(camera);

			//init Terrain view
			tv = TerrainView.init(widthInPixels, heightInPixels);

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

				fpsText = new TextField();
				fpsText.defaultTextFormat = new TextFormat("Impact", 24, 0xFFFFFF);
				fpsText.autoSize = TextFieldAutoSize.LEFT;
				fpsText.selectable = false;
				fpsText.background = true;
				fpsText.backgroundColor = 0;
				fpsText.text = "0.00 FPS";
				fpsText.x = 5;
				fpsText.y = 5;
				addChild(fpsText);
			}
		}

		public function deconstruct():void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onGameLoop);
			timer = null;

			camera.deconstruct();
			removeChild(camera);
			camera = null;

			portals = null;
			player = null;

			collisionGrid.deconstruct();
			collisionGrid = null;

			removeChildren();
		}

		public function set terrainType(id:uint):void {
			tv.terrainType = id;
		}

		public function finishLoading():void {
			camera.addChild(player);
			tv.finishTerrain();
			camera.addChild(tv);
			hud.updateMax(collectableCount);
			if (hud.maxCollected == 0)
				openPortal();
			saveCheckpoint();
		}

		public function saveCheckpoint():void {
			trace("TODO: Level.saveCheckpoint()");
		}

		public function grabbedCollectable():void {
			hud.increaseCollected();
			if (hud.collected == hud.maxCollected)
				openPortal();
		}

		public function setFinish(o:EndGate):void {
			portals.push(o);
		}

		public function hideBackground():void {
			player.isInPreview = true;
			bg.visible = false;
		}

		public function showBackground():void {
			player.isInPreview = false;
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
			for each (var p:EndGate in portals) {
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

		public function createCollidableObject(tile:CollidableObject, fakeObject:Boolean = false):void {
			collisionGrid.addObject(tile, fakeObject);
			if (tile is EndGate) {
				camera.addChildAt(tile, 0);
			} else {
				camera.addChild(tile);
			}
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

				if (isSlowdown) {
					player.pressedJump = true;
					onGameLoop(null);
					return;
				}
			}

			player.pressedJump = true;
			timer.start();
		}

		public function pauseGame():void {
			timer.stop();
		}

		public function continueGame():void {
			player.pressedJump = true;
			timer.start();
		}

		public function get isRunning():Boolean {
			return timer.running;
		}

		public function onWonGame():void {
			hasWon = true;
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
			collisionGrid.updateAllObjects();
			CONFIG::DEBUG {
				drawPlayerHitBox();
			}

			collisionGrid.doCollisionDetection();
			collisionGrid.handleRemovalsAndMore(camera);
			collisionGrid.finishGameLoops();
			cleanup();

			CONFIG::DEBUG {
				drawPlayerHitBox();
				updateMetrics();
			}
		}

		CONFIG::DEBUG {
			private function drawPlayerHitBox(drawWrapper:Boolean = false):void {
				if (player == null)
					return;
				if (isDebuggingMode) {
					var s:Sprite = player.drawHitBox(false);
					if (s)
						debugSprite.addChild(s);
					if (drawWrapper) {
						s = player.drawHitBoxWrapper(false);
						if (s)
							debugSprite.addChild(s);
					}
				}
			}

			private var lastTime:uint;
			private var currentSum:Number = 0;
			private var countPerAverage:uint = 10;
			private var counter:uint = 0;

			private function updateMetrics():void {
				var currentTime:uint = getTimer();
				var period:uint = currentTime - lastTime;
				var freq:Number = 1000 / period; //Math.round(100 / period) / 100;
				currentSum += freq;
				counter++;
				if (counter >= countPerAverage) {
					var average:Number = Math.round(100 * currentSum / countPerAverage) / 100;
					fpsText.text = average + " FPS";
					currentSum = 0;
					counter = 0;
				}
				lastTime = currentTime;
			}
		}

		private function cleanup():void {
			//update camera
			if (!player.isDead)
				camera.updateCamera();
			else if (player.timeToRestart) {
				Aeon.getMe().playLastLevel();
			}

			if (hasWon) {
				timer.stop();
				onWinCallback();
			}
		}
	}
}


