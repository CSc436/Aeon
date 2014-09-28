package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorLevel;

	public class EditorHistory {
		
		private var editor:EditorLevel;
		private var pastHistory:Array;
		private var futureHistory:Array;
		
		/**
		 * EditorHistory
		 * 	stores Change objects
		 * types of Change's
		 * 	ChangeTile
		 * 	ChangeRegion
		 * 	ChangeDimensions
		 * 	ChangeProperties
		 */
		public function EditorHistory(editor:EditorLevel) {
			this.editor = editor;
			pastHistory = new Array();
			futureHistory = new Array();
		}
		
		public function addHistory(c:Change):void{
			futureHistory = new Array();
			pastHistory.push(c);
			editor.undoEnabled = true;
			editor.redoEnabled = false;
		}
		
		public function undo():void{
			
		}
		
		public function redo():void{
			
		}
	}
}
