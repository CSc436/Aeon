package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorLevel;

	public class EditorHistory {
		
		private var level:EditorLevel;
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
			this.level = editor;
			pastHistory = new Array();
			futureHistory = new Array();
		}
		
		public function addHistory(c:Change):void{
			futureHistory = new Array(); //reset future history
			pastHistory.push(c);
			level.undoEnabled = true;
			level.redoEnabled = false;
		}
		
		public function undo():void{
			if(pastHistory.length > 0){
				var c:Change = pastHistory.pop();
				futureHistory.push(c);
				c.undoChange(level);
				level.redoEnabled = true;
				if(pastHistory.length == 0)
					level.undoEnabled = false;
			}
		}
		
		public function redo():void{
			if(futureHistory.length > 0){
				var c:Change = futureHistory.pop();
				pastHistory.push(c);
				c.doChange(level);
				level.undoEnabled = true;
				if(futureHistory.length == 0)
					level.redoEnabled = false;
			}
		}
	}
}
