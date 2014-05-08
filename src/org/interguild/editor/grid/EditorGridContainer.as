package org.interguild.editor.grid {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import fl.containers.ScrollPane;
	
	import org.interguild.Aeon;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.Player;

	/**
	 * container for the grid for the EditorPage
	 *
	 * contains:
	 * VScrollBar
	 * HScrollBar
	 * Grid
	 * GridMask
	 */
	public class EditorGridContainer extends Sprite {
		
		private static const POSITION_X:uint = 0;
		private static const POSITION_Y:uint = 89;
		
		private static const BORDER_COLOR:uint = 0x222222;
		private static const BORDER_WIDTH:uint = 1;
		private static const BG_COLOR:uint = 0x115867;
		
		private static const WIDTH:uint = 636;
		private static const HEIGHT:uint = Aeon.STAGE_HEIGHT - POSITION_Y - BORDER_WIDTH;
		
		private var grid:EditorGrid;
		private var gridMask:Sprite;
		private var box:DrawBox;
		
		private var selectedArray:Array;
		private var tileList:TileList;
		private var playerTile:EditorCell;
		
		private var scroll:ScrollPane;

		public function EditorGridContainer(e:TileList) {
			this.tileList = e;
			this.x = POSITION_X;
			this.y = POSITION_Y;
			
			//init bg
			graphics.beginFill(BORDER_COLOR);
			graphics.drawRect(0, 0, WIDTH + (2 * BORDER_WIDTH), HEIGHT + (2 * BORDER_WIDTH));
			graphics.endFill();
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(BORDER_WIDTH, BORDER_WIDTH, WIDTH, HEIGHT);
			graphics.endFill();
			
			scroll = new ScrollPane();
			scroll.x = BORDER_WIDTH;
			scroll.y = BORDER_WIDTH;
			scroll.width = WIDTH;
			scroll.height = HEIGHT;
			addChild(scroll);
		}


		/**
		 * Creates a new grid for the container
		 */
		public function setCurrentGrid(newGrid:EditorGrid):void {			
			grid = newGrid;
			grid.x = 1;
			grid.y = 1;
			
			var container:Sprite = new Sprite();
			container.addChild(grid);
			if(container.width < WIDTH){
				container.graphics.beginFill(0, 0);
				container.graphics.drawRect(0, 0, WIDTH - 16, grid.height);
				container.graphics.endFill();
			}
			container.graphics.beginFill(EditorCell.LINE_COLOR);
			container.graphics.drawRect(0, 0, grid.width + 1, 1);
			container.graphics.drawRect(0, 0, 1, grid.height + 1);
			container.graphics.endFill();
			scroll.source = container;

			grid.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_OVER, altClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_DOWN, selectionDown, true, 0, true);
			//TODO: see at bottom, preview stuff
			//	grid.addEventListener(MouseEvent.MOUSE_OVER, preview, false, 0 , true);
		}

		/**
		 * resize the gui
		 */
		public function resize(rows:int, cols:int):void {
			grid.resize(rows, cols);
		}

		/**
		 * get the grid
		 */
		public function getGrid():EditorGrid {
			return grid;
		}

		/**
		 * 	Event Listeners Section
		 *
		 */
		public function altClick(e:MouseEvent):void {
			var cell:EditorCell = EditorCell(e.target);
			if (e.altKey) {
				clickTile(cell);
			}
		}

		/**
		 * event listener for left clicking
		 */
		private function leftClick(e:MouseEvent):void {
			var cell:EditorCell = EditorCell(e.target);
			trace('here');
			if(box!=null && selectedArray.length==1){
				selectedArray[0].toggleHighlight();
				selectedArray = new Array;
			}
			if (e.ctrlKey) {
				cell.clearTile();
			} else {
				clickTile(cell);				
			}	
		}
		/**
		 * This method is calledd when a selection is chosen on the tile list
		 * only works when selected array contains items
		 */
		public function setMultipleTiles():void{
			if(box!=null && selectedArray.length>1){
					for (var k:int = 0; k < selectedArray.length; k++) {trace(selectedArray[k].x);
						//selectedArray[k].toggleHighlight();
						clickTile(selectedArray[k]);
 					}
			}
		}

		private function clickTile(cell:EditorCell):void {
			var char:String = tileList.getActiveChar();

			if (char == TileList.SELECTION_TOOL_CHAR) {
				return;
			} else if (char == Player.LEVEL_CODE_CHAR) {
				if (playerTile != null)
					playerTile.clearTile();
				playerTile = cell;
			}
			cell.setTile(char);
		}

		private function selectionDown(e:MouseEvent):void {
			if(box!=null){
				if(scroll.contains(box)){
					scroll.removeChild(box);	
				}
			}
			if (tileList.isSelectionBox()) {
			grid.removeEventListener(MouseEvent.MOUSE_DOWN, selectionDown);
			grid.addEventListener(MouseEvent.MOUSE_UP, addCells);

			var cell:EditorCell = EditorCell(e.target);
			//next two lines are the start to box selection
			//TODO: FIGURE OUT BOX SELECTION
			
				if (box != null) {
					trace('notnull');
					for (var k:int = 0; k < selectedArray.length; k++) {
						selectedArray[k].toggleHighlight();
					}
					selectedArray = new Array;
					if(scroll.contains(box)){
						scroll.removeChild(box);	
					}
				}
				box = new DrawBox(grid, mouseX, mouseY);
				scroll.addChild(box);
			}
		}
		/**This method is for addin cells to the array after a box selecton
		 * has been ade
		 * 
		 */
		private function addCells(e:MouseEvent):void {
			grid.removeEventListener(MouseEvent.MOUSE_UP, addCells);
			grid.addEventListener(MouseEvent.MOUSE_DOWN, selectionDown, true, 0, true);
			trace('addcells');
			if (box == null)
				return;

			var startX:int = box.startX;
			var startY:int = box.startY;
			var endX:int = box.endX;
			var endY:int = box.endY;
			//if dragging from bottom right or right side
			if(endY<startY){
				var eY:int=startY;
				var sY:int=endY;
			}else{
				eY = endY;
				sY = startY;
			}
			if(endX<startX){
				var eX:int=startX;
				var sX:int=endX;
			}else{
				eX = endX;
				sX = startX;
			}
			var cols:int = Math.abs((eX - sX) / 32);
			var rows:int = Math.abs((eY - sY) / 32);
			selectedArray = new Array;
			for (var j:int = 0; j <= rows; j++) {
				var they:int = sY + (j * 32);
				for (var i:int = 0; i <= cols; i++) {
					var toAdd:EditorCell = grid.getCell(sX + (i * 32), they);
					if (toAdd != null)
						selectedArray.push(toAdd);
				}
			}
			for (var k:int = 0; k < selectedArray.length; k++) {
				selectedArray[k].toggleHighlight();
			}
		}
//		private function highlightBox(e:MouseEvent):void{
//			var cell:EditorCell=EditorCell(e.target);
//			//next two lines are the start to box selection
//			//TODO: FIGURE OUT BOX SELECTION
//			cell.toggleHighlight();
//		}
//		//playing around with preview listeners
		//TODO: get it so it doesn't erase previous tile as well as be able to still left click
//		private function preview(e:MouseEvent):void{
//			var cell:EditorCell = EditorCell(e.target);
//			
//			cell.setTile(buttonContainer.getActiveButton());
//			cell.addEventListener(MouseEvent.MOUSE_OUT, removePreview);
//		}
//		private function removePreview(e:MouseEvent):void{
//			var cell:EditorCell = EditorCell(e.target);
//			cell.removeChildren();
//		}


	}
}
