package org.interguild.game {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	import org.interguild.KeyMan;
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.level.Level;
	import org.interguild.game.tiles.CollidableObject;

	public class Player extends CollidableObject {
		CONFIG::DEBUG {
			private static const SPRITE_COLOR:uint = 0xFF0000;
		}

		public static const LEVEL_CODE_CHAR:String = '#';
		public static const EDITOR_ICON:BitmapData = new StartingPositionSprite();
		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;

		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 40;

		private static const CRAWLING_HEIGHT:uint = 32;
		private static const STANDING_HEIGHT:uint = HITBOX_HEIGHT;

		private static const MAX_FALL_SPEED:Number = 14;
		private static const MAX_RUN_SPEED:Number = 6;

		private static const RUN_ACC:Number = MAX_RUN_SPEED;
		private static const RUN_FRICTION:Number = 2;

		private static const JUMP_SPEED:Number = -20;

		public static const KNOCKBACK_JUMP_SPEED:Number = -14;
		public static const KNOCKBACK_HORIZONTAL:Number = 20;

		//ANIMATIONS

		private static const WALKING_ANIMATION:MovieClip = new PlayerWalkingAnimation();
		private static const WALKING_ANIMATION_X:int = -2;
		private static const WALKING_ANIMATION_Y:int = -8;

		private static const CRAWLING_ANIMATION:MovieClip = new PlayerCrawlAnimation();
		private static const CRAWLING_ANIMATION_X:int = -2;
		private static const CRAWLING_ANIMATION_Y:int = -8;

		private static const JUMP_UP_ANIMATION:MovieClip = new PlayerJumpUpAnimation();
		private static const JUMP_UP_ANIMATION_X:int = -2;
		private static const JUMP_UP_ANIMATION_Y:int = -8;

		private static const JUMP_PEAK_FALL_ANIMATION:MovieClip = new PlayerJumpPeakThenFallAnimation();
		private static const JUMP_PEAK_FALL_ANIMATION_X:int = -2;
		private static const JUMP_PEAK_FALL_ANIMATION_Y:int = -8;
		private static const PEAK_SPEED_THRESHOLD:Number = 6;
		private static const JUMP_PEAK_FRAME:uint = 6;

		private static const JUMP_LAND_ANIMATION:MovieClip = new PlayerJumpPeakThenFallAnimation();
		private static const JUMP_LAND_ANIMATION_X:int = -2;
		private static const JUMP_LAND_ANIMATION_Y:int = -8;

		private static const DEATH_SPRITE:Bitmap = new Bitmap(new PlayerDeathSprite());
		private static const DEATH_SPRITE_X:int = -2;
		private static const DEATH_SPRITE_Y:int = -8;

		//SET VARIABLES

		private var keys:KeyMan;

		private var currentAnimation:MovieClip;
		private var deathSprite:Bitmap;
		private var isRunning:Boolean;
		private var isJumping:Boolean;

		private var isOnGround:Boolean;
		private var isCrawling:Boolean;
		private var currentFrame:uint = 1;

		//TODO: refactor, should not be public
		public var isDead:Boolean;
		public var isFacingRight:Boolean;
		public var pressedJump:Boolean;

		//TO REFACTOR VARIABLES

//		public var frameCounter:int = 0;
//		public var frameJumpCounter:int;
//
//		
//
//		public var isFacingUp:Boolean;
//		public var mustCrawl:Boolean = false;
//
//		private var playerClip:MovieClip;
//		private var prevSpeedY:Number = 0;
//		private var prevScaleX:Number = 1;

		public function Player() {
			super(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyedBy(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.EXPLOSIONS);
			destruction.destroyedBy(Destruction.FALLING_SOLID_OBJECTS);
			destruction.destroyWithMarker(Destruction.PLAYER);

			initAnimations();

			keys = KeyMan.getMe();
			isFacingRight = true;
			isActive = true;
			isDead = false;
		}

		private function initAnimations():void {
			currentAnimation = WALKING_ANIMATION;
			WALKING_ANIMATION.x = WALKING_ANIMATION_X
			WALKING_ANIMATION.y = WALKING_ANIMATION_Y
			WALKING_ANIMATION.visible = true;
			addChild(WALKING_ANIMATION);

			CRAWLING_ANIMATION.x = CRAWLING_ANIMATION_X
			CRAWLING_ANIMATION.y = CRAWLING_ANIMATION_Y
			CRAWLING_ANIMATION.visible = false;
			addChild(CRAWLING_ANIMATION);

			JUMP_UP_ANIMATION.x = JUMP_UP_ANIMATION_X
			JUMP_UP_ANIMATION.y = JUMP_UP_ANIMATION_Y
			JUMP_UP_ANIMATION.visible = false;
			addChild(JUMP_UP_ANIMATION);

			JUMP_PEAK_FALL_ANIMATION.x = JUMP_PEAK_FALL_ANIMATION_X
			JUMP_PEAK_FALL_ANIMATION.y = JUMP_PEAK_FALL_ANIMATION_Y
			JUMP_PEAK_FALL_ANIMATION.visible = false;
			addChild(JUMP_PEAK_FALL_ANIMATION);

			JUMP_LAND_ANIMATION.x = JUMP_LAND_ANIMATION_X
			JUMP_LAND_ANIMATION.y = JUMP_LAND_ANIMATION_Y
			JUMP_LAND_ANIMATION.visible = false;
			addChild(JUMP_LAND_ANIMATION);

			DEATH_SPRITE.x = DEATH_SPRITE_X;
			DEATH_SPRITE.y = DEATH_SPRITE_Y;
			DEATH_SPRITE.visible = false;
			addChild(DEATH_SPRITE);

			//draw hit box
			CONFIG::DEBUG {
				graphics.beginFill(SPRITE_COLOR);
				graphics.drawRect(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT);
				graphics.endFill();
			}
		}

		public function setStartPosition(sx:Number, sy:Number):void {
			x = newX = startX = sx;
			y = newY = startY = sy - hitbox.height + 32;
			updateHitBox();
			finishGameLoop();
		}

		public function landedOnGround():void {
			isOnGround = true;
		}

		public override function onGameLoop():void {
			if (isDead)
				return;

			updateKeys();
			updateGravity();
			updateMaxSpeeds();

			isOnGround = false;
			newX += speedX;
			newY += speedY;
			updateHitBox();
		}

		private function updateKeys():void {
			//moving to the left
			if (keys.isKeyLeft && !keys.isKeyRight) {
				speedX -= RUN_ACC;
				isFacingRight = false;
				isRunning = true;
			} else if (speedX < 0) {
				speedX += RUN_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight && !keys.isKeyLeft) {
				speedX += RUN_ACC;
				isFacingRight = true;
				isRunning = true;
			} else if (speedX > 0) {
				speedX -= RUN_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}

			//jump
			if (keys.isKeySpace && isOnGround && !pressedJump) {
				speedY = JUMP_SPEED;
				pressedJump = true;
			}
			if (pressedJump && !keys.isKeySpace) {
				pressedJump = false;
			}
		}

		private function updateGravity():void {
			speedY += Level.GRAVITY;
		}

		private function updateMaxSpeeds():void {
			if (speedY > MAX_FALL_SPEED) {
				speedY = MAX_FALL_SPEED;
			}
			if (speedX > MAX_RUN_SPEED) {
				speedX = MAX_RUN_SPEED;
			} else if (speedX < -MAX_RUN_SPEED) {
				speedX = -MAX_RUN_SPEED;
			}
		}

		public override function finishGameLoop():void {
			super.finishGameLoop();
			updateAnimation();
			isRunning = false;
		}

		public function updateAnimation():void {
			if (isDead) {
				//handle death animation
			} else if (isRunning && isOnGround && !isCrawling) {
				animateWalking();
			} else if (isOnGround) {
				animateStanding();
			} else {
				animateJumpAndFall();
			}

//			if (isDead) {
//				handleDeathAnimation();
//				return;
//			}
//
//			var neighborTiles:Vector.<GridTile> = this.myCollisionGridTiles;
////			trace("Number of neighboring tiles: " + neighborTiles.length);
//			mustCrawl = false;
//			var above1:CollidableObject = CollidableObject(neighborTiles[1].myCollisionObjects[0]);
//			var above2:CollidableObject = CollidableObject(neighborTiles[2].myCollisionObjects[0]);
//			if (neighborTiles.length == 12 && !isJumping && isStanding) {
//				if (above1.isSolid() && !this.canDestroy(above1))
//					mustCrawl = true;
//			} else if (neighborTiles.length == 16 && !isJumping && isStanding) {
//				if ((above1.isSolid() && !this.canDestroy(above1)) || (above2.isSolid() && !this.canDestroy(above2)))
//					mustCrawl = true;
//			}
//			mustCrawl = false; // debugging
////			trace("Must crawl value: " + mustCrawl);
//
//			if (isJumping && !mustCrawl) {
//				handleJumping();
//			} else if (isFalling && !mustCrawl && !isCrouching) {
//				handleFalling();
//			} else if (keys.isKeyDown && isFacingRight && isStanding) {
//				handleCrawlRight();
//			} else if (keys.isKeyDown && !isFacingRight && isStanding) {
//				handleCrawlLeft();
//			} else if (mustCrawl && isFacingRight) {
//				handleCrawlRight();
//			} else if (mustCrawl && !isFacingRight) {
//				handleCrawlLeft();
//			} else if (keys.isKeyRight && !keys.isKeyDown) {
//				handleWalkRight();
//			} else if (keys.isKeyLeft && !keys.isKeyDown) {
//				handleWalkLeft();
//			}
//			// reset the animation to walking left
//			else if (!keys.isKeyDown && !isFacingRight && !keys.isKeyUp && !keys.isKeyRight && !keys.isKeyLeft) {
//				handleWalkLeft();
//					// reset the animation to walking right
//			} else if (!keys.isKeyDown && isFacingRight && !keys.isKeyUp && !keys.isKeyRight && !keys.isKeyLeft) {
//				handleWalkRight();
//			}
		}

		/**
		 * Switch animation
		 */
		private function switchTo(animation:MovieClip):void {
			if (currentAnimation != animation) {
				currentAnimation.visible = false;
				currentAnimation = animation;
				currentAnimation.visible = true;
				currentFrame = 1;
			}
		}

		private function incrementFrameWithLoop():void {
			currentFrame++;
			if (currentFrame >= currentAnimation.totalFrames) {
				currentFrame = 1;
			}
		}

		private function incrementFrameNoLoop():void {
			if (currentFrame < currentAnimation.totalFrames) {
				currentFrame++;
			}
		}

		private function animateStanding():void {
			switchTo(WALKING_ANIMATION);
			currentFrame = 1;
			currentAnimation.gotoAndStop(currentFrame);
		}

		private function animateWalking():void {
			switchTo(WALKING_ANIMATION);
			currentAnimation.gotoAndStop(currentFrame);
			incrementFrameWithLoop();
		}

		private function animateJumpAndFall():void {
			if (speedY < -PEAK_SPEED_THRESHOLD) {
				switchTo(JUMP_UP_ANIMATION);
				currentAnimation.gotoAndStop(currentFrame);
				incrementFrameNoLoop();
			} else if(speedY > 0 && (currentAnimation != JUMP_PEAK_FALL_ANIMATION || currentFrame < JUMP_PEAK_FRAME)){
				switchTo(JUMP_PEAK_FALL_ANIMATION);
				currentFrame = JUMP_PEAK_FRAME;
				currentAnimation.gotoAndStop(currentFrame);
				incrementFrameNoLoop();
			}else{
				switchTo(JUMP_PEAK_FALL_ANIMATION);
				currentAnimation.gotoAndStop(currentFrame);
				incrementFrameNoLoop();
			}
		}

//		private function handleCrawlRight():void {
//			if (!(playerClip is PlayerCrawlAnimation)) {
//				removeChild(playerClip);
//				playerClip = new PlayerCrawlAnimation();
//				playerClip.stop();
//				addChild(playerClip);
//				playerClip.gotoAndStop(0);
//			}
//			//animate moving to the right
//			playerClip.scaleX = 1;
//			prevScaleX = 1;
//			playerClip.x = -20;
//			playerClip.y = -15;
//
//			if (speedX > 0) {
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				else
//					playerClip.gotoAndStop(0);
//			}
//
//		}
//
//		private function handleCrawlLeft():void {
//			if (!(playerClip is PlayerCrawlAnimation)) {
//				removeChild(playerClip);
//				playerClip = new PlayerCrawlAnimation();
//				playerClip.stop();
//				addChild(playerClip);
//				playerClip.gotoAndStop(0);
//			}
//			// Use scaleX = -1 to flip the direction of movement
//
//			playerClip.scaleX = -1;
//			prevScaleX = -1;
//			//This value might need to be changed, I think it might be off a few pixels
//			playerClip.x = 45;
//			playerClip.y = -15;
//
//			if (speedX < 0) {
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				else
//					playerClip.gotoAndStop(0);
//			}
//
//		}
//
//		private function handleWalkRight():void {
//			if (!(playerClip is PlayerWalkingAnimation)) {
//				removeChild(playerClip);
//				playerClip = new PlayerWalkingAnimation();
//				playerClip.stop();
//				addChild(playerClip);
//				playerClip.gotoAndStop(0);
//			}
//
//			//animate moving to the right
//			playerClip.scaleX = 1;
//			prevScaleX = 1;
//			playerClip.x = -2;
//			playerClip.y = -8;
//
//			if (speedX > 0) {
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				else
//					playerClip.gotoAndStop(0);
//			}
//
//
//		}
//
//		private function handleWalkLeft():void {
//			if (!(playerClip is PlayerWalkingAnimation)) {
//				removeChild(playerClip);
//				playerClip = new PlayerWalkingAnimation();
//				addChild(playerClip);
//				playerClip.gotoAndStop(0);
//			}
//			// Use scaleX = -1 to flip the direction of movement
//			playerClip.scaleX = -1;
//			prevScaleX = -1;
//			//This value might need to be changed, I think it might be off a few pixels
//			playerClip.x = 25;
//			playerClip.y = -8;
//
//			if (speedX < 0) {
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				else
//					playerClip.gotoAndStop(0);
//			}
//		}
//
//		private function handleJumping():void {
//			if (this.prevSpeedY - this.newY < 0) {
//				frameJumpCounter == 6;
//			} else if (this.prevSpeedY - this.newY > 0) {
//				frameJumpCounter == 16;
//			}
//
//			if (frameCounter - frameJumpCounter <= 6) {
//				if (!(playerClip is PlayerJumpUpAnimation)) {
//					removeChild(playerClip);
//					playerClip = new PlayerJumpUpAnimation();
//					addChild(playerClip);
//				}
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				// make sure the animation is facing the correct direction if the player changes it in mid air
//				if (isFacingRight) {
//					playerClip.scaleX = 1;
//					prevScaleX = 1;
//					playerClip.x = -2;
//					playerClip.y = -8;
//				} else {
//					playerClip.scaleX = -1;
//					prevScaleX = -1;
//					//This value might need to be changed, I think it might be off a few pixels
//					playerClip.x = 25;
//					playerClip.y = -8;
//				}
//			} else if (7 <= frameCounter - frameJumpCounter && frameCounter - frameJumpCounter <= 16) {
//				if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
//					removeChild(playerClip);
//					playerClip = new PlayerJumpPeakThenFallAnimation();
//					addChild(playerClip);
//				}
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				// make sure the animation is facing the correct direction if the player changes it in mid air
//				if (isFacingRight) {
//					playerClip.scaleX = 1;
//					prevScaleX = 1;
//					playerClip.x = -2;
//					playerClip.y = -8;
//				} else {
//					playerClip.scaleX = -1;
//					prevScaleX = -1;
//					//This value might need to be changed, I think it might be off a few pixels
//					playerClip.x = 25;
//					playerClip.y = -8;
//				}
//			} else if (frameCounter - frameJumpCounter < 17) {
//				if (!(playerClip is PlayerJumpLandAnimation)) {
//					removeChild(playerClip);
//					playerClip = new PlayerJumpLandAnimation();
//					addChild(playerClip);
//				}
//				if (playerClip.currentFrame != playerClip.totalFrames)
//					playerClip.nextFrame();
//				// make sure the animation is facing the correct direction if the player changes it in mid air
//				if (isFacingRight) {
//					playerClip.scaleX = 1;
//					prevScaleX = 1;
//					playerClip.x = -2;
//					playerClip.y = -8;
//				} else {
//					playerClip.scaleX = -1;
//					prevScaleX = -1;
//					//This value might need to be changed, I think it might be off a few pixels
//					playerClip.x = 25;
//					playerClip.y = -8;
//				}
//			} else {
//				isJumping = false;
//			}
//		}
//
//		private function handleDeathAnimation():void {
//
//			var directionChange:int = Math.random() * 10;
//
//			if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
//				removeChild(playerClip);
//				playerClip = new PlayerJumpPeakThenFallAnimation();
//				playerClip.stop();
//				addChild(playerClip);
//				playerClip.gotoAndStop(3);
//			}
//
//			if (parent)
//				parent.addChild(this);
//			playerClip.rotation += 18;
//			playerClip.x += directionChange;
//			playerClip.y -= directionChange;
//
//		}
//
//
//		private function handleFalling():void {
//			if (!(playerClip is PlayerJumpPeakThenFallAnimation)) {
//				removeChild(playerClip);
//				playerClip = new PlayerJumpPeakThenFallAnimation();
//				addChild(playerClip);
//				playerClip.gotoAndStop(15)
//			}
//
//
////			if (playerClip.currentFrame != playerClip.totalFrames)
////				playerClip.nextFrame();
//
//
//			// make sure the animation is facing the correct direction if the player changes it in mid air
//			if (isFacingRight) {
//				playerClip.scaleX = 1;
//				prevScaleX = 1;
//				playerClip.x = -2;
//				playerClip.y = -8;
//
//			} else {
//				playerClip.scaleX = -1;
//				prevScaleX = -1;
//				//This value might need to be changed, I think it might be off a few pixels
//				playerClip.x = 25;
//				playerClip.y = -8;
//			}
//
//		}

		public override function onKillEvent(level:Level):void {
			trace("YOU DEAD");
			isDead = true;
		}
	}
}


