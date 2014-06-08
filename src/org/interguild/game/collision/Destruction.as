package org.interguild.game.collision {

	public class Destruction {
		
		public static const NOTHING:uint = 0; //for terrain only
		public static const ARROWS:uint = 1;
		public static const EXPLOSIONS:uint = 1 << 1;
		public static const SPIKES:uint = 1 << 2;
		public static const PLAYER:uint = 1 << 3;
		public static const BOULDERS:uint = 1 << 4;
		public static const FALLING_SOLID_OBJECTS:uint = 1 << 5;
		public static const ANY_SOLID_OBJECT:uint = 1 << 6;
		
		private var defend:uint = 0x0;
		private var attack:uint = 0x0;
		
		public function Destruction() {
		}
		
		/**
		 * Will be destroyed by the scenarios represented by the
		 * given constant.
		 */
		public function destroyedBy(constant:uint):void{
			defend = defend | constant;
		}
		
		/**
		 * Will destroy all objects who have marked themselves as
		 * destroyedBy the given constant.
		 */
		public function destroyWithMarker(constant:uint):void{
			attack = attack | constant;
		}
		
		public function canDestroy(other:Destruction):Boolean{
			if((this.attack & other.defend) > 0)
				return true;
			else
				return false;
		}
		
		public function isDestroyedBy(constant:uint):Boolean{
			return (defend & constant) > 0;
		}
	}
}
