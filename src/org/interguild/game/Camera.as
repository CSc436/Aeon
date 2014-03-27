package org.interguild.game {
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;

	import flash.display.Sprite;

	/**
	 * This class controls the camera for the game. It uses a tween object to scroll the camera to the players position, off
	 * set so the player can see where they are traveling. It is called on every iteration of the game loop to move the camera.
	 * It takes the player as a reference so it can update it's location based on the players coordinates.
	 */
	public class Camera extends Sprite {
		private var player:Player;

		private static const UPWARD_DISTANCE:uint = 150;
		private static const LEFT_DISTANCE:uint = 0;
		private static const RIGHT_DISTANCE:uint = 0;
		private static const DOWNWARD_DISTANCE:uint = 150;

		private var levelXSize:int;
		private var levelYSize:int;

		private static const TWEEN_SPEED:Number = 1.75;

		public function Camera(player:Player) {
			this.player = player;
			//TweenLite.defaultEase = Back.easeOut;
		}

		/**
		 * Main method that updates the camera based on what the player is doing. It recognizes, looking up, down and travelling
		 * to left or right. Currently if none of previously listed actions are happening the camera will reset.
		 */
		public function updateCamera():void {
			var cameraX:int = -player.x + stage.stageWidth / 2.0 - player.width;
			var cameraY:int = -player.y + stage.stageHeight / 2.0 - player.height;
			
	
			// camera will scroll upwards, only if player is standing on ground
			if (player.isFacingUp && player.isStanding) {
				TweenLite.to(this, TWEEN_SPEED, {x: cameraX, y: cameraY + UPWARD_DISTANCE});
			}
			// camera will be to the right of the player for view
			else if (player.isFacingRight) {
				TweenLite.to(this, TWEEN_SPEED, {x: cameraX - RIGHT_DISTANCE, y: cameraY});
			}
			// camera will be to the right of the player for view
			else if (player.isFacingLeft) {
				TweenLite.to(this, TWEEN_SPEED, {x: cameraX + LEFT_DISTANCE, y: cameraY});
			}
			// camera will scroll downwards
			else if (player.isCrouching && player.isStanding) {
				TweenLite.to(this, TWEEN_SPEED, {x: cameraX, y: cameraY - DOWNWARD_DISTANCE});
			}
			// recenter the camera
			else {
				//TweenLite.to(this, 2, {x: -player.x + stage.stageWidth / 2.0, y: -player.y + stage.stageHeight / 2.0});
			}



		}

		/**
		 * Setter method, needed to get size of x for the level
		 */
		public function setLevelX(levelXSize:int):void {
			this.levelXSize = levelXSize;
		}

		/**
		 * Setter method, needed to get size of y for the level
		 */
		public function setLevelY(levelYSize:int):void {
			this.levelYSize = levelYSize;
		}
	}


}
