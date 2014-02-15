package org.interguild.game {
	import flash.display.Sprite;

	public class Player extends Sprite {

		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 48;

		private static const SPRITE_COLOR:uint = 0xFF0000;
		private static const SPRITE_WIDTH:uint = 24;
		private static const SPRITE_HEIGHT:uint = 48;

		private static const MAX_FALL_SPEED:Number = 7;
		private static const MAX_RUN_SPEED:Number = 3;

		private static const RUN_ACC:Number = MAX_RUN_SPEED;
		private static const RUN_FRICTION:Number = 2;

		private static const JUMP_SPEED:Number = -25

		private var newX:Number = 0;
		private var newY:Number = 0;

		private var speedX:Number = 0;
		private var speedY:Number = 0;

		private var maxSpeedY:Number = MAX_FALL_SPEED;
		private var maxSpeedX:Number = MAX_RUN_SPEED;

		private var keys:KeyMan;
		private var isStanding:Boolean;


		public function Player() {
			drawPlayer();

			keys = KeyMan.getMe();
		}

		public function setStartPosition(sx:Number, sy:Number):void {
			x = newX = sx;
			y = newY = sy;
		}

		private function drawPlayer():void {
			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();
		}

		public function onGameLoop():void {

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

			//stop falling off screen
			if (newY + SPRITE_HEIGHT > 350) {
				newY = 350 - SPRITE_HEIGHT;
				isStanding = true;
			}

			//commit location change:
			x = newX;
			y = newY;


		}

		private function reset():void {
			isStanding = false;
		}

		private function updateKeys():void {
			//moving to the left
			if (keys.isKeyLeft) {
				speedX -= RUN_ACC;
			} else if (speedX < 0) {
				speedX += RUN_FRICTION;
				if (speedX > 0)
					speedX = 0;
			}
			//moving to the right
			if (keys.isKeyRight) {
				speedX += RUN_ACC;
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