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
		public var isStanding:Boolean;
		
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
			y = newY = startY = sy;
		}

		private function drawPlayer():void {

			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();
			
			playerClip = new PlayerWalkingAnimation();
			playerClip.x = -2;
			playerClip.y = -8;
			addChild(playerClip);
			
			trace("There are " + (new PlayerJumpUpAnimation().totalFrames) + " frames in the jump up animation");
			trace("There are " + (new PlayerJumpPeakThenFallAnimation().totalFrames) + " frames in the jump peak then fall animation");
			trace("There are " + (new PlayerJumpLandAnimation().totalFrames) + " frames in the jump land animation");
			
		}

		public override function onGameLoop():void {
			
	
			// -28, -24, -20, -16, -12, -8, -4, 0, 4, 7 are all the possible vertical speeds
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
			
			//gravity
			speedY += Level.GRAVITY;

			updateKeys();

			// reset isStanding
			reset();

			//update movement
			prevSpeedY = speedY;
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
			
			if(!keys.isKeyLeft && !keys.isKeyRight && isStanding)
				playerClip.gotoAndStop(0);
			
			//moving to the left
			if (keys.isKeyLeft) {
				speedX -= RUN_ACC;
				// Use scaleX = -1 to flip the direction of movement
				if(playerClip.scaleX != -1) {
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
			} else if (speedX < 0) {
				speedX += RUN_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight) {
				speedX += RUN_ACC;
				//animate moving to the right
				if(playerClip.scaleX != 1) {
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
			} else if (speedX > 0) {
				speedX -= RUN_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}

			//jump
			if (keys.isKeySpace && isStanding) {
				speedY = JUMP_SPEED;
			}
		}
	}
}
