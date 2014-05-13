package org.interguild.game.tiles {
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.net.URLRequest;

	import org.interguild.Aeon;
	import org.interguild.INTERGUILD;
	import org.interguild.game.level.Level;
	import flash.display.Bitmap;

	public class DynamiteCrate extends CollidableObject {
		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;

		public static const LEVEL_CODE_CHAR:String = 'd';
		public static const EDITOR_ICON:BitmapData = new WoodenDynamiteSprite();

		private static const DESTRUCTIBILITY:int = 2;
		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		private static const KNOCKBACK_AMOUNT:int = 5;

		// Explosion stuff
		public var explosion:Explosion;
		public var exp:Sound;

		public function DynamiteCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			addChild(new Bitmap(new WoodenDynamiteSprite()));
			exp = new Sound();
			exp.load(new URLRequest(INTERGUILD.ORG + "/aeon_demo/Explosion.mp3"));
		}

		public override function onGameLoop():void {
			//gravity
			speedY += GRAVITY;

			//update movement
			newX += speedX;
			newY += speedY;

			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}

			//commit location change:
			x = newX;
			y = newY;
			updateHitBox();
		}

		public override function onKillEvent(level:Level):void {
			explosion = new Explosion(newX, newY);
			level.createCollidableObject(explosion);
			this.explosion.parentDestroyed = true;
			exp.play();
		}
	}
}
