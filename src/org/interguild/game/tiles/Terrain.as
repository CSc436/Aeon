package org.interguild.game.tiles {
	CONFIG::DEBUG {
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
	}

	import org.interguild.Aeon;

	public class Terrain extends CollidableObject implements Tile {

		public static const LEVEL_CODE_CHAR:String = 'x';

		public var destructibility:int = 0;
		public var solidity:Boolean = true;
		public var gravible:Boolean = false;
		public var knocksback:int = 0;
		public var buoyancy:Boolean = false;

		public function Terrain(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);

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

		public function getDestructibility():int {
			return destructibility;
		}


		public function isSolid():Boolean {
			return solidity;
		}


		public function isGravible():Boolean {
			return gravible;
		}


		public function doesKnockback():int {
			return knocksback;
		}


		public function isBuoyant():Boolean {
			return false;
		}
	}
}
