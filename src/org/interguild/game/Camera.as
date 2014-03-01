package org.interguild.game
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;

	public class Camera extends Sprite
	{
		private var player:Player;
		
		private static const UPWARD_DISTANCE:uint = 150;
		private static const LEFT_DISTANCE:uint = 175;
		private static const RIGHT_DISTANCE:uint = 175;
		private static const DOWNWARD_DISTANCE:uint = 175;
		
		private static const TWEEN_SPEED:Number = 1;
		
		public function Camera(player:Player)
		{
			this.player = player;
		}
		
		
		public function updateCamera():void {
			
			// camera will scroll upwards
			if ( player.isFacingUp ) {
				TweenLite.to(this, TWEEN_SPEED , {x:-player.x + stage.stageWidth / 2.0, y:-player.y + stage.stageHeight / 2.0  + UPWARD_DISTANCE} );
			}
			// camera will be to the right of the player for view
			else if ( player.isFacingRight ) {
				TweenLite.to(this, TWEEN_SPEED , {x:-player.x + stage.stageWidth / 2.0 - RIGHT_DISTANCE, y:-player.y + stage.stageHeight / 2.0 } );
			}
			// camera will be to the right of the player for view
			else if ( player.isFacingLeft ) {
				TweenLite.to(this, TWEEN_SPEED , {x:-player.x + stage.stageWidth / 2.0 + LEFT_DISTANCE, y:-player.y + stage.stageHeight / 2.0} );
			}
			// camera will scroll downwards
			else if ( player.isCrouching ) {
				TweenLite.to(this, TWEEN_SPEED , {x:-player.x + stage.stageWidth / 2.0, y:-player.y + stage.stageHeight / 2.0 - DOWNWARD_DISTANCE} );
			}
			// recenter the camera
			else { 
				TweenLite.to(this, TWEEN_SPEED , {x:-player.x + stage.stageWidth / 2.0, y:-player.y + stage.stageHeight / 2.0 } );
			}
			
		}
	}
} 