package org.interguild.editor {
	import flash.display.Sprite;

	public class EditorGrid extends Sprite {

		private var cells:Array;
		
		private var cols:uint;
		private var rows:uint;

		public function EditorGrid(numRows:uint, numCols:uint) {
			cols = numRows;
			rows = numCols;
			
			//init 2D array
			cells = new Array(numRows);
			for (var i:uint = 0; i < numRows; i++) {
				cells[i] = new Array(numCols);
			}
			
			initGridCells();
		}
		
		public function get levelWidth():uint{
			return cols;
		}
		
		public function get levelHeight():uint{
			return rows;
		}
		
		public function clearGrid():void{
			removeChildren();
			initGridCells();
		}
		
		public function initGridCells():void{
			for (var i:uint = 0; i < rows; i++) {
				for (var j:uint = 0; j < cols; j++) {
					var c:EditorCell = new EditorCell();
					c.x = j * c.width;
					c.y = i * c.height;
					cells[i][j] = c;
					this.addChild(c);
				}
			}
		}
		
		public function resize(newRows:uint, newCols:uint):void{
			var i:uint, j:uint;
			var c:EditorCell;
			var row:Array;
			
			if(newRows > rows){
				//add rows
				for(i = rows; i < newRows; i++){
					row = new Array(cols);
					for (j = 0; j < cols; j++) {
						c = new EditorCell();
						c.x = j * c.width;
						c.y = i * c.height;
						row[j] = c;
						this.addChild(c);
					}
					cells.push(row);
				}
			}else if(newRows < rows){
				//remove rows
				
				//first remove children
				for(i = newRows; i < rows; i++){
					for(j = 0; j < cols; j++){
						c = cells[i][j];
						removeChild(c);
					}
				}
				
				//now remove the rows
				cells.splice(newRows);
			}
			rows = newRows;
			
			if(newCols > cols){
				//add columns
				for(i = 0; i < rows; i++){
					row = cells[i];
					for(j = cols; j < newCols; j++){
						c = new EditorCell();
						c.x = j * c.width;
						c.y = i * c.height;
						row.push(c);
						this.addChild(c);
					}
				}
			}else if(newCols < cols){
				//remove cols
				for(i = 0; i < rows; i++){
					row = cells[i];
					
					//remove children first
					for(j = newCols; j < cols; j++){
						c = row[j];
						removeChild(c);
					}
					
					//remove cols
					row.splice(newCols);
				}
			}
			cols = newCols;
		}
	}
}
