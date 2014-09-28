package org.interguild.game {
//	import com.greensock.TweenLite;
//	import com.greensock.easing.Back;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.interguild.Aeon;
	import org.interguild.game.tiles.Arrow;
	import org.interguild.game.tiles.ArrowExplosion;
	import org.interguild.game.tiles.DynamiteStick;
	import org.interguild.game.tiles.Explosion;
	import org.interguild.game.tiles.Player;
	import org.interguild.game.tiles.TerrainView;

	/**
	 * This class controls the camera for the game. It uses a tween object to scroll the camera to the players position, off
	 * set so the player can see where they are traveling. It is called on every iteration of the game loop to move the camera.
	 * It takes the player as a reference so it can update it's location based on the players coordinates.
	 */
	public class Camera extends Sprite {
		private static const UPWARD_DISTANCE:uint = 125;
		private static const LEFT_DISTANCE:uint = 0;
		private static const RIGHT_DISTANCE:uint = 0;
		private static const DOWNWARD_DISTANCE:uint = 125;

		private static const TWEEN_SPEED:Number = 1.75;
		private static const RESET_TWEEN_SPEED:Number = 1.0;
		private static const LOOK_TWEEN_SPEED:Number = 1.25;

		private var levelWidth:int;
		private var levelHeight:int;

		private var player:Player;
		private var bg:LevelBackground;
		
		private var effectsLayer:Sprite;
		private var projectileLayer:Sprite;
		private var terrainLayer:Sprite;
		private var playerLayer:Sprite;
		private var tilesLayer:Sprite;

		public function Camera(player:Player, bg:LevelBackground, w:Number, h:Number) {
			this.player = player;
			this.bg = bg;
			this.levelWidth = w;
			this.levelHeight = h;
//			TweenLite.defaultEase = Back.easeOut;
			
			tilesLayer = new Sprite();
			super.addChild(tilesLayer);
			playerLayer = new Sprite();
			super.addChild(playerLayer);
			terrainLayer = new Sprite();
			super.addChild(terrainLayer);
			projectileLayer = new Sprite();
			super.addChild(projectileLayer);
			effectsLayer = new Sprite();
			super.addChild(effectsLayer);
		}
//
//		/**
//		 * Main method that updates the camera based on what the player is doing. It recognizes, looking up, down and travelling
//		 * to left or right. The camera will not go outside the bounds of the level. It will not allow the player to look up if doing so
//		 * would put the camera outside the bounds of the level.
//		 */
//		public function updateCamera():void {
//			var cameraX:int = -player.x + Aeon.STAGE_WIDTH / 2.0 - player.width;
//			var cameraY:int = -player.y + Aeon.STAGE_HEIGHT / 2.0 - player.height;
//
//			// player has reached the right most side of the level
//			if (player.x > levelWidth - Aeon.STAGE_WIDTH / 2) {
//				cameraX = -levelWidth + Aeon.STAGE_WIDTH;
//			}
//			// player has reached the bottom most part of the level
//			if (player.y > levelHeight - Aeon.STAGE_HEIGHT / 2) {
//				cameraY = -levelHeight + Aeon.STAGE_HEIGHT;
//			}
//			// player has reached the left most side of the level
//			if (player.x < 0 + Aeon.STAGE_WIDTH / 2) {
//				cameraX = 0;
//			}
//			// player has reached the top most part of the level
//			if (player.y < 0 + Aeon.STAGE_HEIGHT / 2) {
//				cameraY = 0;
//			}
//
////			// camera will scroll upwards, only if player is standing on ground
////			if (player.isFacingUp && player.isStanding && player.y >= 0 + Aeon.STAGE_WIDTH / 2 + UPWARD_DISTANCE) {
////				TweenLite.to(this, LOOK_TWEEN_SPEED, {x: cameraX, y: cameraY + UPWARD_DISTANCE});
////			}
////			// camera will be to the right of the player for view
////			else if (player.isFacingRight && player.isStanding) {
////				TweenLite.to(this, TWEEN_SPEED, {x: cameraX - RIGHT_DISTANCE, y: cameraY});
////			}
////			// camera will be to the right of the player for view
////			else if (!player.isFacingRight && player.isStanding) {
////				TweenLite.to(this, TWEEN_SPEED, {x: cameraX + LEFT_DISTANCE, y: cameraY});
////			}
////			// camera will scroll downwards
////			else if (player.isCrouching && player.isStanding && player.y <= levelHeight - Aeon.STAGE_WIDTH / 2 - DOWNWARD_DISTANCE) {
////				TweenLite.to(this, LOOK_TWEEN_SPEED, {x: cameraX, y: cameraY - DOWNWARD_DISTANCE});
////			}
//			// recenter the camera
//			else {
//				TweenLite.to(this, RESET_TWEEN_SPEED, {x: cameraX, y: cameraY});
//			}
//		}
		
		public function deconstruct():void{
			removeChildren();
			player = null;
		}

		public function updateCamera():void {
			var cameraX:int = -player.x - player.width / 2 + Aeon.STAGE_WIDTH / 2.0;
			var cameraY:int = -player.y - player.height / 2 + Aeon.STAGE_HEIGHT / 2.0;
			
			//stop camera from going too far
			if (cameraX + levelWidth < Aeon.STAGE_WIDTH) {
				cameraX = Aeon.STAGE_WIDTH - levelWidth;
			}
			if ( cameraY + levelHeight < Aeon.STAGE_HEIGHT ) {
				cameraY = Aeon.STAGE_HEIGHT - levelHeight;
			}
			if (cameraX > 0) {
				cameraX = 0;
			}
			if (cameraY > 0) {
				cameraY = 0;
			}
			
			bg.x += (cameraX - x) / 2;
			x = cameraX;
			y = cameraY;
		}

		public override function set x(n:Number):void {
			super.x = n;
			bg.x += (n - bg.x) / 4;
		}
		
		/**
		 * Order from top to bottom:
		 * 
		 * Effects (explosions)
		 * Projectiles (arrows and tnt)
		 * TerrainView
		 * Player
		 * Tiles
		 * Background (not a child of camera)
		 */
		public override function addChild(child:DisplayObject):DisplayObject{
			if(child is Explosion || child is ArrowExplosion)
				return effectsLayer.addChild(child);
			if(child is Arrow || child is DynamiteStick)
				return projectileLayer.addChild(child);
			if(child is TerrainView)
				return terrainLayer.addChild(child);
			if(child is Player)
				return playerLayer.addChild(child);
			return tilesLayer.addChild(child);
		}
		
		public override function removeChild(child:DisplayObject):DisplayObject{
			if(child is Explosion || child is ArrowExplosion)
				return effectsLayer.removeChild(child);
			if(child is Arrow || child is DynamiteStick)
				return projectileLayer.removeChild(child);
			if(child is TerrainView)
				return terrainLayer.removeChild(child);
			if(child is Player)
				return playerLayer.removeChild(child);
			return tilesLayer.removeChild(child);
		}
	}
}
