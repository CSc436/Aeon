package org.interguild.game.tiles {

	import flash.display.MovieClip;

	import org.interguild.game.collision.Destruction;

	public class Explosion extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'e';

		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;

		private var direction:int;

		public var timeCounter:int = 0;
		public var exp:MovieClip;

		public function Explosion(x:int, y:int) {
			super((x - 16), (y - 16), 64, 64);
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
		}

		public override function onGameLoop():void {
			timeCounter++;
			exp.gotoAndStop(timeCounter);
		}
	}
}
