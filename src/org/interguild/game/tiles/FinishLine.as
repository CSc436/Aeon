package org.interguild.game.tiles {
	import flash.display.Bitmap;
	
	import org.interguild.Aeon;

	public class FinishLine extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String='f';
		public static const DESTRUCTIBILITY:int=0;
		public static const IS_SOLID:Boolean=false;
		public static const HAS_GRAVITY:Boolean=false;
		public static const KNOCKBACK_AMOUNT:int=0;
		public static const IS_BUOYANT:int=0;
		
		private var can_win:Boolean;
		private var inactive:Bitmap;
		private var active:Bitmap;
		
		public function FinishLine(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);
			inactive = new Bitmap(new StartLineSprite());
			active = new Bitmap(new FinishLineSprite());
			addChild(inactive);
			can_win = false;
		}
		
		public function canWin():Boolean{
			return can_win;
		}
		
		public function activate():void{
			can_win = true;
			removeChild(inactive);
			addChild(active);
		}
	}
}
