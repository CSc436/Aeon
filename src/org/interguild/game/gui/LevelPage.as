package org.interguild.game.gui {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	
	import org.interguild.Aeon;
	import org.interguild.KeyMan;
	import org.interguild.game.Level;
	import org.interguild.loader.LevelLoader;

	/**
	 * LevelPage will handle every screen that happens when you're playing a level.
	 * This includes:
	 * 		-The level preloader
	 * 		-The pause menu
	 * 		-The win screen?
	 * 		-The level itself
	 */
	public class LevelPage extends Sprite {

		CONFIG::ONLINE {
			public static const TEST_LEVEL_FILE:String = INTERGUILD.ORG + "/levels/levels/65182.txt";
		}

		CONFIG::OFFLINE {
			public static const TEST_LEVEL_FILE:String = "../levels/test arrow firing.txt";
		}

		private var level:Level;
		private var loader:LevelLoader;
		private var progressBar:LevelProgressBar;
		private var startScreen:LevelStartScreen;
		private var pauseMenu:LevelPauseMenu;
		private var winMenu:LevelWinMenu;

		public function LevelPage() {
			//init progress bar
			progressBar = new LevelProgressBar();
			progressBar.x = Aeon.STAGE_WIDTH / 2 - progressBar.width / 2;
			progressBar.y = Aeon.STAGE_HEIGHT / 2 - progressBar.height / 2;
			addChild(progressBar);

			//init Level Loader
			loader = new LevelLoader();
			loader.addProgressListener(progressBar.setProgress);
			loader.addInitializedListener(onFileLoad);
			loader.addErrorListener(onLoadError);
			loader.addCompletionListener(onLoadComplete);
		}
		
		public function deconstruct():void{
			KeyMan.getMe().forgetMe();
			loader.forgetMe();
			loader = null;
			progressBar = null;
			startScreen = null;
			pauseMenu = null;
			winMenu = null;
			level.deconstruct();
			level = null;
		}

		public function playLevelFromFile(file:String):void {
			loader.loadFromFile(file);
		}

		public function playLevelFromCode(code:String):void {
			loader.loadFromCode(code, "MainMenu");
		}

		private function onFileLoad(lvl:Level):void {
			level = lvl;
			level.onWinCallback = onWonGame;

			//init start screen
			startScreen = new LevelStartScreen(level.title);
			addChild(startScreen);
			showPreviewLevel();

			//add level to display list on top of start screen
			addChild(level);

			//init pause menu on top of level
			pauseMenu = LevelPauseMenu.getMe();
			pauseMenu.visible = false;
			addChild(pauseMenu);
		}

		private function onLoadError(e:Array):void {
			Aeon.getMe().returnFromError(e, "LevelLoader");
		}

		private function onLoadComplete():void {
			removeChild(progressBar);
			progressBar = null;
			startScreen.loadComplete();

			var keys:KeyMan = KeyMan.getMe();
			keys.addSpacebarListener(onSpacebar);
			keys.addEscapeListener(onPauseGame);
			keys.addRestartListener(onRestartGame);
		}

		private function showPreviewLevel():void {
			startScreen.visible = true;
			level.hudVisibility = false;

			//scale level preview:
			var box:Rectangle = startScreen.getPreviewRegion();
			level.scaleX = level.scaleY = box.height / level.heightInPixels;
			var tmpScale:Number = box.width / level.widthInPixels;
			if (tmpScale < level.scaleX)
				level.scaleX = level.scaleY = tmpScale;
			if (level.scaleX > 1)
				level.scaleX = level.scaleY = 1;

			//position level preview:
			level.x = Aeon.STAGE_WIDTH / 2 - level.widthInPixels * level.scaleX / 2;
			level.y = box.y + (box.height / 2) - level.heightInPixels * level.scaleY / 2;

			level.hideBackground();
		}

		private function onPauseGame():void {
			if (!pauseMenu.visible) { //pause
				if (!startScreen.visible) {
					level.pauseGame();
				}
				pauseMenu.visible = true;
			} else {
				if (!startScreen.visible) {
					level.continueGame(); //unpause
				}
				pauseMenu.visible = false;
			}
		}

		private function onRestartGame():void {
			this.stage.focus = stage;
			Aeon.getMe().playLastLevel();
		}

		public function onWonGame():void {
			winMenu = LevelWinMenu.getMe();
			winMenu.visible = true;
			addChild(winMenu);

			var aeon:Aeon = Aeon.getMe();
//			aeon.gotoMainMenu();
			//this.addChild(winDialog);
		}

//		private function closeDialog(e:MouseEvent):void {
//			LevelPage(this).removeChild(winDialog);
//		}

		private function onSpacebar():void {
			if (!pauseMenu.visible && !level.isRunning) {
				showFullLevel();
			}
		}

		private function showFullLevel():void {
			if (startScreen.visible) {
				startScreen.visible = false;
				level.showBackground();
				level.scaleX = level.scaleY = 1;
				level.x = level.y = 0;
				level.startGame();
			}
			level.hudVisibility = true;
		}
	}
}
