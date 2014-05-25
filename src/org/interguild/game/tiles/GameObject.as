package org.interguild.game.tiles {
	import flash.display.Sprite;
	import org.interguild.game.level.Level;

	/**
	 * Treat this like an abstract class. Defines general
	 * purpose interface for Level to communicate with
	 * objects without knowing what they are.
	 */
	public class GameObject extends Sprite {
		
		public var newX:Number;
		public var newY:Number;
		
		public var startX:int;
		public var startY:int;
		
		public var speedX:Number = 0;
		public var speedY:Number = 0;

		/**
		 * DO NOT INSTANTIATE THIS CLASS
		 */
		public function GameObject(_x:Number, _y:Number) {
			newX = startX = x = _x;
			newY = startY = y = _y;
		}

		/**
		 * Updates the object for the current frame
		 */
		public function onGameLoop():void {
		}
		
		public function onKillEvent(level:Level):void {	
		}
		
		public function finishGameLoop():void{
			//commit location change:
			x = newX;
			y = newY;
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









