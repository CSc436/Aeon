package org.interguild.game {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.KeyMan;
	import org.interguild.SoundMan;
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.tiles.CollidableObject;

	public class Player extends CollidableObject {
		CONFIG::DEBUG {
			private static const SPRITE_COLOR:uint = 0xFF0000;
			private static const ANIMATION_ALPHA:Number = 0.5;
		}

		public static const LEVEL_CODE_CHAR:String = '#';
		public static const EDITOR_ICON:BitmapData = Assets.PLAYER_EDITOR_SPRITE;
		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = true;
		private static const DEATH_DELAY:uint = 40;

		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 40;
		private static const CRAWLING_HEIGHT:uint = 28;
		private static const STANDING_HEIGHT:uint = HITBOX_HEIGHT;

		private static const MAX_FALL_SPEED:Number = 14;
		private static const MAX_RUN_SPEED:Number = 6;
		private static const MAX_CRAWL_SPEED:Number = 3;
		private static const RUN_ACC:Number = MAX_RUN_SPEED;
		private static const GROUND_FRICTION:Number = MAX_RUN_SPEED;
		private static const AIR_FRICTION:Number = 1;
		private static const JUMP_SPEED:Number = -21.5;

		public static const KNOCKBACK_JUMP_SPEED:Number = -14;
		public static const KNOCKBACK_HORIZONTAL:Number = 20;

		//ANIMATIONS

		private static const WALKING_ANIMATION:MovieClip = new PlayerWalkingAnimation();
		private static const WALKING_ANIMATION_X_RIGHT:int = -2;
		private static const WALKING_ANIMATION_X_LEFT:int = 26;
		private static const WALKING_ANIMATION_Y:int = -8;

		private static const CRAWLING_ANIMATION:MovieClip = new PlayerCrawlAnimation();
		private static const CRAWLING_ANIMATION_X_RIGHT:int = -18;
		private static const CRAWLING_ANIMATION_X_LEFT:int = 42;
		private static const CRAWLING_ANIMATION_Y:int = -20;

		private static const JUMP_UP_ANIMATION:MovieClip = new PlayerJumpUpAnimation();
		private static const JUMP_UP_ANIMATION_X_RIGHT:int = -8;
		private static const JUMP_UP_ANIMATION_X_LEFT:int = 32;
		private static const JUMP_UP_ANIMATION_Y:int = -13;

		private static const JUMP_PEAK_FALL_ANIMATION:MovieClip = new PlayerJumpPeakThenFallAnimation();
		private static const JUMP_PEAK_FALL_ANIMATION_X_RIGHT:int = -8;
		private static const JUMP_PEAK_FALL_ANIMATION_X_LEFT:int = 32;
		private static const JUMP_PEAK_FALL_ANIMATION_Y:int = -13;
		private static const PEAK_SPEED_THRESHOLD:Number = 6;
		private static const JUMP_PEAK_FRAME:uint = 6;

		private static const JUMP_LAND_ANIMATION:MovieClip = new PlayerJumpLandAnimation();
		private static const JUMP_LAND_ANIMATION_X_RIGHT:int = -8;
		private static const JUMP_LAND_ANIMATION_X_LEFT:int = 32;
		private static const JUMP_LAND_ANIMATION_Y:int = -13;

		private static const DEATH_SPRITE:Bitmap = new Bitmap(Assets.PLAYER_DEATH_SPRITE);
		private static const DEATH_ANIMATION_X_RIGHT:int = -8;
		private static const DEATH_ANIMATION_X_LEFT:int = 32;
		private static const DEATH_ANIMATION_Y:int = -13;
		private static const MIN_DEATH_SPEED:Number = 0.25;
		private static const MAX_ADDITIONAL_SPEED:Number = 1;
		private static const MIN_DEATH_ROTATION:Number = 4;
		private static const MAX_ADDITIONAL_ROTATION:Number = 4;

		private var keys:KeyMan;
		private var sounds:SoundMan;

		private var currentAnimation:MovieClip;
		private var currentAnimationIsFacingRight:Boolean;
		private var isRunning:Boolean;
		private var isJumping:Boolean;

		private var deathAnimation:MovieClip = new MovieClip();
		private var deathSpeedX:Number;
		private var deathSpeedY:Number;
		private var deathRotation:Number;

		private var isOnGround:Boolean;
		private var isCrawling:Boolean;
		private var currentFrame:uint = 1;

		//TODO: refactor, should not be public
		public var isDead:Boolean;
		public var isFacingRight:Boolean;
		public var pressedJump:Boolean;

		public function Player() {
			super(0, 0, HITBOX_WIDTH, HITBOX_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);
			destruction.destroyedBy(Destruction.ARROWS);
			destruction.destroyedBy(Destruction.EXPLOSIONS);
			destruction.destroyedBy(Destruction.FALLING_SOLID_OBJECTS);
			destruction.destroyWithMarker(Destruction.PLAYER);

			initAnimations();

			keys = KeyMan.getMe();
			sounds = SoundMan.getMe();
			isFacingRight = true;
			isActive = true;
			isDead = false;
		}

		private function initAnimations():void {
			currentAnimation = WALKING_ANIMATION;
			WALKING_ANIMATION.visible = true;
			addChild(WALKING_ANIMATION);

			CRAWLING_ANIMATION.visible = false;
			addChild(CRAWLING_ANIMATION);

			JUMP_UP_ANIMATION.visible = false;
			addChild(JUMP_UP_ANIMATION);

			JUMP_PEAK_FALL_ANIMATION.visible = false;
			addChild(JUMP_PEAK_FALL_ANIMATION);

			JUMP_LAND_ANIMATION.visible = false;
			addChild(JUMP_LAND_ANIMATION);

			deathAnimation.addChild(DEATH_SPRITE);
			DEATH_SPRITE.x = DEATH_ANIMATION_X_RIGHT;
			DEATH_SPRITE.y = DEATH_ANIMATION_Y;
			deathAnimation.visible = false;
			addChild(deathAnimation);

			//draw hit box
			CONFIG::DEBUG {
				showHitBox();
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

		public function get isStanding():Boolean {
			return isOnGround;
		}

		public override function onGameLoop():void {
			if (isDead) {
				updateDeath();
			} else {
				updateKeys();
				updateGravity();
				updateMaxSpeeds();

				isOnGround = false;
				newX += speedX;
				newY += speedY;
				updateHitBox();
			}
		}

		private var deathTimer:uint = 0;

		public var timeToRestart:Boolean = false;

		private function updateDeath():void {
			deathTimer++;
			if (deathTimer >= DEATH_DELAY) {
				timeToRestart = true;
			}
		}

		private function updateKeys():void {
			//moving to the left
			if (keys.isKeyLeft && !keys.isKeyRight) {
				speedX -= RUN_ACC;
				isFacingRight = false;
				isRunning = true;
			} else if (speedX < 0) {
				if (isOnGround)
					speedX += GROUND_FRICTION;
				else
					speedX += AIR_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight && !keys.isKeyLeft) {
				speedX += RUN_ACC;
				isFacingRight = true;
				isRunning = true;
			} else if (speedX > 0) {
				if (isOnGround)
					speedX -= GROUND_FRICTION;
				else
					speedX -= AIR_FRICTION;
				if (speedX < 0)
					speedX = 0;
			}

			//crawl
			if (keys.isKeyDown && !isCrawling && isOnGround) {
				//start crawling
				newY += (STANDING_HEIGHT - CRAWLING_HEIGHT);
				hitbox.height = CRAWLING_HEIGHT;
				isCrawling = true;
				CONFIG::DEBUG {
					showHitBox();
				}
			} else if (!keys.isKeyDown && isCrawling) {
				//stop crawling
				newY -= (STANDING_HEIGHT - CRAWLING_HEIGHT);
				hitbox.height = STANDING_HEIGHT;
				isCrawling = false;
				CONFIG::DEBUG {
					showHitBox();
				}
			}

			//jump
			if (keys.isKeySpace && isOnGround && !pressedJump) {
				speedY = JUMP_SPEED;
				pressedJump = true;
				sounds.playSound(SoundMan.JUMP_SOUND);
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

			var maxSpeed:Number;
			if (isCrawling)
				maxSpeed = MAX_CRAWL_SPEED;
			else
				maxSpeed = MAX_RUN_SPEED;
			if (speedX > maxSpeed) {
				speedX = maxSpeed;
			} else if (speedX < -maxSpeed) {
				speedX = -maxSpeed;
			}
		}

		public override function finishGameLoop():void {
			super.finishGameLoop();
			updateAnimation();
			isRunning = false;
		}

		public function updateAnimation():void {
			if (isDead) {
				animateDeath();
			} else if (isRunning && isOnGround) {
				if (isCrawling)
					animateCrawlWalking();
				else
					animateStandingWalking();
			} else if (isOnGround) {
				if (isCrawling)
					animateCrawlStill();
				else
					animateStandingStill();
			} else {
				animateJumpAndFall();
			}
		}

		/**
		 * Switch animation
		 */
		private function switchTo(animation:MovieClip):void {
			if (currentAnimation != animation || currentAnimationIsFacingRight != isFacingRight) {
				currentAnimation.visible = false;
				currentAnimation = animation;
				currentAnimationIsFacingRight = isFacingRight;
				if (isFacingRight) {
					positionAnimationRight();
				} else {
					positionAnimationLeft();
				}
				currentAnimation.visible = true;
				currentFrame = 1;

				CONFIG::DEBUG {
					currentAnimation.alpha = ANIMATION_ALPHA;
				}
			}
		}

		private function positionAnimationRight():void {
			currentAnimation.scaleX = 1;
			switch (currentAnimation) {
				case WALKING_ANIMATION:
					currentAnimation.x = WALKING_ANIMATION_X_RIGHT;
					currentAnimation.y = WALKING_ANIMATION_Y;
					break;
				case CRAWLING_ANIMATION:
					currentAnimation.x = CRAWLING_ANIMATION_X_RIGHT;
					currentAnimation.y = CRAWLING_ANIMATION_Y;
					break;
				case JUMP_UP_ANIMATION:
					currentAnimation.x = JUMP_UP_ANIMATION_X_RIGHT;
					currentAnimation.y = JUMP_UP_ANIMATION_Y;
					break;
				case JUMP_PEAK_FALL_ANIMATION:
					currentAnimation.x = JUMP_PEAK_FALL_ANIMATION_X_RIGHT;
					currentAnimation.y = JUMP_PEAK_FALL_ANIMATION_Y;
					break;
				case JUMP_LAND_ANIMATION:
					currentAnimation.x = JUMP_LAND_ANIMATION_X_RIGHT;
					currentAnimation.y = JUMP_LAND_ANIMATION_Y;
					break;
			}
		}

		private function positionAnimationLeft():void {
			currentAnimation.scaleX = -1;
			switch (currentAnimation) {
				case WALKING_ANIMATION:
					currentAnimation.x = WALKING_ANIMATION_X_LEFT;
					currentAnimation.y = WALKING_ANIMATION_Y;
					break;
				case CRAWLING_ANIMATION:
					currentAnimation.x = CRAWLING_ANIMATION_X_LEFT;
					currentAnimation.y = CRAWLING_ANIMATION_Y;
					break;
				case JUMP_UP_ANIMATION:
					currentAnimation.x = JUMP_UP_ANIMATION_X_LEFT;
					currentAnimation.y = JUMP_UP_ANIMATION_Y;
					break;
				case JUMP_PEAK_FALL_ANIMATION:
					currentAnimation.x = JUMP_PEAK_FALL_ANIMATION_X_LEFT;
					currentAnimation.y = JUMP_PEAK_FALL_ANIMATION_Y;
					break;
				case JUMP_LAND_ANIMATION:
					currentAnimation.x = JUMP_LAND_ANIMATION_X_LEFT;
					currentAnimation.y = JUMP_LAND_ANIMATION_Y;
					break;
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

		private function animateStandingStill():void {
			//jump land animation
			if (currentAnimation == JUMP_PEAK_FALL_ANIMATION || currentAnimation == JUMP_UP_ANIMATION || currentAnimation == JUMP_LAND_ANIMATION) {
				switchTo(JUMP_LAND_ANIMATION);
				if (currentFrame <= currentAnimation.totalFrames) {
					currentAnimation.gotoAndStop(currentFrame);
					currentFrame++;
					return;
				}
			}
			//standing still animation
			switchTo(WALKING_ANIMATION);
			currentFrame = 1;
			currentAnimation.gotoAndStop(currentFrame);
		}

		private function animateCrawlStill():void {
			switchTo(CRAWLING_ANIMATION);
			currentFrame = 1;
			currentAnimation.gotoAndStop(currentFrame);
		}

		private function animateStandingWalking():void {
			switchTo(WALKING_ANIMATION);
			currentAnimation.gotoAndStop(currentFrame);
			incrementFrameWithLoop();
		}

		private function animateCrawlWalking():void {
			switchTo(CRAWLING_ANIMATION);
			currentAnimation.gotoAndStop(currentFrame);
			incrementFrameWithLoop();
		}

		private function animateJumpAndFall():void {
			if (speedY < -PEAK_SPEED_THRESHOLD) {
				switchTo(JUMP_UP_ANIMATION);
				currentAnimation.gotoAndStop(currentFrame);
				incrementFrameNoLoop();
			} else if (speedY > 0 && (currentAnimation != JUMP_PEAK_FALL_ANIMATION || currentFrame < JUMP_PEAK_FRAME)) {
				switchTo(JUMP_PEAK_FALL_ANIMATION);
				currentFrame = JUMP_PEAK_FRAME;
				currentAnimation.gotoAndStop(currentFrame);
				incrementFrameNoLoop();
			} else {
				switchTo(JUMP_PEAK_FALL_ANIMATION);
				currentAnimation.gotoAndStop(currentFrame);
				incrementFrameNoLoop();
			}
		}

		private function animateDeath():void {
			if (!deathAnimation.visible) {
				currentAnimation.visible = false;
				deathAnimation.visible = true;
				if (isFacingRight) {
					deathAnimation.scaleX = 1;
				} else {
					deathAnimation.scaleX = -1;
				}
				CONFIG::DEBUG {
					deathAnimation.alpha = ANIMATION_ALPHA;
				}
			}
			deathAnimation.x += deathSpeedX;
			deathAnimation.y += deathSpeedY;
			deathAnimation.rotation += deathRotation;
		}

		public override function onKillEvent(level:Level):Array {
			trace("YOU DEAD");
			isDead = true;
			deathAnimation.x += hitbox.width / 2;
			deathAnimation.y += hitbox.height / 2;
			DEATH_SPRITE.x -= hitbox.width / 2;
			DEATH_SPRITE.y -= hitbox.height / 2;
			deathSpeedX = MAX_ADDITIONAL_SPEED * Math.random() + MIN_DEATH_SPEED;
			if (Math.random() > 0.5)
				deathSpeedX *= -1;
			deathSpeedY = MAX_ADDITIONAL_SPEED * Math.random() + MIN_DEATH_SPEED;
			if (Math.random() > 0.5)
				deathSpeedY *= -1;
			deathRotation = MAX_ADDITIONAL_ROTATION * Math.random() + MIN_DEATH_ROTATION;
			if (Math.random() > 0.5)
				deathRotation *= -1;
			return null;
		}
	}
}


