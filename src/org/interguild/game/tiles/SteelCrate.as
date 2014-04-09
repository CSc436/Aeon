package org.interguild.game.tiles {
	
	import flash.display.Bitmap;
	import org.interguild.Aeon;

	public class SteelCrate extends CollidableObject implements Tile {
		
		public static const LEVEL_CODE_CHAR:String = 's';
		
		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;

		private static const SPRITE_COLOR:uint = 0xA3A3A3;
		private static const SPRITE_WIDTH:uint = 32;
		private static const SPRITE_HEIGHT:uint = 32;

		public var destructibility:int = 1;
		public var solidity:Boolean = true;
		public var gravible:Boolean = false;
		public var knocksback:int = 0;
		public var buoyancy:Boolean = false;
		
		public function SteelCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			addChild(new Bitmap(new SteelCrateSprite()));

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

		public override function onGameLoop():void {
			//gravity
			speedY += GRAVITY;

			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}

			//update movement
			newX += speedX;
			newY += speedY;
			updateHitBox();
		}
	}
}
