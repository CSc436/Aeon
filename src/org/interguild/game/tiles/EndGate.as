package org.interguild.game.tiles {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	import org.interguild.Assets;

	public class EndGate extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'f';
		public static const EDITOR_ICON:BitmapData = Assets.END_GATE_EDITOR_ICON;

		private static const IS_SOLID:Boolean = false;
		private static const HAS_GRAVITY:Boolean = false;

		private static const PORTAL_WIDTH:uint = 32;
		private static const PORTAL_HEIGHT:uint = 48;
		private static const GATE_WIDTH:uint = 2;
		private static const GATE_HEIGHT:uint = 2;
		private static const OFFSET_X:int = 15;
		private static const OFFSET_Y:int = 15;
		
		private var can_win:Boolean;
		private var inactive:Bitmap;
		private var active:MovieClip;

		public function EndGate(x:int, y:int) {
			super(x + OFFSET_X, y + OFFSET_Y, GATE_WIDTH, GATE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);

			inactive = new Bitmap(Assets.END_GATE_SPRITE_INACTIVE);
			active = new Assets.END_GATE_SPRITE_ACTIVE();
			active.stop();
			active.x = inactive.x = GATE_WIDTH / 2 - inactive.width / 2;
			active.y = inactive.y = 17 - inactive.height;
			addChild(inactive);
			can_win = false;
		}

		public function canWin():Boolean {
			return can_win;
		}

		public function activate():void {
			can_win = true;
			removeChild(inactive);
			addChild(active);
			active.play();
		}
	}
}
