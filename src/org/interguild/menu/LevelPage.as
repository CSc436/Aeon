package org.interguild.menu {
	import flash.display.Sprite;
	import org.interguild.game.Level;

	/**
	 * LevelPage will handle every screen that happens when you're playing a level.
	 * This includes:
	 * 		-The level preloader
	 * 		-The pause menu
	 * 		-The win screen?
	 * 		-The level itself
	 * 
	 */
	public class LevelPage extends Sprite {
		
		private var level:Level;

		public function LevelPage() {
			//for now, just create a level:
			level = new Level();
			addChild(level);
		}
	}
}
