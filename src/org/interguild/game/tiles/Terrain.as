package org.interguild.game.tiles {
	import org.interguild.Aeon;

	public class Terrain extends CollidableObject implements Tile {
		public var destructibility:int = 0;
		public var solidity:Boolean = true;
		public var gravible:Boolean = false;
		public var knocksback:int = 0;
		public var buoyancy:Boolean = false;

		public var startX:int;
		public var startY:int;

		private static const SPRITE_COLOR:uint = 0x9EDB00;
		private static const SPRITE_WIDTH:uint = 32;
		private static const SPRITE_HEIGHT:uint = 32;


		public function Terrain(x:int, y:int) {
			super(Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			this.x = x;
			this.y = y;
			startX = x;
			startY = y;
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
			return false;
		}
	}
}