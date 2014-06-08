package org.interguild.game.tiles {

	import flash.display.MovieClip;
	
	import org.interguild.game.collision.Destruction;

	public class Explosion extends CollidableObject {

		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;
		
		private static const POS_OFFSET_X:int = -16;
		private static const POS_OFFSET_Y:int = -16;
		private static const EXP_WIDTH:int = 64;
		private static const EXP_HEIGHT:int = 64;
		
		public var timeCounter:int = 0;
		public var exp:MovieClip;

		public function Explosion(x:int, y:int) {
			super(x, y, EXP_WIDTH, EXP_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyedBy(Destruction.NOTHING);
			destruction.destroyWithMarker(Destruction.EXPLOSIONS);
			isActive = false;

			//init animation
			exp = new ExplosionAnimation();
			exp.x = -32;
			exp.y = -62;
			exp.play();
			addChild(exp);
			
			CONFIG::DEBUG{
				showHitBox();
			}
		}

		public override function onGameLoop():void{
				timeCounter++;
				exp.gotoAndStop(timeCounter);
		}
		
		public override function moveTo(_x:Number, _y:Number):void{
			super.moveTo(_x + POS_OFFSET_X, _y + POS_OFFSET_Y);
		}
	}
}
