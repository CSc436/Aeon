package org.interguild.game.tiles {

	import flash.display.MovieClip;

	import org.interguild.game.collision.Destruction;

	public class Explosion extends CollidableObject {

		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;

		private static const POS_OFFSET_X:int = -15;
		private static const POS_OFFSET_Y:int = -15;
		private static const EXP_WIDTH:int = 62;
		private static const EXP_HEIGHT:int = 62;

		private static const EXPLOSION_TIME_LENGTH:uint = 15;

		private var timeCounter:int = 0;
		private var exp:MovieClip;

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

			CONFIG::DEBUG {
				showHitBox();
			}
		}

		public override function onGameLoop():void {
			timeCounter++;
			exp.gotoAndStop(timeCounter);
			if (timeCounter > 1)
				doActiveCollisions = false;
		}

		public override function get timeToDie():Boolean {
			return timeCounter >= EXPLOSION_TIME_LENGTH;
		}

		public override function moveTo(_x:Number, _y:Number):void {
			super.moveTo(_x + POS_OFFSET_X, _y + POS_OFFSET_Y);
		}
	}
}
