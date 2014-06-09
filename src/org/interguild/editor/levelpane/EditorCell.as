package org.interguild.editor.levelpane {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.tiles.Player;

	public class EditorCell extends Sprite {

		public static const CELL_WIDTH:uint = 32;
		public static const CELL_HEIGHT:uint = 32;

		public static const LINE_COLOR:uint = 0x444444;//0x777777;
		public static const LINE_ALPHA:Number = 0.5;
		private static const CELL_BG_COLOR:uint = 0x000000;
		private static const CELL_BG_ALPHA:Number = 0;//.25;

		private var tileChar:String = TileList.ERASER_TOOL_CHAR;
		private var tileBeforePlayer:String = tileChar;
		private var isHighlighted:Boolean = false;
		private var border:Sprite;

		public function EditorCell() {
			//init bg
			graphics.beginFill(CELL_BG_COLOR, CELL_BG_ALPHA);
			graphics.drawRect(0, 0, CELL_WIDTH - 1, CELL_HEIGHT - 1);
			graphics.endFill();

			//init border
			border = new Sprite();
			border.graphics.beginFill(LINE_COLOR, LINE_ALPHA);
			border.graphics.drawRect(CELL_WIDTH - 1, 0, 1, CELL_HEIGHT);
			border.graphics.drawRect(0, CELL_HEIGHT - 1, CELL_WIDTH, 1);
			border.graphics.endFill();
			addChild(border);

			//set mouse stuff
			mouseEnabled = true;
			buttonMode = true;
			mouseChildren = false;
		}

		public function getPoint():Point {
			return new Point(x / CELL_WIDTH, y / CELL_HEIGHT);
		}

		public function setTile(newChar:String):void {
			if (tileChar != newChar) {
				if (newChar == Player.LEVEL_CODE_CHAR) {
					tileBeforePlayer = tileChar;
				}
				tileChar = newChar;
				removeChildren();
				var icon:BitmapData = TileList.getIcon(newChar);
				if (icon != null && tileChar != TileList.ERASER_TOOL_CHAR){
					addChild(new Bitmap(icon));
				}else{
					tileChar = TileList.ERASER_TOOL_CHAR;
				}
				addChild(border);
			}
		}
		
		public function redraw():void{
			removeChildren();
			var icon:BitmapData = TileList.getIcon(tileChar);
			addChild(new Bitmap(icon));
			addChild(border);
		}

		public function clearTile(clearFromPLayer:Boolean = false):void {
			if (clearFromPLayer && tileBeforePlayer != TileList.ERASER_TOOL_CHAR) {
				setTile(tileBeforePlayer);
			} else {
				tileChar = " ";
				removeChildren();
				addChild(border);
			}
		}

		public function get char():String {
			return tileChar;
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
