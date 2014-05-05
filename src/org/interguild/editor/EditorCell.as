package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	import org.interguild.editor.tilelist.TileList;

	public class EditorCell extends Sprite {

		private static const CELL_WIDTH:uint = 32;
		private static const CELL_HEIGHT:uint = 32;

		private static const LINE_COLOR:uint = 0xCCCCCC;
		private var CELL_BG_COLOR:uint = 0xF2F2F2;

		private var currentTitleName:String = " ";
		private var isHighlighted:Boolean = false;

		public function EditorCell() {
			//draw sprite
			graphics.lineStyle(1, LINE_COLOR);
			graphics.beginFill(CELL_BG_COLOR);
			graphics.drawRect(0, 0, CELL_WIDTH, CELL_HEIGHT);
			graphics.endFill();

			//set mouse stuff
			mouseEnabled = true;
			buttonMode = true;
		}

		public function setTile(char:String):void {
			if (currentTitleName != char) {
				currentTitleName = char;
				removeChildren();

				var icon:BitmapData = TileList.getIcon(char);
				if (icon != null)
					addChild(new Bitmap(icon));
			}
		}

		public function clearTile():void {
			currentTitleName = "";
			removeChildren();
		}

		public function get cellName():String {
			return currentTitleName;
		}

		public function toggleHighlight():void {
			isHighlighted = !isHighlighted;
			if (isHighlighted) {
				CELL_BG_COLOR = 0xFFFF00;
				graphics.lineStyle(1, LINE_COLOR);
				graphics.beginFill(CELL_BG_COLOR);
				graphics.drawRect(0, 0, CELL_WIDTH, CELL_HEIGHT);
				graphics.endFill();
			} else {
				CELL_BG_COLOR = 0xF2F2F2;
				graphics.lineStyle(1, LINE_COLOR);
				graphics.beginFill(CELL_BG_COLOR);
				graphics.drawRect(0, 0, CELL_WIDTH, CELL_HEIGHT);
				graphics.endFill();
			}
		}

		public function isHighlight():Boolean {
			return isHighlighted;
		}
	}
}
