package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.interguild.Aeon;
	import org.interguild.editor.scrollBar.HorizontalBar;
	import org.interguild.editor.scrollBar.VerticalScrollBar;

	/**
	 * container for the grid for the EditorPage
	 * 
	 * contains:
	 * VScrollBar
	 * HScrollBar
	 * Grid
	 * GridMask
	 */
	public class EditorGridContainer extends Sprite{
		private var grid:EditorGrid;
		private var gridMask:Sprite;
		
		private var gridVerticalScrollBar:VerticalScrollBar;
		private var gridHorizontalScrollBar:HorizontalBar;
		
		private var buttonContainer:EditorButtonContainer;
		
		public function EditorGridContainer(g:EditorGrid, e:EditorButtonContainer){
			createNewGird(g);
			buttonContainer = e;
		}
		
		
		/**
		 * Creates a new grid for the container
		 */
		public function createNewGird(newGrid:EditorGrid):void {
			grid = newGrid;
			grid.x = 20;
			grid.y = 100;
			addChild(grid);
			
			gridVerticalScrollBar = new VerticalScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			gridVerticalScrollBar.y = 100;
			addChild(gridVerticalScrollBar);
			gridHorizontalScrollBar = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(gridHorizontalScrollBar);
			
			if(gridVerticalScrollBar != null && gridHorizontalScrollBar){
				resetComponents();
			}
			grid.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_OVER, altClick, false, 0, true);
			//if(buttonContainer.ge
			//TODO: see at bottom, preview stuff
		//	grid.addEventListener(MouseEvent.MOUSE_OVER, preview, false, 0 , true);
		}
		
		/**
		 * resize the gui
		 */
		public function resize(rows:int, cols:int):void {
			grid.resize(rows, cols);
			resetComponents();
		}
		
		/**
		 * get the grid
		 */
		public function getGrid():EditorGrid {
			return grid;
		}
		
		/**
		 * recreate the guis based on the new grid
		 */
		public function resetComponents():void{
			//adding back mask, scrollbar, and listeners for undo grid
			gridMask = new Sprite();
			gridMask.graphics.beginFill(0);
			var scale:Number = Aeon.getMe().scaleX;
			gridMask.graphics.drawRect(0,0,scale * 550,scale * 370);
			gridMask.graphics.endFill();
			gridMask.x = 20;
			gridMask.y = 100;
			grid.mask = gridMask;
			gridVerticalScrollBar.setPosition(0);
			removeChild(gridVerticalScrollBar);
			removeChild(gridHorizontalScrollBar);
			gridVerticalScrollBar = new VerticalScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			gridVerticalScrollBar.y = 100;
			addChild(gridVerticalScrollBar);
			gridHorizontalScrollBar = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(gridHorizontalScrollBar);
		}
		
		/**
		 * 	Event Listeners Section
		 *
		 */
		public function altClick(e:MouseEvent):void {
			var cell:EditorCell=EditorCell(e.target);

			if (e.altKey) {
				//switch to check what trigger is active
				if(buttonContainer.getActiveButton() == '#' && buttonContainer.isPlayerSpawn() == false){
					cell.setTile(buttonContainer.getActiveButton());
					buttonContainer.setPlayerSpawn(true);
				}
				else if(buttonContainer.getActiveButton() != '#'){
					cell.setTile(buttonContainer.getActiveButton());
				}
			}
		}
		
		/**
		 * event listener for left clicking
		 */
		public function leftClick(e:MouseEvent):void {
			var cell:EditorCell=EditorCell(e.target);
			
			//next two lines are the start to box selection
			//TODO: FIGURE OUT BOX SELECTION
			//var box:DrawBox = new DrawBox(grid, e.stageX, e.stageY);
			//this.addChild(box);
			//switch to check what trigger is active
			if (e.ctrlKey) {
				if(cell.cellName == '#'){
					buttonContainer.setPlayerSpawn(false);
				}
				cell.clearTile();
			} else {
				if(buttonContainer.getActiveButton() == '#' && buttonContainer.isPlayerSpawn() == false){
					cell.setTile(buttonContainer.getActiveButton());
					buttonContainer.setPlayerSpawn(true);
				}
				else if(buttonContainer.getActiveButton() != '#'){
					cell.setTile(buttonContainer.getActiveButton());
				}
				
			}
		}
		//playing around with preview listeners
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
