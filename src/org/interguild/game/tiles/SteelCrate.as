package org.interguild.game.tiles {
	
	import flash.display.Bitmap;
	import org.interguild.Aeon;

	public class SteelCrate extends CollidableObject implements Tile {
		
		public static const LEVEL_CODE_CHAR:String = 's';
		
		public function SteelCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			addChild(new Bitmap(new SteelCrateSprite()));
		}

		public function getDestructibility():int {
			return 1;
		}


		public function isSolid():Boolean {
			return true;
		}


		public function isGravible():Boolean {
			return true;
		}


		public function doesKnockback():int {
			return 0;
		}


		public function isBuoyant():Boolean {
			return false;
		}
	}
}
