package org.interguild.game.tiles {

	import flash.display.MovieClip;
	
	import org.interguild.game.collision.Direction;


	public class Arrow extends CollidableObject {
		private var direction:int;
		public var parentDestroyed:Boolean;

		public static const LEVEL_CODE_CHAR:String = 'a';

		private static const DESTRUCTIBILITY:int = 0;
		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;
		
		private static const FLY_SPEED:uint = 6;

		public function Arrow(x:int, y:int, direction:int) {
			super(x, y, 1, 1);
			setProperties(DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY);

			this.direction = direction;
			this.isActive = true;
			parentDestroyed = false;
			
			//init animation
			var anim:MovieClip = new LightningArrowAnimation();
			addChild(anim);
			
			//init direction of arrow
			switch (direction) {
				case Direction.RIGHT:
					anim.rotation = 90;
					anim.x += anim.height;
					newX += 20;
					speedX = FLY_SPEED;
					break;
				case Direction.LEFT:
					anim.rotation = -90;
					anim.y += anim.width;
					newX -= 20;
					speedX = -FLY_SPEED;
					break;
				case Direction.DOWN:
					anim.rotation = 180;
					anim.x += anim.width;
					anim.y += anim.height;
					newY += 20;
					speedY = FLY_SPEED;
					break;
				default:
					newY -= 20;
					speedY = -FLY_SPEED;
					//animation is already facing up
					break;
			}
		}

//		public override function onGameLoop():void {
//			if (parentDestroyed) {
//				switch (direction) {
//					case Direction.RIGHT:
//						newX += 6;
//						break;
//					case Direction.DOWN:
//						newY += 6;
//						break;
//					case Direction.LEFT:
//						newX -= 6;
//						break;
//					case Direction.UP:
//						newY -= 6;
//						break;
//				}
//				updateHitBox();
//			}
//		}
	}
}
