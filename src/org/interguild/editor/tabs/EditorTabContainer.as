package org.interguild.editor.tabs {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.editor.grid.EditorGrid;
	import org.interguild.editor.grid.EditorGridContainer;
	import org.interguild.editor.EditorPage;

	/**
	 * Store mltiple instances of Editor Page such that the user
	 */
	public class EditorTabContainer extends Sprite {
		private static const DEFAULT_LEVEL_WIDTH:uint = 30;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 30;
		private static const MAX_ARRAY_SIZE:uint = 3;

		private var gridArray:Array; // of EditorGrids
		private var tabButton:Array; // of TabSprites
		private var tabText:Array; // of textFields
		private var tabOpen:TabOpenButton;

		private var currTab:int;
		private var currGrid:EditorGrid;
		private var tabsActive:int = 0;
		private var buttonContainer:TileList;
		private var currGridContainer:EditorGridContainer;
		private var page:EditorPage;

		public function EditorTabContainer(gridContainer:EditorGridContainer, p:EditorPage, buttonContainer:TileList) {
			this.currGridContainer = gridContainer;
			this.page = p;
			this.buttonContainer = buttonContainer;
			gridArray = new Array(MAX_ARRAY_SIZE);

			//create 5 pictures and 5 text fields for each button
			tabButton = new Array(MAX_ARRAY_SIZE);
			tabText = new Array(MAX_ARRAY_SIZE);
			for (var i:int = 0, width:int = 3; i < MAX_ARRAY_SIZE; i++, width += 134) {
				// preset the text for each tab
				tabText[i] = new TextField();
				tabText[i].text = "Grid " + i;
				tabText[i].y = 60;

				//place tab
				tabButton[i] = new TabButton("Untitled", i, this);
				tabButton[i].x = width;
				tabButton[i].y = 60;
				tabButton[i].addEventListener(MouseEvent.CLICK, switchClick);
			}
			
			//create one new tab button
			tabOpen = new TabOpenButton();
			tabOpen.x = 470;
			tabOpen.y = 50;
			tabOpen.addEventListener(MouseEvent.CLICK, addClick);
//			tabOpen.width = 100;
//			tabOpen.height = 35;
			addChild(tabOpen);

			tabsActive = 0;
			currTab = 0;
			addTab();
		}

		/**
		 * add a new tab with a new grid
		 */
		public function addTab(grid:EditorGrid = null):void {
			if (tabsActive == MAX_ARRAY_SIZE)
				return; // cannot add more than 3 tabs

			if (grid == null) {
				gridArray[tabsActive] = new EditorGrid(DEFAULT_LEVEL_HEIGHT, DEFAULT_LEVEL_WIDTH);
			} else {
				gridArray[tabsActive] = grid;
			}
			currGridContainer.setCurrentGrid(gridArray[tabsActive]);
			
			switchTabs(tabsActive);
			
			currTab = tabsActive;
			tabsActive++;
		}

		/**
		 * remove tab at position i
		 */
		public function removeTab(i:int):void {
			if (tabsActive == 1)
				return; // cannot remove if there is only one tab

			//remember if the current tab is being removed
			var b:int = 0;
			if (currTab == i)
				b = 1;

			//create a new array without the ith tab
			var gridArrayLocal:Array = new Array(MAX_ARRAY_SIZE);
			for (var j:int = 0, count:int = 0; j < MAX_ARRAY_SIZE; j++, count++) {
				if (count == i) {
					count--; // if count is i then remove it from the new array
				} else {
					gridArrayLocal[count] = gridArray[j];
				}
			}
			//set the new array
			gridArray = gridArrayLocal;

			// the active tab was removed change the view so it is not the removed tab
			if (b == 1)
				switchTabs(0);

			tabsActive--;
			removeChild(tabButton[i]);
		}

		/**
		 * switches the currently active tab with the new one
		 */
		public function switchTabs(tabNumber:int):void {
			var eg2:EditorGrid = gridArray[tabNumber];
			// TODO hide eg1 and show eg2
			
			//deactivate current tab
			var tab_:TabButton = tabButton[currTab];
			if(tab_ != null)
				tab_.deactivate();
			//activate next tab
			currTab = tabNumber;
			tab_ = tabButton[tabNumber];
			
			tab_.activate();
			addChild(tab_);
		}

		public function getCurrentGrid():EditorGrid {
			return gridArray[currTab];
		}

		/**
		 * set the current grid to the current one
		 */
		public function setCurrentGridContainer(setGrid:EditorGrid):void {
			gridArray[currTab] = setGrid;
		}

		public function resizeCurrentGrid(rows:int, cols:int):void {
			var g:EditorGrid = gridArray[tabsActive - 1];
			g.resize(rows, cols);
		}

		/**
		 * listener for tab buttons
		 */
		private function addClick(e:MouseEvent):void {
			//this function creates a new tab
			addTab();
		}

		private function switchClick(e:MouseEvent):void {
			// when the user clicks the tab they should switch to that tab
			var b:TabButton = TabButton(e.currentTarget);
			trace("switching to tab " + b.tabNum);
			switchTabs(b.tabNum);
			var g:EditorGrid = getCurrentGrid();
			page.setGrid(g);
		}
	}
}

