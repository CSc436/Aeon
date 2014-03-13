package org.interguild.game {

	import flash.display.MovieClip;

	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;

	public class Player extends CollidableObject {

		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 40;

		private static const SPRITE_COLOR:uint = 0xFF0000;
		private static const SPRITE_WIDTH:uint = 24;
		private static const SPRITE_HEIGHT:uint = 40;

		private static const MAX_FALL_SPEED:Number = 7;
		private static const MAX_RUN_SPEED:Number = 3;

		private static const RUN_ACC:Number = MAX_RUN_SPEED;
		private static const RUN_FRICTION:Number = 2;

		private static const JUMP_SPEED:Number = -28;

		private var maxSpeedY:Number = MAX_FALL_SPEED;
		private var maxSpeedX:Number = MAX_RUN_SPEED;

		private var keys:KeyMan;
		public var wasJumping:Boolean;
		public var isStanding:Boolean;

		private var playerClip:MovieClip;

		public function Player() {
			super(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT);
			drawPlayer();
			isActive = true;
			keys = KeyMan.getMe();
		}

		public function setStartPosition(sx:Number, sy:Number):void {
			x = newX = startX = sx;
			y = newY = startY = sy;
		}

		private function drawPlayer():void {

			CONFIG::DEBUG {
				graphics.beginFill(SPRITE_COLOR);
				graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
				graphics.endFill();
			}

			playerClip = new PlayerWalkingAnimation();
			playerClip.x = -2;
			playerClip.y = -8;
			addChild(playerClip);

		}

		public override function onGameLoop():void {

			/*
			// -28, -24, -20, -16, -12, -8, -4, 0, 4, 7 are all the possible vertical speeds
			switch(speedY) {
				case -28:
				case -24:
					removeChild(currSprite);
					currSprite = spriteJumpArray[1];
					addChild(currSprite);
					break;
				case -20:
				case -16:
					removeChild(currSprite);
					currSprite = spriteJumpArray[2];
					addChild(currSprite);
					break;
				case -12:
				case -8:
					removeChild(currSprite);
					currSprite = spriteJumpArray[3];
					addChild(currSprite);
					break;
				case -4:
					removeChild(currSprite);
					currSprite = spriteJumpArray[4];
					addChild(currSprite);
					break;
				case 4:
				case 7:
					removeChild(currSprite);
					currSprite = spriteJumpArray[5];
					addChild(currSprite);
					break;
				case 0:
					if(!isStanding) {
						removeChild(currSprite);
						currSprite = spriteJumpArray[0];
						addChild(currSprite);
					}
					break;
				default:
					break;
			}
			*/

			//gravity
			speedY += Level.GRAVITY;

			updateKeys();

			// reset isStanding
			reset();

			//update movement
			newX += speedX;
			newY += speedY;

			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}
			if (speedX > MAX_RUN_SPEED) {
				speedX = MAX_RUN_SPEED;
			} else if (speedX < -MAX_RUN_SPEED) {
				speedX = -MAX_RUN_SPEED;
			}

			//commit location change:
			x = newX;
			y = newY;
		}

		private function reset():void {
			isStanding = false;
		}

		private function updateKeys():void {

			if (!keys.isKeyLeft && !keys.isKeyRight && isStanding)
				playerClip.gotoAndStop(0);

			//moving to the left
			if (keys.isKeyLeft) {
				speedX -= RUN_ACC;
				// Use scaleX = -1 to flip the direction of movement
				if (playerClip.scaleX != -1) {
					playerClip.scaleX = -1;
					//This value might need to be changed, I think it might be off a few pixels
					playerClip.x = 25;
				}
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			} else if (speedX < 0) {
				speedX += RUN_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight) {
				speedX += RUN_ACC;
				//animate moving to the right
				if (playerClip.scaleX != 1) {
					playerClip.scaleX = 1;
					playerClip.x = -2;
				}
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			} else if (speedX > 0) {
				speedX -= RUN_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}

			//jump
			if (keys.isKeySpace && isStanding && !wasJumping) {
				speedY = JUMP_SPEED;
			}
			if (keys.isKeySpace)
				wasJumping = true;
			else
				wasJumping = false;
		}
	}
}
