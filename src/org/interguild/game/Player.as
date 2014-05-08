package org.interguild.game {
	import flash.display.MovieClip;

	import org.interguild.KeyMan;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;

	public class Player extends CollidableObject {
		CONFIG::DEBUG {
			private static const SPRITE_COLOR:uint=0xFF0000;
			private static const SPRITE_WIDTH:uint=24;
			private static const SPRITE_HEIGHT:uint=40;
		}

		private static const HITBOX_WIDTH:uint=24;
		private static const HITBOX_HEIGHT:uint=40;

		private static const CRAWLING_HEIGHT:uint=32;
		private static const STANDING_HEIGHT:uint=40;

		public var frameCounter:int=0;
		public var frameJumpCounter:int;

		private static const MAX_FALL_SPEED:Number=14;
		private static const MAX_RUN_SPEED:Number=6;

		private static const RUN_ACC:Number=MAX_RUN_SPEED;
		private static const RUN_FRICTION:Number=2;

		private static const JUMP_SPEED:Number=-20;
		public static const KNOCKBACK_JUMP_SPEED:Number=-14;
		public static const KNOCKBACK_HORIZONTAL:Number=20;

		private var maxSpeedY:Number=MAX_FALL_SPEED;
		private var maxSpeedX:Number=MAX_RUN_SPEED;

		private var keys:KeyMan;

		public var wasJumping:Boolean;

		public var isStanding:Boolean;
		public var isFacingRight:Boolean;
		public var isFacingUp:Boolean;
		public var isCrouching:Boolean;
		public var isFalling:Boolean;
		public var isJumping:Boolean;
		public var isDead:Boolean;

		private var playerClip:MovieClip;
		private var prevSpeedY:Number=0;
		private var prevScaleX:Number=1;

		//TODO are these values correct? Henry
		public static const LEVEL_CODE_CHAR:String='#';
		public static const DESTRUCTIBILITY:int=2;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=true;
		public static const KNOCKBACK_AMOUNT:int=5;
		public static const IS_BUOYANT:Boolean=false;

		public function Player() {
			super(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			drawPlayer();
			isActive=true;
			keys=KeyMan.getMe();
			isDead=false;
		}

		public function setStartPosition(sx:Number, sy:Number):void {
			x=newX=startX=sx;
			y=newY=startY=sy - hitbox.height + 32;
			updateHitBox();
			finishGameLoop();
		}

		private function drawPlayer():void {
			CONFIG::DEBUG {
				graphics.beginFill(SPRITE_COLOR);
				graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
				graphics.endFill();
			}

			playerClip=new PlayerWalkingAnimation();
			playerClip.x=-2;
			playerClip.y=-8;
			addChild(playerClip);
			isFacingRight=true; // player always starts out facing right
		}

		public override function onGameLoop():void {
			speedY+=Level.GRAVITY;
			trace("speedY =", speedY);
			trace("speedX =", speedX);

			updateKeys();

			if (speedY > MAX_FALL_SPEED) {
				speedY=MAX_FALL_SPEED;
			}
			if (speedX > MAX_RUN_SPEED) {
				speedX=MAX_RUN_SPEED;
			} else if (speedX < -MAX_RUN_SPEED) {
				speedX=-MAX_RUN_SPEED;
			}

			//update movement
			prevSpeedY=speedY;
			newX+=speedX;
			newY+=speedY;
			updateHitBox();

			trace("speedY = ", speedY);
			if (speedY > 6 && !isJumping ) {
				isFalling=true;
			}
			else 
				isFalling=false;

			if (speedY != 2)
				isStanding=false;

		}

		public function reset():void {
//			isStanding=false;
//			isCrouching=false;
//			isFalling=false;
//			isJumping = false;
		}

		private function updateKeys():void {
			if (!keys.isKeyLeft && !keys.isKeyRight && !keys.isKeyDown && isStanding)
				playerClip.gotoAndStop(0);

			//moving to the left
			if (keys.isKeyLeft && !keys.isKeyRight) {
				speedX-=RUN_ACC;
				isFacingRight=false;
			} else if (speedX < 0) {
				speedX+=RUN_FRICTION;
				if (speedX > 0)
					speedX=0;
			}
			//moving to the right
			if (keys.isKeyRight && !keys.isKeyLeft) {
				speedX+=RUN_ACC;
				isFacingRight=true;
			} else if (speedX > 0) {
				speedX-=RUN_FRICTION;
				if (speedX < 0)
					speedX=0;
			}

			if (keys.isKeyDown && isStanding) {
				isCrouching=true;
				this.hitbox.height=CRAWLING_HEIGHT;
			}

			// finished crawling
			if (!keys.isKeyDown) {
				isCrouching=false;
				this.hitbox.height=STANDING_HEIGHT;
			}


			// if player pushes both right and left stop them
			if (keys.isKeyRight && keys.isKeyLeft && isStanding) {
				speedX=0;
				playerClip.gotoAndStop(0); // reset animation
			}

			// look up
			if (keys.isKeyUp) {
				isFacingUp=true;
			}
			// no longer looking up
			if (!keys.isKeyUp) {
				isFacingUp=false;
			}

			//jump
			if (keys.isKeySpace && isStanding && !wasJumping) {
				speedY=JUMP_SPEED;
				isStanding=false;
				isJumping=true;
				frameJumpCounter=frameCounter;
			}

			if (keys.isKeySpace)
				wasJumping=true;
			else
				wasJumping=false;
		}

		public function updateAnimation():void {
			if (!isDead) {
				if (isJumping) {
					handleJumping();
				} else if (isFalling && !isStanding ) {
					handleFalling();
				} else if (keys.isKeyDown && isFacingRight && isStanding) {
					handleCrawlRight();
				} else if (keys.isKeyDown && !isFacingRight && isStanding) {
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
		}

		private function handleCrawlRight():void {
			if (!(playerClip is PlayerCrawlAnimation)) {
				removeChild(playerClip);
				playerClip=new PlayerCrawlAnimation();
				playerClip.stop();
				addChild(playerClip);
				playerClip.gotoAndStop(0);
			}
			//animate moving to the right
			playerClip.scaleX=1;
			prevScaleX=1;
			playerClip.x=-20;
			playerClip.y=-15;

			if (speedX > 0) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}

		}

		private function handleCrawlLeft():void {
			if (!(playerClip is PlayerCrawlAnimation)) {
				removeChild(playerClip);
				playerClip=new PlayerCrawlAnimation();
				playerClip.stop();
				addChild(playerClip);
				playerClip.gotoAndStop(0);
			}
			// Use scaleX = -1 to flip the direction of movement

			playerClip.scaleX=-1;
			prevScaleX=-1;
			//This value might need to be changed, I think it might be off a few pixels
			playerClip.x=45;
			playerClip.y=-15;

			if (speedX < 0) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}

		}

		private function handleWalkRight():void {
			if (!(playerClip is PlayerWalkingAnimation)) {
				removeChild(playerClip);
				playerClip=new PlayerWalkingAnimation();
				playerClip.stop();
				addChild(playerClip);
				playerClip.gotoAndStop(0);
			}

			//animate moving to the right
			playerClip.scaleX=1;
			prevScaleX=1;
			playerClip.x=-2;
			playerClip.y=-8;

			if (speedX > 0) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}


		}

		private function handleWalkLeft():void {
			if (!(playerClip is PlayerWalkingAnimation)) {
				removeChild(playerClip);
				playerClip=new PlayerWalkingAnimation();
				addChild(playerClip);
				playerClip.gotoAndStop(0);
			}
			// Use scaleX = -1 to flip the direction of movement
			playerClip.scaleX=-1;
			prevScaleX=-1;
			//This value might need to be changed, I think it might be off a few pixels
			playerClip.x=25;
			playerClip.y=-8;

			if (speedX < 0) {
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				else
					playerClip.gotoAndStop(0);
			}
		}

		private function handleJumping():void {
			if ( this.prevSpeedY - this.newY < 0 ){
				frameJumpCounter == 6;
			}
			else if ( this.prevSpeedY - this.newY > 0 ) {
				frameJumpCounter == 16;
			}

			if (frameCounter - frameJumpCounter <= 6) {
				if (!(playerClip is PlayerJumpUpAnimation)) {
					removeChild(playerClip);
					playerClip=new PlayerJumpUpAnimation();
					addChild(playerClip);
				}
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				// make sure the animation is facing the correct direction if the player changes it in mid air
				if (isFacingRight) {
					playerClip.scaleX=1;
					prevScaleX=1;
					playerClip.x=-2;
					playerClip.y=-8;
				} else {
					playerClip.scaleX=-1;
					prevScaleX=-1;
					//This value might need to be changed, I think it might be off a few pixels
					playerClip.x=25;
					playerClip.y=-8;
				}
			} else if (7 <= frameCounter - frameJumpCounter && frameCounter - frameJumpCounter <= 16) {
				if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
					removeChild(playerClip);
					playerClip=new PlayerJumpPeakThenFallAnimation();
					addChild(playerClip);
				}
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				// make sure the animation is facing the correct direction if the player changes it in mid air
				if (isFacingRight) {
					playerClip.scaleX=1;
					prevScaleX=1;
					playerClip.x=-2;
					playerClip.y=-8;
				} else {
					playerClip.scaleX=-1;
					prevScaleX=-1;
					//This value might need to be changed, I think it might be off a few pixels
					playerClip.x=25;
					playerClip.y=-8;
				}
			} else if (frameCounter - frameJumpCounter < 17) {
				if (!(playerClip is PlayerJumpLandAnimation)) {
					removeChild(playerClip);
					playerClip=new PlayerJumpLandAnimation();
					addChild(playerClip);
				}
				if (playerClip.currentFrame != playerClip.totalFrames)
					playerClip.nextFrame();
				// make sure the animation is facing the correct direction if the player changes it in mid air
				if (isFacingRight) {
					playerClip.scaleX=1;
					prevScaleX=1;
					playerClip.x=-2;
					playerClip.y=-8;
				} else {
					playerClip.scaleX=-1;
					prevScaleX=-1;
					//This value might need to be changed, I think it might be off a few pixels
					playerClip.x=25;
					playerClip.y=-8;
				}
			} else {
				isJumping=false;
			}
		}

		private function handleDeathAnimation():void {
			// TODO Auto Generated method stub

		}


		private function handleFalling():void {
			trace("Made it inside falling");
			if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
				removeChild(playerClip);
				playerClip=new PlayerJumpPeakThenFallAnimation();
				addChild(playerClip);
				playerClip.gotoAndStop(15)
			}


//			if (playerClip.currentFrame != playerClip.totalFrames)
//				playerClip.nextFrame();


			// make sure the animation is facing the correct direction if the player changes it in mid air
			if (isFacingRight) {
				playerClip.scaleX=1;
				prevScaleX=1;
				playerClip.x=-2;
				playerClip.y=-8;

			} else {
				playerClip.scaleX=-1;
				prevScaleX=-1;
				//This value might need to be changed, I think it might be off a few pixels
				playerClip.x=25;
				playerClip.y=-8;
			}

		}

		public function die():void {
			trace("YOU DEAD");
			isDead=true;
			handleDeathAnimation();
		}


	}
}


