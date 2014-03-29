package org.interguild.editor {
	import flash.display.Sprite;

	public class EditorGrid extends Sprite {

		private var cells:Array;
		
		private var lvlWidth:uint;
		private var lvlHeight:uint;

		public function EditorGrid(numRows:uint, numCols:uint) {
			lvlWidth = numRows;
			lvlHeight = numCols;
			
			//init 2D array
			cells = new Array(numRows);
			for (var i:uint = 0; i < numRows; i++) {
				cells[i] = new Array(numCols);
			}
			
			initGridCells();
		}
		
		public function get levelWidth():uint{
			return lvlWidth;
		}
		
		public function get levelHeight():uint{
			return lvlHeight;
		}
		
		public function clearGrid():void{
			removeChildren();
			initGridCells();
		}
		
		public function initGridCells():void{
			for (var i:uint = 0; i < lvlHeight; i++) {
				for (var j:uint = 0; j < lvlWidth; j++) {
					var c:EditorCell = new EditorCell();
					c.x = j * c.width;
					c.y = i * c.height;
					cells[i][j] = c;
					this.addChild(c);
				}
			}
		}
	}
}
