package org.interguild.game.tiles {
	import flash.display.Sprite;

	/**
	 * Treat this like an abstract class. Defines general
	 * purpose interface for Level to communicate with
	 * objects without knowing what they are.
	 */
	public class GameObject extends Sprite {

		/**
		 * DO NOT INSTANTIATE THIS CLASS
		 */
		public function GameObject() {
			super();
		}

		/**
		 * Updates the object for the current frame
		 */
		public function onGameLoop():void {

		}

		/**
		 * Called when the Level needs to be reloaded after the
		 * player dies. Should reset the GameObject to whatever
		 * state it was in when the level started. Some objects
		 * may have to destroy themselves (such as flying arrows).
		 */
		public function reload():void {

		}
	}
}









