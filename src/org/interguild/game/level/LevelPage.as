package org.interguild.game.level {
	import flash.geom.Rectangle;

	import flexunit.utils.ArrayList;

	import org.interguild.Aeon;
	import org.interguild.KeyMan;
	import org.interguild.loader.LevelLoader;
	import flash.display.Sprite;

	/**
	 * LevelPage will handle every screen that happens when you're playing a level.
	 * This includes:
	 * 		-The level preloader
	 * 		-The pause menu
	 * 		-The win screen?
	 * 		-The level itself
	 */
	public class LevelPage extends Sprite {

		CONFIG::NODEPLOY {
			public static const TEST_LEVEL_FILE:String = "../gamesaves/testlevel.txt";
		}

		private var level:Level;
		private var loader:LevelLoader;
		private var progressBar:LevelProgressBar;
		private var startScreen:LevelStartScreen;
		private var pauseMenu:LevelPauseMenu;

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

		public function playLevelFromFile(file:String):void {
			loader.loadFromFile(file);
		}

		public function playLevelFromCode(code:String):void {
			loader.loadFromCode(code, "MainMenu");
		}

		private function onFileLoad(lvl:Level):void {
			level = lvl;

			//init start screen
			startScreen = new LevelStartScreen(level.title);
			addChild(startScreen);
			showPreviewLevel();

			//add level to display list on top of start screen
			addChild(level);

			//init pause menu on top of level
			pauseMenu = new LevelPauseMenu();
			pauseMenu.visible = false;
			addChild(pauseMenu);
		}

		private function onLoadError(e:ArrayList):void {
			Aeon.getMe().returnFromError(e, "LevelLoader");
		}

		private function onLoadComplete():void {
			removeChild(progressBar);
			startScreen.loadComplete();

			var keys:KeyMan = KeyMan.getMe();
			keys.addSpacebarListener(onSpacebar);
			keys.addEscapeListener(onPauseGame);
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
		
		private function onSpacebar():void{
			if(!pauseMenu.visible && !level.isRunning){
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
