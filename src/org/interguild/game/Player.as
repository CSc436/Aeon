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

		private static const MAX_FALL_SPEED:Number = 14;
		private static const MAX_RUN_SPEED:Number = 6;

		private static const RUN_ACC:Number = MAX_RUN_SPEED;
		private static const RUN_FRICTION:Number = 2;

		private static const JUMP_SPEED:Number = -28;

		private var maxSpeedY:Number = MAX_FALL_SPEED;
		private var maxSpeedX:Number = MAX_RUN_SPEED;

		private var keys:KeyMan;

		public var wasJumping:Boolean;

		public var isStanding:Boolean;
		public var isFacingLeft:Boolean;
		public var isFacingRight:Boolean;
		public var isFacingUp:Boolean;
		public var isCrouching:Boolean;

		private var playerClip:MovieClip;
		private var prevSpeedY:Number = 0;
		private var prevScaleX:Number = 1;
		
		public function Player() {
			super(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT);
			drawPlayer();
			isActive = true;
			keys = KeyMan.getMe();
		}

		public function setStartPosition(sx:Number, sy:Number):void {
			x = newX = startX = sx;
			y = newY = startY = sy - hitbox.height + 32;
			updateHitBox();
			finishGameLoop();
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
			switch(speedY) {
				case -28:
				case -24:
				case -20:
				case -16:
					if(!(playerClip is PlayerJumpUpAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpUpAnimation();
						addChild(playerClip);
					}
					playerClip.gotoAndStop(0);
					break;
				case -12:
				case -8:
				case -4:
					if(!(playerClip is PlayerJumpUpAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpUpAnimation();
						addChild(playerClip);
					}
					playerClip.gotoAndStop(1);
					break;
				case 0:
					// If the player is not standing and they were previously rising in the air
					if(!isStanding && !(playerClip is PlayerJumpPeakThenFallAnimation) && prevSpeedY == -4) {
						removeChild(playerClip);
						playerClip = new PlayerJumpPeakThenFallAnimation();
						addChild(playerClip);
						playerClip.gotoAndStop(0);
					}
					else if(isStanding && prevSpeedY == 11 && !(playerClip is PlayerJumpLandAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpLandAnimation();
						addChild(playerClip);
						playerClip.gotoAndPlay(0);
						trace("land animation")
					}
					else if(!(playerClip is PlayerWalkingAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerWalkingAnimation();
						addChild(playerClip);
					}
					break;
				case 4:
					if(!(playerClip is PlayerJumpPeakThenFallAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpPeakThenFallAnimation();
						addChild(playerClip);
					}
					playerClip.gotoAndStop(3);
					break;
				case 7:
					if(!(playerClip is PlayerJumpPeakThenFallAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpPeakThenFallAnimation();
						addChild(playerClip);
					}
					if(prevSpeedY == 4)
						playerClip.gotoAndStop(6);
					else
						playerClip.gotoAndStop(7);
					break;
				default:
					break;	
			}

			playerClip.scaleX = prevScaleX;
			if(prevScaleX == -1)
				playerClip.x = 25;
			playerClip.y = -8;
			
			prevSpeedY = speedY;
			speedY += Level.GRAVITY;
			updateKeys();

			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}
			if (speedX > MAX_RUN_SPEED) {
				speedX = MAX_RUN_SPEED;
			} else if (speedX < -MAX_RUN_SPEED) {
				speedX = -MAX_RUN_SPEED;
			}

			//update movement
			newX += speedX;
			newY += speedY;
			updateHitBox();
		}

		public function reset():void {
			isStanding = false;
			isFacingLeft = false;
			isFacingRight = false;
			isFacingUp = false;
			isCrouching = false;
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
					prevScaleX = -1;
					//This value might need to be changed, I think it might be off a few pixels
					playerClip.x = 25;
				}
				if(speedY == 4) {
					if(playerClip.currentFrame != playerClip.totalFrames)
						playerClip.nextFrame();
					else
						playerClip.gotoAndStop(0);
				}

				isFacingLeft = true;
				
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
					prevScaleX = 1;
					playerClip.x = -2;
				}
				if(speedY == 4) {
					if(playerClip.currentFrame != playerClip.totalFrames)
						playerClip.nextFrame();
					else
						playerClip.gotoAndStop(0);
				}

				isFacingRight = true;

			} else if (speedX > 0) {
				speedX -= RUN_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}
			
			// look up
			if ( keys.isKeyUp ) {
				isFacingUp = true;
			}

			//jump
			if (keys.isKeySpace && isStanding && !wasJumping) {
				speedY = JUMP_SPEED;
			}

			if (keys.isKeySpace)
				wasJumping = true;
			else
				wasJumping = false;
			
			if (keys.isKeyDown){
				isCrouching = true;
			}
		}
	}
}
