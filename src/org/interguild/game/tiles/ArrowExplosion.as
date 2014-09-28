package org.interguild.game.tiles {
	import flash.display.MovieClip;

	public class ArrowExplosion extends CollidableObject {

		private static const ARROW_EXPLOSION_SCALE:Number = 0.3;
		private static const EXPLOSION_TIME_LENGTH:uint = 15;

		private var timeCounter:int = 6;
		private var exp:MovieClip;

		public function ArrowExplosion() {
			exp = new ExplosionAnimation();
			exp.scaleX = exp.scaleY = ARROW_EXPLOSION_SCALE;
			exp.gotoAndStop(timeCounter);
			super(0, 0, 1, 1);
			setProperties(false, false);

			this.isActive = false;
			this.visible = false;
			doActiveCollisions = false;
			addChild(exp)
			exp.play();

			CONFIG::DEBUG {
				showHitBox();
			}
		}

		public override function onGameLoop():void {
			timeCounter++;
			exp.gotoAndStop(timeCounter);
		}

		public override function get timeToDie():Boolean {
			return timeCounter >= EXPLOSION_TIME_LENGTH;
		}
	}
}
