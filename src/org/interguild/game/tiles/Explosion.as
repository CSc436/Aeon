package org.interguild.game.tiles {

	import flash.display.MovieClip;

	public class Explosion extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'e';

		private static const DESTRUCTIBILITY:int = 0;
		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;

		private var direction:int;
		public var parentDestroyed:Boolean;

		public var timeCounter:int = 0;
		public var exp:MovieClip;

		public function Explosion(x:int, y:int) {
			super((x - 16), (y - 16), 64, 64);
			setProperties(DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY);
			isActive = true;
			parentDestroyed = false;

			//init animation
			exp = new ExplosionAnimation();
			exp.x = -32;
			exp.y = -62;
			exp.play();
			addChild(exp);
		}

		public override function onGameLoop():void {
			if (parentDestroyed) {
				timeCounter++;
				exp.gotoAndStop(timeCounter);
			}
		}
	}
}
