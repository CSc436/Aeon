package org.interguild.editor {
	import flash.display.Sprite;
	
	import org.interguild.editor.EditorGrid;
	
	//TODO get a list of EditorPages working with tabs
	/**
	 * Store mltiple instances of Editor Page such that the user
	 */
	public class EditorTab extends Sprite {
		
		private var gridState:Array;// of EditorGrids
		private var currTab:int;
		private var tabsActive:int = 0;
		private static const MAX_ARRAY_SIZE:uint = 5;
		
		public function EditorTab() {
			gridState = new Array(MAX_ARRAY_SIZE);
			addTab();
			tabsActive = 1;
			currTab = 0;
		}
		
		/**
		 * add a new tab with a new grid
		 */
		public function addTab():void{
			if(tabsActive == MAX_ARRAY_SIZE)
				return; // cannot add more than 5 tabs
			gridState[tabsActive] = new EditorGrid(15,15); //default 15x15
			tabsActive++;
		}
		
		/**
		 * remove tab at position i
		 */
		public function removeTab(i:int):void{
			if (tabsActive == 1)
				return; // cannot remove if there is only one tab
			
			//remember if the current tab is being removed
			var b:int = 0;
			if(currTab == i)
				b = 1;
			
			//create a new array without the ith tab
			var garray:Array = new Array(MAX_ARRAY_SIZE);
			for(var j:int = 0, count:int = 0; j < MAX_ARRAY_SIZE; j++, count++){
				if(count == i) {
					count--;// if count is i then remove it from the new array
				}else{
					garray[count] = gridState[j];	
				}
			}
			//set the new array
			gridState = garray;

			// the active tab was removed change the view so it is not the removed tab
			if (b == 1) switchTabs(0);
			
			tabsActive--;
		}
		
		/**
		 * switches the currently active tab with the new one
		 */
		public function switchTabs(tabNumber:int):void{
			var eg1:EditorGrid = gridState[currTab];
			var eg2:EditorGrid = gridState[tabNumber];
			// TODO hide eg1 and show eg2
			
		}
		
		/**
		 * return the current tabbed grid 
		 */
		public function getCurrentGrid():EditorGrid{
			return gridState[tabsActive-1];
		}
	}
}

