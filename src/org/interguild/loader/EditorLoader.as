package org.interguild.loader {

	import org.interguild.editor.grid.EditorGrid;

	public class EditorLoader extends Loader {
		
		private var grid:EditorGrid;
		
		public function EditorLoader() {
			super();
		}
		
		protected override function setLevelInfo(title:String, lvlWidth:uint, lvlHeight:uint):void{
			grid = new EditorGrid(lvlHeight, lvlWidth);
			initializedCallback(grid);
		}
		
		protected override function initObject(curChar:String, px:int, py:int):void {
			grid.placeTile(curChar, py, px);
		}
	}
}
