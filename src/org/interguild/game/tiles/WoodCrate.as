package org.interguild.game.tiles {
	import org.hamcrest.object.instanceOf;
	import org.interguild.Aeon;
	
	public class WoodCrate extends CollidableObject implements Tile {
		public var destructibility:int = 2;
		public var solidity:Boolean = true;
		public var gravible:Boolean = true;
		public var knocksback:int = 5;
		public var buoyancy:Boolean = true; 
		
		private static const SPRITE_COLOR:uint = 0x723207;
		private static const SPRITE_WIDTH:uint = 32;
		private static const SPRITE_HEIGHT:uint = 32;
		
		private static const TILE_ENCODING:String = 'w';
		
		public function WoodCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();
			
		}
		
		public function getDestructibility():int {
			return destructibility;
		}
		
		
		public function isSolid():Boolean {
			return solidity;
		}
		
		
		public function isGravible():Boolean {
			return gravible;
		}
		
		
		public function doesKnockback():int {
			return knocksback;
		}
		
		
		public function isBuoyant():Boolean {
			return buoyancy;
		}
	}
}

