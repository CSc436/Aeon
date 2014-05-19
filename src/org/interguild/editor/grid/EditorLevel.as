package org.interguild.editor.grid {
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import org.interguild.editor.EditorPage;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.Player;

	public class EditorLevel extends Sprite {

		private static const DEFAULT_WIDTH:uint = 40;
		private static const DEFAULT_HEIGHT:uint = 40;

		private static const PREVIEW_ALPHA:Number = 0.5;

		private var levelName:String;

		private var cells:Array;
		private var cols:uint = 0;
		private var rows:uint = 0;

		private var previewSprite:Sprite;
		private var previewChar:String;

		private var selectStart:Point;
		private var selectEnd:Point;
		private var currentPlayerTile:EditorCell;

		private var scrollPosX:Number = 0;
		private var scrollPosY:Number = 0;

		private var undoList:Array;
		private var redoList:Array;

		private var isMouseDown:Boolean;

		public function EditorLevel(numRows:uint = 0, numCols:uint = 0) {
			//init dimensions
			cols = numCols;
			rows = numRows;
			if (cols <= 0)
				cols = DEFAULT_WIDTH;
			if (rows <= 0)
				rows = DEFAULT_HEIGHT;
			
			levelName = "Untitled";

			//init undo/redo
			undoList = new Array();
			redoList = new Array();

			//init 2D array
			cells = new Array(rows);
			for (var i:uint = 0; i < rows; i++) {
				cells[i] = new Array(cols);
			}

			//init preview
			previewSprite = new Sprite();
			previewSprite.alpha = PREVIEW_ALPHA;

			initGridCells();

			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver, true, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
		}

		private function onDown(evt:MouseEvent):void {
			previewSprite.visible = false;
			if (evt.target is EditorCell)
				clickCell(EditorCell(evt.target));
			isMouseDown = true;
		}

		private function onUp(evt:MouseEvent):void {
			isMouseDown = false;
			previewSprite.visible = true;
		}

		private function onOver(evt:MouseEvent):void {
			if (evt.target is EditorCell) {
				var cell:EditorCell = EditorCell(evt.target);
				if (isMouseDown) {
					clickCell(cell);
				} else {
					previewCell(cell);
				}
			}
		}

		private function previewCell(cell:EditorCell):void {
			if (previewChar != EditorPage.currentTile) {
				previewChar = EditorPage.currentTile;
				previewSprite.removeChildren();
				previewSprite.addChild(new Bitmap(TileList.getIcon(previewChar)));
			}
			previewSprite.visible = true;
			cell.addChild(previewSprite);
		}

		private function clickCell(cell:EditorCell):void {
			switch (EditorPage.currentTile) {
				case TileList.SELECTION_TOOL_CHAR:
					break;
				case TileList.ERASER_TOOL_CHAR:
					cell.clearTile();
					if(cell == currentPlayerTile)
						currentPlayerTile = null;
					previewCell(cell);
					break;
				default:
					cell.setTile(EditorPage.currentTile);
					if (EditorPage.currentTile == Player.LEVEL_CODE_CHAR) {
						if (currentPlayerTile != null)
							currentPlayerTile.clearTile(isMouseDown);
						currentPlayerTile = cell;
					}
					break;
			}
		}

		private function onOut(evt:MouseEvent):void {
			previewSprite.visible = false;
		}

		public function clone():EditorLevel {
			var temp:EditorLevel = new EditorLevel(rows, cols);
			for (var i:uint = 0; i < temp.rows - 1; i++) {
				for (var j:uint = 0; j < temp.cols - 1; j++) {
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

		public function get horizontalScrollPosition():Number {
			return scrollPosX;
		}

		public function set horizontalScrollPosition(n:Number):void {
			scrollPosX = n;
		}

		public function get verticalScrollPosition():Number {
			return scrollPosY;
		}

		public function set verticalScrollPosition(n:Number):void {
			scrollPosY = n;
		}


		public function clearGrid():void {
			removeChildren();
			initGridCells();
		}

		public function getCell(x:int, y:int):EditorCell {
			x = (x) / 32;
			y = (y) / 32;
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
					if (i == 0 || j == 0 || i == rows - 1 || j == cols - 1) {
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
		public function getLevelCode():String {
			var s:String = "";
			s += levelName + "\n";
			s += cols + "x" + rows + "\n";
			
			for (var r:uint = 0; r < rows; r++) {
				for (var c:uint = 0; c < cols; c++) {
					s += EditorCell(cells[r][c]).char;
				}
				s += "\n";
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
