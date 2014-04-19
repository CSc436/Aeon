package org.interguild.game.tiles {
	
	import flash.display.Bitmap;
	import org.interguild.Aeon;
	
	public class WoodCrate extends CollidableObject implements Tile {
		
		public static const LEVEL_CODE_CHAR:String = 'w';
		
		public function WoodCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			addChild(new Bitmap(new WoodenCrateSprite()));
		}
		
		public function getDestructibility():int {
			return 2;
		}
		
		
		public function isSolid():Boolean {
			return true;
		}
		
		
		public function isGravible():Boolean {
			return true;
		}
		
		
		public function doesKnockback():int {
			return 5;
		}
		
		
		public function isBuoyant():Boolean {
			return true;
		}
	}
}

