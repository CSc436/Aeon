package org.interguild.game.tiles {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.collision.Direction;

	public class Platform extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = '-';
		public static const EDITOR_ICON:BitmapData = Assets.WOODEN_PLATFORM;

		private static const IS_SOLID:Boolean = true;
		private static const NO_GRAVITY:Boolean = false;

		private static const HEIGHT:uint = 16;
		private static const MIN_SPEED_Y:uint = 0;
		private static const MIN_CENTER_Y:uint = 10;

		public function Platform(x:uint, y:uint) {
			super(x, y, Aeon.TILE_WIDTH, HEIGHT);
			setProperties(IS_SOLID, NO_GRAVITY);
			destruction.destroyedBy(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.EXPLOSIONS);
			destruction.destroyedBy(Destruction.BOULDERS);

			CONFIG::DEBUG {
				showHitBox();
			}
		}

		public function countsCollision(activeObject:CollidableObject, activeBoxCurr:Rectangle):Boolean {
			var centerY:Number = activeBoxCurr.y + activeBoxCurr.height / 2;
			return activeObject.speedY >= MIN_SPEED_Y && centerY <= newY + MIN_CENTER_Y && !isBlocked(Direction.UP);
		}
	}
}
