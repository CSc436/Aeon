package org.interguild.game.tiles
{
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.interguild.Aeon;
	import org.interguild.game.level.Level;
	
	public class DynamiteCrate extends CollidableObject
	{
		private static const GRAVITY:uint = 4;
		private static const MAX_FALL_SPEED:Number = 6;
		
		public static const LEVEL_CODE_CHAR:String = 'd';
		public static const DESTRUCTIBILITY:int=2;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=true;
		public static const KNOCKBACK_AMOUNT:int=5;
		public static const IS_BUOYANT:Boolean=true;
		
		// Explosion stuff
		public var explosion:Explosion;
		public var exp:Sound;
		
		public function DynamiteCrate(x:int, y:int)
		{
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			addChild(new PlayerWalkingAnimation());
			exp = new Sound();
			exp.load(new URLRequest("../assets/Explosion.mp3"));
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