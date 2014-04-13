package org.interguild.game.tiles {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import org.interguild.Aeon;

	public class Terrain extends CollidableObject implements Tile {

		public static const LEVEL_CODE_CHAR:String = 'x';

		private static const SPRITE_COLOR:uint = 0x9EDB00;
		private static const SPRITE_WIDTH:uint = 32;
		private static const SPRITE_HEIGHT:uint = 32;

		public var destructibility:int = 0;
		public var solidity:Boolean = true;
		public var gravible:Boolean = false;
		public var knocksback:int = 0;
		public var buoyancy:Boolean = false;

		public function Terrain(x:int, y:int) {
			super(x, y, Aeon.TILE_WIDTH, Aeon.TILE_HEIGHT);
			graphics.beginFill(SPRITE_COLOR);
			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
			graphics.endFill();

			CONFIG::DEBUG {
				var tf:TextField = new TextField();
				tf.defaultTextFormat = new TextFormat("Arial", 5, 0x000000);
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.selectable = false;
				tf.text = "(" + x + ", " + y + ")";
				addChild(tf);
			}
		}

//		/*
//		 * DEBUG
//		 */
//		public function makeBlue():void{
//			graphics.clear();
//			graphics.beginFill(0x003399);
//			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
//			graphics.endFill();
//		}
//		
//		public function makeGray():void{
//			graphics.clear();
//			graphics.beginFill(0x333333);
//			graphics.drawRect(0, 0, SPRITE_WIDTH, SPRITE_HEIGHT);
//			graphics.endFill();
//		}
//		/*
//		 * END DEBUG
//		 */

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
