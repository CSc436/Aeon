package org.interguild.editor.grid {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import org.interguild.editor.tilelist.TileList;

	public class EditorCell extends Sprite {

		private static const CELL_WIDTH:uint = 32;
		private static const CELL_HEIGHT:uint = 32;

		public static const LINE_COLOR:uint = 0x777777;
		public static const CELL_BG_COLOR:uint = 0x000000;

		private var currentTitleName:String = " ";
		private var isHighlighted:Boolean = false;
		private var border:Sprite;

		public function EditorCell() {
			//init bg
			graphics.beginFill(CELL_BG_COLOR);
			graphics.drawRect(0, 0, CELL_WIDTH - 1, CELL_HEIGHT - 1);
			graphics.endFill();
			
			//init border
			border = new Sprite();
			border.graphics.beginFill(LINE_COLOR);
			border.graphics.drawRect(CELL_WIDTH - 1, 0, 1, CELL_HEIGHT);
			border.graphics.drawRect(0, CELL_HEIGHT - 1, CELL_WIDTH, 1);
			border.graphics.endFill();
			addChild(border);

			//set mouse stuff
			mouseEnabled = true;
			buttonMode = true;
			mouseChildren = false;
		}

		public function setTile(char:String):void {
			if (currentTitleName != char) {
				currentTitleName = char;
				removeChildren();

				var icon:BitmapData = TileList.getIcon(char);
				if (icon != null)
					addChild(new Bitmap(icon));
				addChild(border);
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
				var yellow:uint = 0xFFFF00;
				//init border
				removeChild(border);
				border = new Sprite();
				border.graphics.beginFill(yellow);
				border.graphics.drawRect(CELL_WIDTH - 1, 0, 1, CELL_HEIGHT);
				border.graphics.drawRect(0, CELL_HEIGHT - 1, CELL_WIDTH, 1);
				border.graphics.endFill();
				addChild(border);

			} else {
				//init border
				border = new Sprite();
				border.graphics.beginFill(LINE_COLOR);
				border.graphics.drawRect(CELL_WIDTH - 1, 0, 1, CELL_HEIGHT);
				border.graphics.drawRect(0, CELL_HEIGHT - 1, CELL_WIDTH, 1);
				border.graphics.endFill();
				addChild(border);
			}
		}

		public function isHighlight():Boolean {
			return isHighlighted;
		}
	}
}
