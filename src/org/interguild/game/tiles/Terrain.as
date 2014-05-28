package org.interguild.game.tiles {
	CONFIG::DEBUG {
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
	}

	import flash.display.BitmapData;

	import org.interguild.Aeon;

	public class Terrain extends CollidableObject {

		private static var TT_MAP:Array;
		private static var TT_BITMAP:uint = 0;
		private static var TT_NAME:uint = 1;

		private static function initMap():void {
			TT_MAP = [];
			TT_MAP.push([new TerrainWoodSprite(), "Wood Pattern"]);
			TT_MAP.push([new TerrainSteelSprite(), "Steel Pattern"]);
		}
		
		private static function isInBounds(id:Number):Boolean {
			if (TT_MAP == null)
				initMap();

			if (isNaN(id) || id < 0 || id >= TT_MAP.length)
				return false;
			else
				return true;
		}

		public static function getTerrainImage(id:Number):BitmapData {
			if (!isInBounds(id))
				return null;

			return TT_MAP[id][TT_BITMAP];
		}

		public static function getName(id:Number):String {
			if (!isInBounds(id))
				return null;

			return TT_MAP[id][TT_NAME];
		}

		public static const LEVEL_CODE_CHAR:String = 'x';

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
