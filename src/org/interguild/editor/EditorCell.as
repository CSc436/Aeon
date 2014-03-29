package org.interguild.editor {
	import flash.display.Sprite;

	public class EditorCell extends Sprite {
		
		private static const CELL_WIDTH:uint = 32;
		private static const CELL_HEIGHT:uint = 32;
		
		private static const LINE_COLOR:uint = 0xCCCCCC;
		private static const CELL_BG_COLOR:uint = 0xF2F2F2;
		
		private var tileTyle:String;
		
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
	}
}
