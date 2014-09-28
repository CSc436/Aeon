package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorCell;
	import org.interguild.editor.levelpane.EditorLevel;

	public class ChangeTile implements Change {
		
		private var cell:EditorCell;
		private var prevTile:String;
		private var newTile:String;
		
		//need coordinates, in case resizing alters cells?
		public function ChangeTile(cell:EditorCell, prevTile:String, newTile:String) {
			this.cell = cell;
			this.prevTile = prevTile;
			this.newTile = newTile;
		}
		
		public function doChange(editor:EditorLevel):void{
			editor.setCell(cell, newTile);
		}
		
		public function undoChange(editor:EditorLevel):void{
			
		}
	}
}
