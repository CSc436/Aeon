package org.interguild.editor.grid {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.editor.EditorPage;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.Player;

	/**
	 * Responsible for:
	 *   -managing a grid of EditorTile objects
	 *   -managing the mouse events for it
	 */
	public class EditorLevel extends Sprite {

		private static const DEFAULT_WIDTH:uint = 40;
		private static const DEFAULT_HEIGHT:uint = 40;

		private static const PREVIEW_ALPHA:Number = 0.5;

		private static var untitledCount:uint = 1;

		private var levelTitle:String;

		private var cells:Array;
		private var cols:uint = 0;
		private var rows:uint = 0;

		private var previewSprite:Sprite;
		private var previewChar:String;
		private var previewBD:BitmapData;
		private var previewSquare:Sprite;
		private var selectionSquare:SelectionHighlight;
		private var pastePreview:Bitmap;
		private var clipboard:String;

		private var selectStart:Point;
		private var selectEnd:Point;
		private var currentPlayerTile:EditorCell;

		private var scrollPosX:Number = 0;
		private var scrollPosY:Number = 0;

		private var undoList:Array;
		private var redoList:Array;

		private var isMouseDown:Boolean;
		private var isShiftMouseDown:Boolean;
		private var isSelectDown:Boolean;

		public function EditorLevel(numRows:uint = 0, numCols:uint = 0) {
			//init dimensions
			cols = numCols;
			rows = numRows;
			if (cols <= 0)
				cols = DEFAULT_WIDTH;
			if (rows <= 0)
				rows = DEFAULT_HEIGHT;

			levelTitle = "Untitled-" + untitledCount;
			untitledCount++;

			//init undo/redo
			undoList = new Array();
			redoList = new Array();

			//init 2D array
			cells = new Array(rows);
			for (var i:uint = 0; i < rows; i++) {
				cells[i] = new Array(cols);
			}
			initGridCells();

			//init preview
			previewSprite = new Sprite();
			previewSprite.alpha = PREVIEW_ALPHA;

			previewSquare = new Sprite();
			previewSquare.visible = false;
			previewSquare.mouseEnabled = false;
			previewSquare.alpha = PREVIEW_ALPHA;
			addChild(previewSquare);

			selectionSquare = new SelectionHighlight();
			addChild(selectionSquare);

			this.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver, true, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
		}

		public function get title():String {
			return levelTitle;
		}

		public function set title(s:String):void {
			levelTitle = s;
		}

		private function onDown(evt:MouseEvent):void {
			if (evt.target is EditorCell) {
				var cell:EditorCell = EditorCell(evt.target);
				previewSprite.visible = false;
				isMouseDown = true;
				selectionSquare.visible = false;
				selectStart = cell.getPoint();
				selectEnd = selectStart;
				if (pastePreview && !evt.shiftKey) {
					paste(cell);
				} else if (EditorPage.currentTile == TileList.SELECTION_TOOL_CHAR || (pastePreview && evt.shiftKey)) {
					isSelectDown = true;
					if (pastePreview) {
						removeChild(pastePreview);
						pastePreview = null;
					}
					previewSelection(cell);
				} else if (evt.shiftKey) {
					isShiftMouseDown = true;
					previewSelection(cell);
				} else {
					clickCell(cell);
				}
			}
		}

		private function onUp(evt:MouseEvent):void {
			if (isShiftMouseDown && !isSelectDown) {
				clickSelection();
			}
			isMouseDown = false;
			isSelectDown = false;
			isShiftMouseDown = false;
			previewSquare.visible = false;
		}

		/**
		 * Instead of listening to a mouse-move event (which is slow),
		 * we are listening to the mouse-over event that is triggered
		 * on every single tile.
		 */
		private function onOver(evt:MouseEvent):void {
			if (evt.target is EditorCell) {
				var cell:EditorCell = EditorCell(evt.target);

				if (pastePreview) {
					pastePreview.x = cell.x;
					pastePreview.y = cell.y;
					addChild(pastePreview);
					return;
				}

				//for users who started pressing shift too late
				if (isMouseDown && !isShiftMouseDown && evt.shiftKey) {
					isShiftMouseDown = true;
				}

				if (isSelectDown) {
					selectEnd = cell.getPoint();
					previewSelection(cell);
				} else if (isShiftMouseDown) {
					selectEnd = cell.getPoint();
					previewSelection(cell);
					cell.addChild(previewSprite);
				} else if (isMouseDown) {
					clickCell(cell);
				} else {
					previewCell(cell);
				}
			}
		}

		private function previewCell(cell:EditorCell):void {
			var currentChar:String = EditorPage.currentTile;
			if (currentChar == TileList.SELECTION_TOOL_CHAR)
				return;

			//update preview image for mouseovers
			if (previewChar != currentChar) {
				previewChar = currentChar;
				var bd:BitmapData = TileList.getIcon(previewChar);
				if (bd == null)
					return;
				previewSprite.removeChildren();
				previewSprite.addChild(new Bitmap(bd));

				previewBD = new BitmapData(cell.width, cell.height, true, 0x00000000);
				var sourceRect:Rectangle = new Rectangle(0, 0, EditorCell.CELL_WIDTH - 1, EditorCell.CELL_HEIGHT - 1);
				var destPoint:Point = new Point(0, 0);
				previewBD.copyPixels(bd, sourceRect, destPoint);
			}

			//move preview image
			previewSprite.visible = true;
			cell.addChild(previewSprite);
		}

		private function previewSelection(cell:EditorCell):void {
			if (selectStart.equals(selectEnd) && !isSelectDown) {
				previewSquare.visible = false;
				previewCell(cell);
			} else {
				previewSprite.visible = false;

				//determine selection dimensions
				var rect:Rectangle = new Rectangle();
				rect.width = (selectEnd.x - selectStart.x) * EditorCell.CELL_WIDTH;
				rect.height = (selectEnd.y - selectStart.y) * EditorCell.CELL_HEIGHT;
				rect.x = selectStart.x * EditorCell.CELL_WIDTH;
				rect.y = selectStart.y * EditorCell.CELL_HEIGHT;
				if (rect.width < 0) {
					rect.x += rect.width;
				}
				if (rect.height < 0) {
					rect.y += rect.height;
				}
				rect.width = Math.abs(rect.width);
				rect.height = Math.abs(rect.height);
				rect.width += EditorCell.CELL_WIDTH;
				rect.height += EditorCell.CELL_HEIGHT;

				if (isSelectDown) {
					selectionSquare.resize(rect);
					selectionSquare.visible = true;
					addChild(selectionSquare);
				} else {
					previewSquare.graphics.clear();
					previewSquare.graphics.beginBitmapFill(previewBD);
					previewSquare.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
					previewSquare.graphics.endFill();
					previewSquare.visible = true;
				}
			}
		}

		private function clickCell(cell:EditorCell, tile:String = null):void {
			var char:String = tile;
			if (char == null) {
				char = EditorPage.currentTile;
			}
			switch (char) {
				case TileList.ERASER_TOOL_CHAR:
					cell.clearTile();
					if (cell == currentPlayerTile)
						currentPlayerTile = null;
					previewCell(cell);
					break;
				default:
					cell.setTile(char);
					if (char == Player.LEVEL_CODE_CHAR) {
						if (currentPlayerTile != null)
							currentPlayerTile.clearTile(isMouseDown);
						currentPlayerTile = cell;
					}
					break;
			}
		}

		public function deselect(onCopy:Boolean = false):void {
			selectionSquare.visible = false;
			if (!onCopy && pastePreview) {
				removeChild(pastePreview);
				pastePreview = null;
			}
		}

		private function clickSelection():void {
			var incX:int = 1;
			var incY:int = 1;
			if (selectEnd.x < selectStart.x)
				incX = -1;
			if (selectEnd.y < selectStart.y)
				incY = -1;

			var finX:Boolean = false;
			var finY:Boolean = false;
			for (var ix:int = selectStart.x; !finX; ix += incX) {
				finY = false;
				for (var iy:int = selectStart.y; !finY; iy += incY) {
					var cell:EditorCell = EditorCell(cells[iy][ix]);
					clickCell(cell);
					if (iy == selectEnd.y)
						finY = true;
				}
				if (ix == selectEnd.x)
					finX = true;
			}
		}

		private function onOut(evt:MouseEvent):void {
			previewSprite.visible = false;
		}

		public function copy(toCut:Boolean = false):void {
			//selection boundaries
			var top:int = Math.min(selectStart.y, selectEnd.y);
			var left:int = Math.min(selectStart.x, selectEnd.x);
			var bottom:int = Math.max(selectStart.y, selectEnd.y);
			var right:int = Math.max(selectStart.x, selectEnd.x);
			
			//image dimensions
			var width:Number = (selectEnd.x - selectStart.x) * EditorCell.CELL_WIDTH;
			var height:Number = (selectEnd.y - selectStart.y) * EditorCell.CELL_HEIGHT;
			width = Math.abs(width);
			height = Math.abs(height);
			width += EditorCell.CELL_WIDTH;
			height += EditorCell.CELL_HEIGHT;

			//will store copy data as text, and create image preview of clipboard
			clipboard = "";
			var image:BitmapData = new BitmapData(width, height, true, 0x00000000);
			
			//iterate through copy region
			for (var iy:int = top; iy <= bottom; iy++) {
				for (var ix:int = left; ix <= right; ix++) {
					var cell:EditorCell = EditorCell(cells[iy][ix]);
					
					//add cell to clipboard text
					clipboard += cell.char;
					
					//add cell image to image preview
					var sizeToCopy:Rectangle = new Rectangle(0, 0, EditorCell.CELL_WIDTH - 1, EditorCell.CELL_HEIGHT - 1);
					var locToCopy:Point = new Point((ix - left) * EditorCell.CELL_WIDTH, (iy - top) * EditorCell.CELL_HEIGHT);
					var bdToCopy:BitmapData = TileList.getIcon(cell.char);
					if (cell.char != TileList.ERASER_TOOL_CHAR && bdToCopy != null) {
						image.copyPixels(bdToCopy, sizeToCopy, locToCopy);
					}
					
					//if cutting, delete the cell
					if(toCut)
						cell.clearTile();
				}
				clipboard += "\n";
			}
			
			//finalize preview image
			pastePreview = new Bitmap(image);
			pastePreview.alpha = PREVIEW_ALPHA;
			addChild(pastePreview);

			//make the selection go away so that user can paste
			deselect(true);
		}
		
		public function cut():void{
			copy(true); // ~~magic~~ // :o
		}

		private function paste(cell:EditorCell):void {
			var pasteLoc:Point = cell.getPoint();

			var iy:int = pasteLoc.y;
			var ix:int = pasteLoc.x;
			var i:uint = 0;
			while (i < clipboard.length) {
				var char:String = clipboard.charAt(i);
				if (char == "\n") {
					ix = pasteLoc.x;
					iy++;
				} else {
					var c:EditorCell = EditorCell(cells[iy][ix]);
					clickCell(c, char);
					ix++;
				}
				i++;
			}
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
			s += levelTitle + "\n";
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
