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
		
		private var level:Level;
		
		private var startScreen:LevelStartScreen;

		public function LevelPage() {
			//for now, just create a level:
			level = Level.createMe(this);
			
			startScreen = new LevelStartScreen("Test Level");
			addChild(startScreen);
		}
		
		public function setLevelSize(w:Number, h:Number):void{
			var desiredSize:Number = 300;
//			level.scaleX = level.scaleY = desiredSize / h;
//			level.x = Aeon.STAGE_WIDTH / 2 - level.levelWidth * Aeon.TILE_WIDTH * level.scaleX / 2;
//			level.y = Aeon.STAGE_HEIGHT / 2 - level.levelHeight * Aeon.TILE_HEIGHT* level.scaleY / 2;
			addChild(level);
		}
	}
}
