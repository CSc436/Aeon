package org.interguild.game {
	import flash.display.MovieClip;
	
	import org.interguild.KeyMan;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;

	public class Player extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = '#';

		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 40;

		private static const SPRITE_COLOR:uint = 0xFF0000;
		private static const SPRITE_WIDTH:uint = 24;
		private static const SPRITE_HEIGHT:uint = 40;

		private static const CRAWLING_HEIGHT:uint = 32;
		private static const STANDING_HEIGHT:uint = 40;
		
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
		public var isFalling:Boolean;
		public var isJumping:Boolean;
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
				graphics.drawRect(0, 0, this.hitbox.width, this.hitbox.height);
				graphics.endFill();
			}

			playerClip = new PlayerWalkingAnimation();
			playerClip.x = -2;
			playerClip.y = -8;
			addChild(playerClip);
			isFacingRight = true; // player always starts out facing right
		}

		public override function onGameLoop():void {
			prevSpeedY = speedY;
			speedY += Level.GRAVITY;
			trace("speedY =", speedY);
			trace("speedX =", speedX);
			updateKeys();

			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}
			if (speedX > MAX_RUN_SPEED) {
				speedX = MAX_RUN_SPEED;
			} else if (speedX < -MAX_RUN_SPEED) {
				speedX = -MAX_RUN_SPEED;
			}
			
			if ( speedY > 4 ) {
				isFalling = true;
			}
			else if (speedY < 4){
				isJumping = true;
			}
			
			//update movement
			prevSpeedY = speedY;
			newX += speedX;
			newY += speedY;
			updateHitBox();
		}

		public function reset():void {
			isStanding = false;
			isCrouching = false;
			isFalling = false;
			isJumping = false;
		}

		private function updateKeys():void {


			//moving to the left
			if (keys.isKeyLeft) {
				speedX -= RUN_ACC;
				isFacingRight = false;

			} else if (speedX < 0) {
				speedX += RUN_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight) {
				speedX += RUN_ACC;
				isFacingRight = true;

			} else if (speedX > 0) {
				speedX -= RUN_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}
			
			// if player pushes both right and left stop them
			if ( keys.isKeyRight && keys.isKeyLeft && isStanding) {
				speedX = 0;
			}

			//crawl position
			if (keys.isKeyDown && isStanding) {
				isCrouching = true;
//				this.hitbox.height = CRAWLING_HEIGHT;
//				this.hitbox.y = this.hitbox.y - (STANDING_HEIGHT - CRAWLING_HEIGHT);
//				updateHitBox();
			}

			// finished crawling
			if (!keys.isKeyDown) {
				isCrouching = false;
//				this.hitbox.height = STANDING_HEIGHT;

			}

			// look up
			if (keys.isKeyUp) {
				isFacingUp = true;
			}
			// no longer looking up
			if (!keys.isKeyUp) {
				isFacingUp = false;
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

		public function updateAnimation():void {
			trace("keyspace = " + keys.isKeySpace);

			if ( isFalling || isJumping ) {
				handleJumping();
			} else if (keys.isKeyDown && isFacingRight ) {
				handleCrawlRight();
			} else if (keys.isKeyDown && !isFacingRight) {
				handleCrawlLeft();
			} else if (keys.isKeyRight && !keys.isKeyDown) {
				handleWalkRight();
			} else if (keys.isKeyLeft && !keys.isKeyDown) {
				handleWalkLeft();
			}
			// reset the animation to walking left
			else if (!keys.isKeyDown && !isFacingRight && !keys.isKeyUp && !keys.isKeyRight && !keys.isKeyLeft) {
				handleWalkLeft();
			// reset the animation to walking right
			} else if (!keys.isKeyDown && isFacingRight && !keys.isKeyUp && !keys.isKeyRight && !keys.isKeyLeft) {
				handleWalkRight();
			}

		}

		private function handleCrawlRight():void {
			if (!(playerClip is PlayerCrawlAnimation)) {
				removeChild(playerClip);
				playerClip = new PlayerCrawlAnimation();
				addChild(playerClip);
			}
			//animate moving to the right
			if (playerClip.scaleX != 1) {
				playerClip.scaleX = 1;
				prevScaleX = 1;
				playerClip.x = -20;
				
			}
			if (speedY == 4 && speedX > 1) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}

		}

		private function handleCrawlLeft():void {
			if (!(playerClip is PlayerCrawlAnimation)) {
				removeChild(playerClip);
				playerClip = new PlayerCrawlAnimation();
				addChild(playerClip);
			}
			// Use scaleX = -1 to flip the direction of movement
			if (playerClip.scaleX != -1) {
				playerClip.scaleX = -1;
				prevScaleX = -1;
				//This value might need to be changed, I think it might be off a few pixels
				playerClip.x = 45;
			}
			if (speedY == 4 && speedX < -1) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}

		}

		private function handleWalkRight():void {
			if (!(playerClip is PlayerWalkingAnimation)) {
				removeChild(playerClip);
				playerClip = new PlayerWalkingAnimation();
				playerClip.stop();
				addChild(playerClip);
			}
			//animate moving to the right
			if (playerClip.scaleX != 1) {
				playerClip.scaleX = 1;
				prevScaleX = 1;
				playerClip.x = -2;
				playerClip.y = -8;
			}
			if (speedY == 4 && speedX > 0) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}

		}

		private function handleWalkLeft():void {
			if (!(playerClip is PlayerWalkingAnimation)) {
				removeChild(playerClip);
				playerClip = new PlayerWalkingAnimation();
				addChild(playerClip);
			}
			// Use scaleX = -1 to flip the direction of movement
			if (playerClip.scaleX != -1) {
				playerClip.scaleX = -1;
				prevScaleX = -1;
				//This value might need to be changed, I think it might be off a few pixels
				playerClip.x = 25;
				playerClip.y = -8;
			}
			if (speedY == 4 && speedX < 0) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}

		}

		private function handleJumping():void {
			trace("Made it inside the handleJump, speedY = " + speedY);
			switch (speedY) {
				case -28:
				case -24:
				case -20:
				case -16:
					if (!(playerClip is PlayerJumpUpAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpUpAnimation();
						addChild(playerClip);
					}
					playerClip.gotoAndStop(0);
					break;
				case -12:
				case -8:
				case -4:
					if (!(playerClip is PlayerJumpUpAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpUpAnimation();
						addChild(playerClip);
					}
					playerClip.gotoAndStop(1);
					break;
				case 0:
					// If the player is not standing and they were previously rising in the air
					if (!isStanding && !(playerClip is PlayerJumpPeakThenFallAnimation) && prevSpeedY == -4) {
						removeChild(playerClip);
						playerClip = new PlayerJumpPeakThenFallAnimation();
						addChild(playerClip);
						playerClip.gotoAndStop(0);
					} else if (isStanding && prevSpeedY == 11 && !(playerClip is PlayerJumpLandAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpLandAnimation();
						addChild(playerClip);
						playerClip.gotoAndPlay(0);
					} else if (!(playerClip is PlayerWalkingAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerWalkingAnimation();
						addChild(playerClip);
					}
					break;
				case 4:
					if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpPeakThenFallAnimation();
						addChild(playerClip);
					}
					playerClip.gotoAndStop(3);
					break;
				case 7:
					if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
						removeChild(playerClip);
						playerClip = new PlayerJumpPeakThenFallAnimation();
						addChild(playerClip);
					}
					if (prevSpeedY == 4)
						playerClip.gotoAndStop(6);
					else
						playerClip.gotoAndStop(7);
					break;
				default:
					break;
			}
			playerClip.scaleX = prevScaleX;
			if (prevScaleX == -1)
				playerClip.x = 25;
			playerClip.y = -8;

		}
	}
}
