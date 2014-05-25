package org.interguild.loader {

	import org.interguild.editor.levelpane.EditorLevel;

	public class EditorLoader extends Loader {
		
		private var grid:EditorLevel;
		
		public function EditorLoader() {
			super();
		}
		
		protected override function setLevelInfo(title:String, lvlWidth:uint, lvlHeight:uint):void{
			grid = new EditorLevel(lvlHeight, lvlWidth);
			grid.title = title;
			initializedCallback(grid);
		}
		
		protected override function initObject(curChar:String, px:int, py:int):void {
			grid.setTileAt(curChar, py, px);
		}
	}
}
