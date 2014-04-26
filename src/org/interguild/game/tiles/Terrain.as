package org.interguild.game.tiles {
	CONFIG::DEBUG {
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
	}

	import flash.display.Bitmap;
	
	import org.interguild.Aeon;

	public class Terrain extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'x';
		public static const DESTRUCTIBILITY:int=0;
		public static const IS_SOLID:Boolean=true;
		public static const HAS_GRAVITY:Boolean=false;
		public static const KNOCKBACK_AMOUNT:int=0;
//		public static const IS_BUOYANT:Boolean=false;

		public function Terrain(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT, LEVEL_CODE_CHAR, DESTRUCTIBILITY, IS_SOLID, HAS_GRAVITY, KNOCKBACK_AMOUNT);

			CONFIG::DEBUG {
				var tf:TextField = new TextField();
				tf.defaultTextFormat = new TextFormat("Arial", 5, 0x000000);
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.selectable = false;
				tf.text = "(" + x + ", " + y + ")";
				addChild(tf);
			}

				//TODO understand this function Henry
			TerrainView.getMe().drawTerrainAt(x, y);
//			addChild(new Bitmap(new TerrainSprite()));
		}
	}
}
