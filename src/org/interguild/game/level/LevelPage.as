package org.interguild.game.level {
	import flash.geom.Rectangle;

	import org.interguild.Aeon;
	import org.interguild.KeyMan;
	import org.interguild.Page;
	import org.interguild.loader.LevelLoader;

	/**
	 * LevelPage will handle every screen that happens when you're playing a level.
	 * This includes:
	 * 		-The level preloader
	 * 		-The pause menu
	 * 		-The win screen?
	 * 		-The level itself
	 */
	public class LevelPage extends Page {

		CONFIG::NODEPLOY {
			public static const TEST_LEVEL_FILE:String = "../gamesaves/testlevel.txt";
		}

		private var level:Level;
		private var loader:LevelLoader;
		private var progressBar:LevelProgressBar;
		private var startScreen:LevelStartScreen;

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
			loader.loadFromCode(code);
		}

		private function onFileLoad(lvl:Level):void {
			level = lvl;
			startScreen = new LevelStartScreen(level.title);
			addChild(startScreen);
			showPreviewLevel(false);
			addChild(level);
			startScreen.initButtons();
			startScreen.hideButtons();
		}

		private function onLoadError(e:String):void {
			trace("Error: " + e);
			//TODO display error to user
		}

		private function onLoadComplete():void {
			removeChild(progressBar);
			startScreen.loadComplete();
			KeyMan.getMe().addSpacebarListener(showFullLevel);
			KeyMan.getMe().addEscapeListener(pauseGame);
		}

		private function showPreviewLevel(isPauseMenu:Boolean):void {
			startScreen.visible = true;

			// Get rid of the jump to start text if we are pausing the game rather than 
			// Starting the level for the first time
			if (isPauseMenu) {
				startScreen.setJumpText("Paused");
				startScreen.showButtons();
			}

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

		private function pauseGame():void {
			if (KeyMan.getMe().isKeyEsc && !startScreen.visible) {
				trace("Trying to pause the game");
				level.stopGame();
				showPreviewLevel(true);
			} else if (!(KeyMan.getMe().isKeyEsc) && startScreen.visible) {
				trace("Trying to unpause the game");
				showFullLevel(true);
			}
		}

		private function showFullLevel(wasPaused:Boolean):void {
			if (KeyMan.getMe().spacebarCallback != null)
				KeyMan.getMe().removeSpacebarListener();
			if (startScreen.visible) {
				if (wasPaused) {
					startScreen.hideButtons();
				}
				startScreen.visible = false;
				level.showBackground();
				level.scaleX = level.scaleY = 1;
				level.x = level.y = 0;
				level.startGame();
			}
		}
	}
}
