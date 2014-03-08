package org.interguild.game.level {
	import flash.display.Sprite;
	
	import org.interguild.Aeon;

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
		private var progress:LevelProgressBar;
		private var startScreen:LevelStartScreen;

		public function LevelPage() {
			//for now, just create a level:
//			level = Level.createMe(this, null, TEST_LEVEL_FILE);
			
			//load test level
			var loader:LevelLoader = new LevelLoader(TEST_LEVEL_FILE);
			loader.addProgressListener(progress.setProgress);
			loader.addFileLoadedListener(onFileLoad);
			loader.start();
			
			startScreen = new LevelStartScreen("Test Level");
			addChild(startScreen);
		}
		
		private function onFileLoad(lvl:Level):void{
			level = lvl;
			//TODO: create start screen
		}
		
		public function setLevelSize(w:Number, h:Number):void{
			var desiredSize:Number = 300;
			level.scaleX = level.scaleY = desiredSize / h;
			level.x = Aeon.STAGE_WIDTH / 2 - level.levelWidth * Aeon.TILE_WIDTH * level.scaleX / 2;
			level.y = Aeon.STAGE_HEIGHT / 2 - level.levelHeight * Aeon.TILE_HEIGHT* level.scaleY / 2;
			addChild(level);
		}
	}
}
