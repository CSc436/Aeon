/**/package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorCell;

	internal class TileWithChange {
		
		internal var cell:EditorCell;
		internal var prevTile:String;
		internal var newTile:String;
		internal var prevPlayerCell:EditorCell;
		internal var hasChanges:Boolean;

		public function TileWithChange(cell:EditorCell, prevTile:String, newTile:String, prevPlayerCell:EditorCell = null) {
			this.cell = cell;
			this.prevTile = prevTile;
			this.newTile = newTile;
			this.prevPlayerCell = prevPlayerCell;
		}
	}
}
