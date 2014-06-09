package org.interguild.game.tiles {
	import flash.display.BitmapData;
	
	import org.interguild.Assets;
	import org.interguild.game.collision.Destruction;
	import org.interguild.game.collision.Direction;

	public class Spike extends CollidableObject {
		
		public static const LEVEL_CODE_CHAR_FLOOR:String = 'M';
		public static const LEVEL_CODE_CHAR_CEILING:String = 'W';
		public static const LEVEL_CODE_CHAR_WALL_LEFT:String = 'K';
		public static const LEVEL_CODE_CHAR_WALL_RIGHT:String = 'E';
		public static const EDITOR_ICON_FLOOR:BitmapData = Assets.SPIKE_FLOOR;
		public static const EDITOR_ICON_CEILING:BitmapData = Assets.SPIKE_CEILING;
		public static const EDITOR_ICON_WALL_LEFT:BitmapData = Assets.SPIKE_WALL_LEFT;
		public static const EDITOR_ICON_WALL_RIGHT:BitmapData = Assets.SPIKE_WALL_RIGHT;
		
		private static const IS_NOT_SOLID:Boolean = false;
		private static const NO_GRAVITY:Boolean = false;
		
		private static const WIDTH:uint = 28;
		private static const HEIGHT:uint = 16;

		/**
		 * For the direction argument:
		 * 	 [] DOWN = ceiling spike (spikes pointing down)
		 * 	 [] UP = floor spike (spikes pointing up)
		 * 	 [] RIGHT = wall left spike (spikes pointing right)
		 *   [] LEFT = wall right spike (spikes pointing left)
		 */
		public function Spike(x:int, y:int, direction:uint) {
			var w:Number, h:Number;
			switch(direction){
				case Direction.DOWN:
					w = WIDTH;
					h = HEIGHT;
					x += (32 - w) / 2;
					break;
				case Direction.UP:
					w = WIDTH;
					h = HEIGHT;
					x += (32 - w) / 2;
					y += (32 - h);
					break;
				case Direction.RIGHT:
					h = WIDTH;
					w = HEIGHT;
					y += (32 - h) / 2;
					break;
				case Direction.LEFT:
					h = WIDTH;
					w = HEIGHT;
					y += (32 - h) / 2;
					x += (32 - w);
					break;
			}
			super(x, y, w, h);
			setProperties(IS_NOT_SOLID, NO_GRAVITY);
			destruction.destroyedBy(Destruction.EXPLOSIONS);
			destruction.destroyedBy(Destruction.LANDING_SOLID_OBJECT);
			destruction.destroyWithMarker(Destruction.SPIKES);
			
			CONFIG::DEBUG {
				showHitBox();
			}
		}
	}
}
