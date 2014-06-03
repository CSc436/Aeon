package org.interguild.game.tiles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.SoundMan;
	import org.interguild.game.Level;

	public class DynamiteCrate extends CollidableObject {
		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;

		public static const LEVEL_CODE_CHAR:String = 'd';
		public static const EDITOR_ICON:BitmapData = Assets.DYNAMITE_WOOD_CRATE;

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		private static const KNOCKBACK_AMOUNT:int = 5;

		private var sounds:SoundMan;

		public function DynamiteCrate(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			CollidableObject.setWoodenCrateDestruction(this);

			addChild(new Bitmap(Assets.DYNAMITE_WOOD_CRATE));
			sounds = SoundMan.getMe();
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
			var explosion:Explosion = new Explosion(newX, newY);
			level.createCollidableObject(explosion);
			explosion.parentDestroyed = true;
			sounds.playSound(SoundMan.EXPLOSION_SOUND);
		}
	}
}
