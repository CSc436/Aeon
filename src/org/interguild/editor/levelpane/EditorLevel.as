package org.interguild.editor.levelpane {
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

		private static const DEFAULT_WIDTH:uint = 30;
		private static const DEFAULT_HEIGHT:uint = 30;

		private static const PREVIEW_ALPHA:Number = 0.5;
		private static const PREVIEW_SHIFT_ALPHA:Number = 0.75;
		private static const PREVIEW_SHIFT_COLOR:uint = 0xFF660000; // ARGB format

		private static var untitledCount:uint = 1;
		private static var clipboard:String;
		private static var pastePreview:Bitmap;
		private static var pastePreviewOld:Bitmap;
		private static var shiftPreview:Bitmap;
		private static var shiftPreviewOld:Bitmap;
		private static var shiftDown:Boolean;

		public static function set isShiftDown(b:Boolean):void {
			shiftDown = b;
			if (pastePreview) {
				shiftPreview.visible = shiftDown;
			}
		}

		private var levelTitle:String;

		private var cells:Array;
		private var cols:uint = 0;
		private var rows:uint = 0;

		private var previewSprite:Sprite;
		private var previewChar:String;
		private var previewBD:BitmapData;
		private var previewSquare:Sprite;
		private var selectionSquare:SelectionHighlight;
		private var lastMouseOverCell:EditorCell;

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
				// if user is pasting, and they aren't canceling it with shift key
				if (pastePreview) {
					paste(cell, evt.shiftKey);
						//if user is selecting, or they cancelled their paste with shift key
				} else if (EditorPage.currentTile == TileList.SELECTION_TOOL_CHAR) {
					isSelectDown = true;
					if (pastePreview) {
						removeChild(pastePreview);
						removeChild(shiftPreview);
						pastePreview = null;
						shiftPreview = null;
					}
					previewSelection(cell);
						//if user is shift-clicking a tile
				} else if (evt.shiftKey) {
					isShiftMouseDown = true;
					previewSelection(cell);
				} else {
					//user is placing down a tile
					clickCell(cell);
				}
				EditorPage.hasMadeFirstChange = true;
			}
		}

		private function onUp(evt:MouseEvent):void {
			//if user was shift-clicking a tile, then commit the changes
			if (isShiftMouseDown && !isSelectDown) {
				fillSelection();
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
				lastMouseOverCell = cell;

				//user is moving around the pastePreview before pasting
				if (pastePreview) {
					pastePreview.visible = true;
					shiftPreview.visible = shiftDown;
					pastePreview.x = cell.x;
					pastePreview.y = cell.y;
					shiftPreview.x = cell.x;
					shiftPreview.y = cell.y;
					addChild(shiftPreview);
					addChild(pastePreview);
				} else {
					//if user started pressing shift too late, pretend like they pressed it on time
					if (isMouseDown && !isShiftMouseDown && evt.shiftKey) {
						isShiftMouseDown = true;
					}

					//if user is making selection, update selection
					if (isSelectDown) {
						selectEnd = cell.getPoint();
						previewSelection(cell);
							//if user is shift-clicking, update preview
					} else if (isShiftMouseDown) {
						selectEnd = cell.getPoint();
						previewSelection(cell);
						cell.addChild(previewSprite);
							//if user is click-and-dragging over many cells
					} else if (isMouseDown) {
						clickCell(cell);
							//if user is moving the preview cell around
					} else {
						previewCell(cell);
					}
				}
			}
		}

		/**
		 * Shows a single-cell preview image of what it would look like
		 * to place the currently selected tile over the given cell.
		 *
		 * When the selected tool has changed, it updates the preview
		 * image, as well as the image used for the shift-click preview.
		 */
		private function previewCell(cell:EditorCell):void {
			var currentChar:String = EditorPage.currentTile;
			//if selection tool, don't show a preview
			if (currentChar == TileList.SELECTION_TOOL_CHAR)
				return;

			//if we need to update the preview images
			if (previewChar != currentChar) {
				previewChar = currentChar;
				var bd:BitmapData = TileList.getIcon(previewChar);
				if (bd == null)
					return;

				//update preview cell image
				previewSprite.removeChildren();
				previewSprite.addChild(new Bitmap(bd));

				//update shift-click preview image data
				previewBD = new BitmapData(cell.width, cell.height, true, 0x00000000);
				var sourceRect:Rectangle = new Rectangle(0, 0, EditorCell.CELL_WIDTH - 1, EditorCell.CELL_HEIGHT - 1);
				var destPoint:Point = new Point(0, 0);
				previewBD.copyPixels(bd, sourceRect, destPoint);
			}

			//move preview image
			previewSprite.visible = true;
			cell.addChild(previewSprite);
		}

		/**
		 * This function is used to update both the shift-click preview image
		 * and the selection tool's highlight box.
		 */
		private function previewSelection(cell:EditorCell):void {
			//if shift-click selection is only one tile, show single-cell preview image
			if (selectStart.equals(selectEnd) && !isSelectDown) {
				previewSquare.visible = false;
				previewCell(cell);
			} else {
				previewSprite.visible = false;

				//determine selection dimensions and position
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

				//if using selection tool, how highlight box
				if (isSelectDown) {
					selectionSquare.resize(rect);
					selectionSquare.visible = true;
					addChild(selectionSquare);
				} else { //if shift-clicking, show preview
					previewSquare.graphics.clear();
					previewSquare.graphics.beginBitmapFill(previewBD);
					previewSquare.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
					previewSquare.graphics.endFill();
					previewSquare.visible = true;
				}
			}
		}

		/**
		 * Called whenever the user wants to set a tile to something.
		 *
		 * If `tile` is null, the currently selected tile will be used.
		 */
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
					if (char == Player.LEVEL_CODE_CHAR) {
						if (currentPlayerTile != null)
							currentPlayerTile.clearTile(isMouseDown);
						currentPlayerTile = cell;
					}else{
						currentPlayerTile = null;
					}
					cell.setTile(char);
					break;
			}
		}

		/**
		 * Used by EditorLoader when loading in a level.
		 */
		public function setTileAt(char:String, row:uint, col:uint):void {
			if (row < rows && col < cols) {
				clickCell(EditorCell(cells[row][col]), char);
			} else {
				throw new Error("EditorGrid.placeTile() Invalid (row,col) coordinates: (" + row + "," + col + ")");
			}
		}

		/**
		 * Called whenever it's time to deselect from the selection tool.
		 * This event is also when it's time to turn off copy/paste.
		 */
		public function deselect(onCopy:Boolean = false):void {
			selectionSquare.visible = false;
			if (!onCopy && pastePreview) {
				removeChild(pastePreview);
				removeChild(shiftPreview);
				pastePreview = null;
				shiftPreview = null;
			}
		}

		/**
		 * Fills the current selection with the current tile. This is currently
		 * only used by the shift-click feature.
		 */
		private function fillSelection():void {
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

		/**
		 * This function is triggered when the MouseOut event is triggered
		 * on the entire level (not every tile).
		 */
		private function onOut(evt:MouseEvent):void {
			//if user's mouse leaves level, hide preview
			previewSprite.visible = false;
			if (pastePreview) {
				pastePreview.visible = false;
				shiftPreview.visible = false;
			}
		}

		/**
		 * Assumes there is an active selection made.
		 */
		public function copy(toCut:Boolean = false):void {
			if (!selectionSquare.visible)
				return;

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
			var imageShift:BitmapData = new BitmapData(width, height, true, 0x00000000);

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
					if (bdToCopy != null) {
						if (cell.char == TileList.ERASER_TOOL_CHAR) {
							sizeToCopy.x = locToCopy.x;
							sizeToCopy.y = locToCopy.y;
							imageShift.fillRect(sizeToCopy, PREVIEW_SHIFT_COLOR);
						} else {
							image.copyPixels(bdToCopy, sizeToCopy, locToCopy);
						}
					}

					//if cutting, delete the cell
					if (toCut)
						cell.clearTile();
				}
				clipboard += "\n";
			}

			//finalize preview images
			pastePreview = new Bitmap(image);
			pastePreview.alpha = PREVIEW_ALPHA;
			pastePreview.x = lastMouseOverCell.x;
			pastePreview.y = lastMouseOverCell.y;
			pastePreviewOld = pastePreview;

			shiftPreview = new Bitmap(imageShift);
			shiftPreview.alpha = PREVIEW_SHIFT_ALPHA;
			shiftPreview.x = lastMouseOverCell.x;
			shiftPreview.y = lastMouseOverCell.y;
			shiftPreviewOld = shiftPreview;
			shiftPreview.visible = shiftDown;

			addChild(shiftPreview);
			addChild(pastePreview);

			//make the selection go away so that user can paste
			deselect(true);
		}

		public function cut():void {
			copy(true); // ~~magic~~ // :o
		}

		/**
		 * When user presses "Paste" load in the last thing
		 * on the clipboard so that they can paste it.
		 */
		public function prepareToPaste():void {
			if (pastePreviewOld) {
				deselect();
				pastePreview = pastePreviewOld;
				shiftPreview = shiftPreviewOld;
				addChild(shiftPreview);
				addChild(pastePreview);
			}
		}

		/**
		 * Assumes there's something that you can paste.
		 */
		private function paste(cell:EditorCell, pasteBlanks:Boolean):void {
			var pasteLoc:Point = cell.getPoint();

			var iy:int = pasteLoc.y;
			var ix:int = pasteLoc.x;
			var i:uint = 0;
			while (i < clipboard.length) {
				var char:String = clipboard.charAt(i);
				if (char == "\n") {
					ix = pasteLoc.x;
					iy++;
				} else if (iy < rows && ix < cols && iy >= 0 && ix >= 0) {
					var c:EditorCell = EditorCell(cells[iy][ix]);
					if (char != " " || pasteBlanks)
						clickCell(c, char);
					ix++;
				}
				i++;
			}
		}

		/**
		 * Delete everything inside a selection
		 */
		public function deleteSelection():void {
			if (!selectionSquare.visible)
				return;

			//selection boundaries
			var top:int = Math.min(selectStart.y, selectEnd.y);
			var left:int = Math.min(selectStart.x, selectEnd.x);
			var bottom:int = Math.max(selectStart.y, selectEnd.y);
			var right:int = Math.max(selectStart.x, selectEnd.x);

			//iterate through copy region
			for (var iy:int = top; iy <= bottom; iy++) {
				for (var ix:int = left; ix <= right; ix++) {
					var cell:EditorCell = EditorCell(cells[iy][ix]);
					cell.clearTile();
				}
			}
		}

		/**
		 * Duplicates this level, tile by tile.
		 */
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
	}
}
