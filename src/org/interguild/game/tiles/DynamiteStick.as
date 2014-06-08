package org.interguild.game.tiles {
	import flash.display.BitmapData;
	
	import org.interguild.Assets;
	import org.interguild.SoundMan;
	import org.interguild.game.Level;
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.collision.Direction;

	public class DynamiteStick extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = '%';
		public static const EDITOR_ICON:BitmapData = Assets.DYNAMITE_WOOD_CRATE;

		private static const IS_NOT_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = true;

		private static const WIDTH:uint = 16;
		private static const HEIGHT:uint = 16;
		private static const POS_OFFSET_X:int = 16 - WIDTH / 2;
		private static const POS_OFFSET_Y:int = 0;

		private static const INIT_SPEED_Y:Number = -12;
		private static const INIT_SPEED_X:Number = 8;
		private static const GRAVITY:Number = 1;

		private var sounds:SoundMan;
		private var explosion:Explosion;

		public function DynamiteStick(x:Number, y:Number, explosion:Explosion) {
			super(x, y, WIDTH, HEIGHT);
			setProperties(IS_NOT_SOLID, HAS_GRAVITY);
			destruction.destroyedBy(Destruction.ANY_SOLID_OBJECT);

			sounds = SoundMan.getMe();
			this.explosion = explosion;
			CONFIG::DEBUG {
				showHitBox();
			}
		}

		/**
		 * Called before collision detection.
		 * Should handle the gameloop for all subclasses.
		 */
		public override function onGameLoop():void {
			speedY += GRAVITY;

//			if (speedY > MAX_FALL_SPEED) {
//				speedY = MAX_FALL_SPEED;
//			}

			//update movement
			newX += speedX;
			newY += speedY;
			updateHitBox();
		}
		
		public function set playerDirection(direction:uint):void{
			if(direction == Direction.RIGHT)
				speedX = INIT_SPEED_X;
			else if(direction == Direction.LEFT)
				speedX = -INIT_SPEED_X;
			speedY = INIT_SPEED_Y;
		}

		public override function moveTo(_x:Number, _y:Number):void {
			super.moveTo(_x + POS_OFFSET_X, _y + POS_OFFSET_Y);
		}

		public override function onKillEvent(level:Level):Array {
			explosion.moveTo(newX, newY);
			sounds.playSound(SoundMan.EXPLOSION_SOUND);
			return [explosion];
		}
	}
}
