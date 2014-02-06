package org.interguild {
	import flash.display.Sprite;

	public class Player extends Sprite {
		
		private static const HITBOX_WIDTH:uint = 24;
		private static const HITBOX_HEIGHT:uint = 48;
		
		private static const SPRITE_COLOR:uint = 0xFF0000;
		private static const SPRITE_WIDTH:uint = 24;
		private static const SPRITE_HEIGHT:uint = 48;
		
		public function Player() {
			drawPlayer();
		}
		
		private function drawPlayer():void{
			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();
		}
	}
}
