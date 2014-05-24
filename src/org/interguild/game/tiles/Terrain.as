package org.interguild.game.tiles {
	CONFIG::DEBUG {
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
	}

	import flash.display.BitmapData;
	
	import org.interguild.Aeon;

	public class Terrain extends CollidableObject {

		public static const LEVEL_CODE_CHAR:String = 'x';
		public static const EDITOR_ICON:BitmapData = new TerrainSprite();

		private static const IS_SOLID:Boolean = true;
		private static const HAS_GRAVITY:Boolean = false;

		public function Terrain(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			setProperties(IS_SOLID, HAS_GRAVITY);

			//debugging labels
			CONFIG::DEBUG {
				var tf:TextField = new TextField();
				tf.defaultTextFormat = new TextFormat("Arial", 5, 0x000000);
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.selectable = false;
				tf.text = "(" + x + ", " + y + ")";
				addChild(tf);
			}

			TerrainView.getMe().drawTerrainAt(x, y);
		}
	}
}
