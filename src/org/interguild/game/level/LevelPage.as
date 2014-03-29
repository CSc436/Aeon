package org.interguild.game.level {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.interguild.Aeon;
	import org.interguild.game.KeyMan;

	/**
	 * LevelPage will handle every screen that happens when you're playing a level.
	 * This includes:
	 * 		-The level preloader
	 * 		-The pause menu
	 * 		-The win screen?
	 * 		-The level itself
	 */
	public class LevelPage extends Sprite {

		private static const TEST_LEVEL_FILE:String = "../gamesaves/testlevel.txt";

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

			//load test level
			var loader:LevelLoader = new LevelLoader();
			loader.addProgressListener(progressBar.setProgress);
			loader.addFileLoadedListener(onFileLoad);
			loader.addErrorListener(onLoadError);
			loader.addCompletionListener(onLoadComplete);
			loader.startServer(TEST_LEVEL_FILE);
		}

		private function onFileLoad(lvl:Level):void {
			level = lvl;
			startScreen = new LevelStartScreen(level.title);
			addChild(startScreen);
			showPreviewLevel();
			addChild(level);
		}

		private function onLoadError(e:String):void {
			trace("Error: " + e);
			//TODO display error to user
		}

		private function onLoadComplete():void {
			removeChild(progressBar);
			startScreen.loadComplete();
			KeyMan.getMe().addSpacebarListener(showFullLevel);
		}
		
		private function showPreviewLevel():void{
			startScreen.visible = true;
			
			//scale level preview:
			var box:Rectangle = startScreen.getPreviewRegion();
			level.scaleX = level.scaleY = box.height / level.heightInPixels;
			var tmpScale:Number = box.width / level.widthInPixels;
			if (tmpScale < level.scaleX)
				level.scaleX = level.scaleY = tmpScale;
			if(level.scaleX > 1)
				level.scaleX = level.scaleY = 1;
			
			//position level preview:
			level.x = Aeon.STAGE_WIDTH / 2 - level.widthInPixels * level.scaleX / 2;
			level.y = box.y + (box.height / 2) - level.heightInPixels * level.scaleY / 2;
		}
		
		private function showFullLevel():void{
			if(startScreen.visible){
				startScreen.visible = false;
				level.scaleX = level.scaleY = 1;
				level.x = level.y = 0;
				level.startGame();
			}
		}
	}
}
