package org.interguild.game.tiles {

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import org.interguild.Aeon;
	import org.interguild.game.collision.Direction;


	public class Arrow extends CollidableObject {
		private var direction:int;
		public var parentDestroyed:Boolean;

		public static const LEVEL_CODE_CHAR:String='a';

		public static const DESTRUCTIBILITY:int=0;
		public static const IS_SOLID:Boolean=false;
		public static const HAS_GRAVITY:Boolean=false;
		public static const KNOCKBACK_AMOUNT:int=0;
		public static const IS_BUOYANT:Boolean=true;

		public function Arrow(x:int, y:int, direction:int) {
			super(x, y, 1, 1, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			this.direction=direction;
			parentDestroyed=false;
			this.isActive=true;
			var anim:MovieClip = new LightningArrowAnimation();
			addChild(anim);
			switch (direction) {
				case Direction.RIGHT:
					anim.rotation = 90;
					anim.x += anim.height;
					newX+= 32;
					break;
				case Direction.LEFT:
					anim.rotation = -90;
					anim.y += anim.width;
					newX-=32;
					break;
				case Direction.DOWN:
					anim.rotation = 180;
					anim.x += anim.width;
					anim.y += anim.height;
					newY+=32;
					break;
				default:
					newY-=32;
					//animation is already facing up
					break;
			}
		}

		public override function onGameLoop():void {
			if (parentDestroyed) {
				switch (direction) {
					case Direction.RIGHT:
						newX+=6;
						break;
					case Direction.DOWN:
						newY+=6;
						break;
					case Direction.LEFT:
						newX-=6;
						break;
					case Direction.UP:
						newY-=6;
						break;
				}
				updateHitBox();
			}
		}
	}
}
