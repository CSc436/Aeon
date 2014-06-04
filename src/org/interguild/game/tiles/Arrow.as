package org.interguild.game.tiles {

	import flash.display.MovieClip;
	
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.collision.Direction;


	public class Arrow extends CollidableObject {
		public static const LEVEL_CODE_CHAR:String = 'a';

		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;
		
		private static const HITBOX_WIDTH:int = 16;
		private static const HITBOX_HEIGHT:int = 6;
		
		private static const FLY_SPEED:uint = 6;
		
		private var direction:uint;
		private var anim:MovieClip;

		public function Arrow(x:int, y:int, direction:int) {
			super(x, y, HITBOX_WIDTH, HITBOX_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyWithMarker(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.ANY_SOLID_OBJECT);

			this.isActive = false;
			
			//init animation
			anim = new LightningArrowAnimation();
			addChild(anim);
			
			//init direction of arrow
			this.direction = direction;
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
				default: //up
					newY -= 20;
					speedY = -FLY_SPEED;
					//animation is already facing up
					break;
			}
			CONFIG::DEBUG{
				showHitBox();
			}
		}
		
		public override function moveTo(_x:Number, _y:Number):void{
			anim.x += HITBOX_WIDTH / 2 - anim.width / 2;
			anim.y += HITBOX_HEIGHT / 2 - anim.height / 2;
			_x += 16 - HITBOX_WIDTH / 2;
			_y += 16 - HITBOX_HEIGHT / 2;
			switch (direction) {
				case Direction.RIGHT:
					anim.x -= 4;
					break;
				case Direction.LEFT:
					anim.x += 4;
					break;
				case Direction.DOWN:
					anim.y += 4;
					break;
				default: //up
					anim.y -= 4;
					break;
			}
			super.moveTo(_x, _y);
		}
	}
}
