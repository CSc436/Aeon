package org.interguild.game.tiles {
	import flash.display.BitmapData;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.game.collision.Destruction;

	public class Boulder extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'o';
		public static const EDITOR_ICON:BitmapData = Assets.BOULDER;

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;

		private static const PUSH_SPEED:uint = 10;

		private var stopX:Number;
		private var biasOnRight:Boolean = false;
		
		public function Boulder(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyedBy(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.EXPLOSIONS);

			setFaces(Assets.BOULDER);
		}
		
		public function pushRight():void {
			speedX = PUSH_SPEED;
			stopX = newX + 32;
			biasOnRight = true;
		}

		public function pushLeft():void {
			speedX = -PUSH_SPEED;
			stopX = newX - 32;
			biasOnRight = false;
		}
		
		public function get biasToRight():Boolean{
			return biasOnRight;
		}

		public override function onGameLoop():void {
			if (speedX == 0) {
				super.onGameLoop();
			} else {
				if (speedX > 0 && newX + speedX >= stopX) {
					newX = stopX;
					speedX = 0;
				} else if (speedX < 0 && newX + speedX <= stopX) {
					newX = stopX;
					speedX = 0;
				}

				//update movement
				newX += speedX;
				newY += speedY;
				updateHitBox();
			}
		}
	}
}
