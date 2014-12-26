package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorCell;
	import org.interguild.editor.levelpane.EditorLevel;
	import org.interguild.game.tiles.Player;

	public class ChangeTile implements Change {

		private var bucket:Array;
		

		//need coordinates, in case resizing alters cells?
		public function ChangeTile() {
			bucket = new Array;
		}

		public function addTileChanged(cell:EditorCell, prevTile:String, newTile:String, prevPlayerCell:EditorCell = null):void {
			bucket.push(new TileWithChange(cell, prevTile, newTile, prevPlayerCell));
		}

		public function doChange(editor:EditorLevel):void {
			for each (var c:TileWithChange in bucket) {
				editor.setCell(c.cell, c.newTile, true);
			}
		}

		public function undoChange(editor:EditorLevel):void {
			for each(var c:TileWithChange in bucket) {
				editor.setCell(c.cell, c.prevTile, true);
				if (c.newTile == Player.LEVEL_CODE_CHAR) {
					if (c.prevPlayerCell != null)
						editor.setCell(c.prevPlayerCell, Player.LEVEL_CODE_CHAR);
				}
			}
		}
		
		public function get hasChanges():Boolean{
			return bucket.length != 0;
		}
	}
}
