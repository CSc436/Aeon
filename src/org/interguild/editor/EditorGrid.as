package org.interguild.editor {
	import flash.display.Sprite;
	
	public class EditorGrid extends Sprite {

		private var cells:Array;

		private var cols:uint=0;
		private var rows:uint=0;

		public function EditorGrid(numRows:uint, numCols:uint) {
			cols = numCols;
			rows = numRows;

			//init 2D array
			cells = new Array(numRows);
			for (var i:uint = 0; i < numRows; i++) {
				cells[i] = new Array(numCols);
			}

			initGridCells();
		}
		
		public function clone():EditorGrid{
			var temp:EditorGrid = new EditorGrid(rows,cols);
			for(var i:uint =0; i<temp.rows-1; i++){
				for(var j:uint =0; j<temp.cols-1; j++){
					var c:EditorCell = new EditorCell();
					c.x = j * c.width;
					c.y = i * c.height;
					temp.cells[i][j] = c;
					temp.cells[i][j].setTile(cells[i][j].cellName);
					temp.addChild(c);
				}
				
			}
			return temp;
		}

		public function get levelWidth():uint {
			return cols;
		}

		public function get levelHeight():uint {
			return rows;
		}

		public function clearGrid():void {
			removeChildren();
			initGridCells();
		}
		public function getCell(x:int, y:int):EditorCell{
			x = x/32;
			trace("y " +y);
			y = y/32;
			trace(x); trace("y2 " +y);
			return cells[y][x]
		}

		/**
		 * place a type on a specific cell
		 */
		public function placeTile(char:String, row:uint, col:uint):void {
			if (row < rows && col < cols) {
				EditorCell(cells[row][col]).setTile(char);
			} else {
				throw new Error("EditorGrid.placeTile() Invalid (row,col) coordinates: (" + row + "," + col + ")");
			}
		}

		/**
		 * create a new grid
		 */
		private function initGridCells():void {
			for (var i:uint = 0; i < rows; i++) {
				for (var j:uint = 0; j < cols; j++) {
					var c:EditorCell = new EditorCell();
					c.x = j * c.width;
					c.y = i * c.height;
					if(i == 0 || j ==0 || i == rows-1 || j==cols-1){
						c.setTile("x");	
					}
					cells[i][j] = c;
					this.addChild(c);
				}
			}
		}
		
		/**
		 * print out the cell types using chars
		 */
		public function toStringCells():String {
			var s:String = "";
			for (var r:uint = 0; r < rows; r++) {
				for (var c:uint = 0; c < cols; c++) {
					s += EditorCell(cells[r][c]).cellName;
				}
				s+="\n";
			}
			return s;
		}

		/**
		 * resize the new grid to the new dimensions
		 */
		public function resize(newRows:uint, newCols:uint):void {
			var i:uint, j:uint;
			var c:EditorCell;
			var row:Array;

			if (newRows > rows) {
				//add rows
				for (i = rows; i < newRows; i++) {
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
			} else if (newRows < rows) {
				//remove rows

				//first remove children
				for (i = newRows; i < rows; i++) {
					for (j = 0; j < cols; j++) {
						c = cells[i][j];
						removeChild(c);
					}
				}

				//now remove the rows
				cells.splice(newRows);
			}
			rows = newRows;

			if (newCols > cols) {
				//add columns
				for (i = 0; i < rows; i++) {
					row = cells[i];
					for (j = cols; j < newCols; j++) {
						c = new EditorCell();
						c.x = j * c.width;
						c.y = i * c.height;
						row.push(c);
						this.addChild(c);
					}
				}
			} else if (newCols < cols) {
				//remove cols
				for (i = 0; i < rows; i++) {
					row = cells[i];

					//remove children first
					for (j = newCols; j < cols; j++) {
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
