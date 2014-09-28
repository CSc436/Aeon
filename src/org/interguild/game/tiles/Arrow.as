package org.interguild.game.tiles {

	import flash.display.MovieClip;
	
	import org.interguild.SoundMan;
	import org.interguild.game.Level;
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.collision.Direction;


	public class Arrow extends CollidableObject {

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = false;

		private static const HITBOX_WIDTH:int = 22;
		private static const HITBOX_HEIGHT:int = 8;

		private static const FLY_SPEED:uint = 8;
		private static const ANIM_OFFSET_FROM_CENTER:uint = 1;
		private static const POS_OFFSET_FROM_CENTER:uint = 8;
		
		private static const EXP_OFFSET:uint = 20;

		private var direction:uint;
		private var anim:MovieClip;
		private var hwidth:Number, hheight:Number;
		private var sounds:SoundMan;
		private var exp:ArrowExplosion;

		public function Arrow(x:int, y:int, direction:int, exp:ArrowExplosion) {
			//init animation
			anim = new RocketAnimation();
			addChild(anim);

			sounds = SoundMan.getMe();

			this.exp = exp;
			//init direction of arrow
			this.direction = direction;
			switch (direction) {
				case Direction.RIGHT:
					speedX = FLY_SPEED;
					hwidth = HITBOX_WIDTH;
					hheight = HITBOX_HEIGHT;
					break;
				case Direction.LEFT:
					anim.rotation = 180;
					anim.x += anim.width;
					anim.y += anim.height;
					speedX = -FLY_SPEED;
					hwidth = HITBOX_WIDTH;
					hheight = HITBOX_HEIGHT;
					break;
				case Direction.DOWN:
					anim.rotation = 90;
					anim.x += anim.height;
					speedY = FLY_SPEED;
					hheight = HITBOX_WIDTH;
					hwidth = HITBOX_HEIGHT;
					break;
				default: //up
					anim.rotation = -90;
					anim.y += anim.width;
					speedY = -FLY_SPEED;
					hheight = HITBOX_WIDTH;
					hwidth = HITBOX_HEIGHT;
					//animation is already facing up
					break;
			}
			super(x, y, hwidth, hheight);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyWithMarker(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.ANY_SOLID_OBJECT);
			ignore(Spike);
			ignore(Arrow);
			ignore(DynamiteStick);

			this.isActive = false;

			CONFIG::DEBUG {
				showHitBox();
			}
		}

		public override function moveTo(_x:Number, _y:Number):void {
			switch (direction) {
				case Direction.RIGHT:
					anim.x += hwidth / 2 - anim.width / 2 - ANIM_OFFSET_FROM_CENTER;
					anim.y += hheight / 2 - anim.height / 2;
					_x += 16 - hwidth / 2 + POS_OFFSET_FROM_CENTER;
					_y += 16 - hheight / 2;
					break;
				case Direction.LEFT:
					anim.x += hwidth / 2 - anim.width / 2 + ANIM_OFFSET_FROM_CENTER;
					anim.y += hheight / 2 - anim.height / 2;
					_x += 16 - hwidth / 2 - POS_OFFSET_FROM_CENTER;
					_y += 16 - hheight / 2;
					break;
				case Direction.DOWN:
					anim.x += hwidth / 2 - anim.width / 2;
					anim.y += hheight / 2 - anim.height / 2 - ANIM_OFFSET_FROM_CENTER;
					_x += 16 - hwidth / 2;
					_y += 16 - hheight / 2 + POS_OFFSET_FROM_CENTER;
					break;
				default: //up
					anim.x += hwidth / 2 - anim.width / 2;
					anim.y += hheight / 2 - anim.height / 2 + ANIM_OFFSET_FROM_CENTER;
					_x += 16 - hwidth / 2;
					_y += 16 - hheight / 2 - POS_OFFSET_FROM_CENTER;
					break;
			}
			super.moveTo(_x, _y);
		}

		public override function onKillEvent(level:Level):Array {
			var offx:Number = 0, offy:Number = 0;
			switch (direction) {
				case Direction.RIGHT:
					offx = EXP_OFFSET;
					break;
				case Direction.LEFT:
					offx = -EXP_OFFSET;
					break;
				case Direction.DOWN:
					offy = EXP_OFFSET;
					break;
				default: //up
					offy = -EXP_OFFSET;
					break;
			}
			exp.moveTo(newX + hwidth / 2 - exp.width / 2 + offx, newY + hheight / 2 - exp.height / 2 + offy);
			sounds.playSound(SoundMan.EXPLOSION_SOUND);
			return [exp];
		}
	}
}
