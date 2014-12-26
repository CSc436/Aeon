package org.interguild.editor.history {
	import org.interguild.editor.levelpane.EditorLevel;

	public class ChangedProperties implements Change {

		private var newTitle:String;
		private var oldTitle:String;

		private var newWidth:Number;
		private var oldWidth:Number;

		private var newHeight:Number;
		private var oldHeight:Number;

		private var newTerrain:uint;
		private var oldTerrain:uint;

		private var newBackground:uint;
		private var oldBackground:uint;
		
		private var hasMadeChange:Boolean = false;

		public function ChangedProperties() {
		}

		public function changeTitle(from:String, to:String):void {
			newTitle = to;
			oldTitle = from;
			if(to != from)
				hasMadeChange = true;
		}

		public function changeWidth(from:Number, to:Number):void {
			newWidth = to;
			oldWidth = from;
			if(to != from)
				hasMadeChange = true;
		}

		public function changeHeight(from:Number, to:Number):void {
			newHeight = to;
			oldHeight = from;
			if(to != from)
				hasMadeChange = true;
		}
		
		public function prepareResize():void{
			if(newHeight < oldHeight || newWidth < oldWidth){
				
			}
		}

		public function changeTerrain(from:Number, to:Number):void {
			newTerrain = to;
			oldTerrain = from;
			if(to != from)
				hasMadeChange = true;
		}

		public function changeBackground(from:uint, to:uint):void {
			newBackground = to;
			oldBackground = from;
			if(to != from)
				hasMadeChange = true;
		}

		public function doChange(lvl:EditorLevel):void {
			lvl.title = newTitle;
			lvl.resize(newHeight, newWidth);
			lvl.terrainType = newTerrain;
			lvl.backgroundType = newBackground;
		}

		public function undoChange(lvl:EditorLevel):void {
			lvl.title = oldTitle;
			lvl.resize(oldHeight, oldWidth);
			lvl.terrainType = oldTerrain;
			lvl.backgroundType = oldBackground;
		}
		
		public function hasChanges():Boolean{
			return hasMadeChange;
		}
	}
}
