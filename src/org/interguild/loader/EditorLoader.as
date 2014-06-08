package org.interguild.loader {

	import org.interguild.editor.levelpane.EditorLevel;

	public class EditorLoader extends Loader {
		
		private var level:EditorLevel;
		
		public function EditorLoader() {
			super();
		}
		
		protected override function setLevelInfo():void{
			level = new EditorLevel(this.levelHeight, this.levelWidth, false);
			level.title = this.title;
			level.terrainType = this.terrainType;
			level.backgroundType = this.backgroundType;
			initializedCallback(level);
		}
		
		protected override function initObject(curChar:String, px:int, py:int):void {
			level.setTileAt(curChar, py, px);
		}
	}
}
