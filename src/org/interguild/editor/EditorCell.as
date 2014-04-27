package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	import org.interguild.game.Player;
	import org.interguild.game.tiles.ArrowCrate;
	import org.interguild.game.tiles.Collectable;
	import org.interguild.game.tiles.SteelCrate;
	import org.interguild.game.tiles.Terrain;
	import org.interguild.game.tiles.WoodCrate;
	import org.interguild.game.tiles.FinishLine;

	public class EditorCell extends Sprite {

		private static const CELL_WIDTH:uint=32;
		private static const CELL_HEIGHT:uint=32;

		private static const LINE_COLOR:uint=0xCCCCCC;
		private static const CELL_BG_COLOR:uint=0xF2F2F2;

		private var currentTitleName:String=" ";

		public function EditorCell() {
			//draw sprite
			graphics.lineStyle(1, LINE_COLOR);
			graphics.beginFill(CELL_BG_COLOR);
			graphics.drawRect(0, 0, CELL_WIDTH, CELL_HEIGHT);
			graphics.endFill();

			//set mouse stuff
			mouseEnabled=true;
			buttonMode=true;
		}

		public function setTile(char:String):void {

			if (currentTitleName != char) {
				currentTitleName=char;
				removeChildren();

				/**
				 * types of sprites for each editor cell
				 */
				switch (currentTitleName) {
					case Terrain.LEVEL_CODE_CHAR:
						addChild(new Bitmap(new TerrainSprite()));
						break;
					case Player.LEVEL_CODE_CHAR:
						addChild(new Bitmap(new StartLineSprite()));
						break;
					case FinishLine.LEVEL_CODE_CHAR:
						addChild(new Bitmap(new FinishLineSprite()));
						break;
					case WoodCrate.LEVEL_CODE_CHAR:
						addChild(new Bitmap(new WoodenCrateSprite()));
						break;
					case SteelCrate.LEVEL_CODE_CHAR:
						addChild(new Bitmap(new SteelCrateSprite()));
						break;
					case Collectable.LEVEL_CODE_CHAR:
						addChild(new Bitmap(new CollectibleSprite()));
						break;
					case ArrowCrate.LEVEL_CODE_CHAR_LEFT:
						addChild(new Bitmap(new LightningBoxLeft()));
						break;
					case ArrowCrate.LEVEL_CODE_CHAR_RIGHT:
						addChild(new Bitmap(new LightningBoxRight()));
						break;
					case ArrowCrate.LEVEL_CODE_CHAR_DOWN:
						addChild(new Bitmap(new LightningBoxDown()));
						break;
					case ArrowCrate.LEVEL_CODE_CHAR_UP:
						addChild(new Bitmap(new LightningBoxUp()));
						break;
					default:
						trace("EditorCell: Unknown level code character: '" + char + "'");
						break;
				}
			}
		}

		public function clearTile():void {
			currentTitleName="";
			removeChildren();
		}

		public function get cellName():String {
			return currentTitleName;
		}
	}
}
