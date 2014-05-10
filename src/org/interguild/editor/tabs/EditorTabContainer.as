package org.interguild.editor.tabs {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.interguild.editor.EditorPage;
	import org.interguild.editor.grid.EditorGrid;
	import org.interguild.editor.grid.EditorGridContainer;
	import org.interguild.editor.tilelist.TileList;

	/**
	 * Store mltiple instances of Editor Page such that the user
	 */
	public class EditorTabContainer extends Sprite {
		private static const DEFAULT_LEVEL_WIDTH:uint = 30;
		private static const DEFAULT_LEVEL_HEIGHT:uint = 30;
		private static const MAX_ARRAY_SIZE:uint = 3;

		private var gridContainerArray:Array; // of EditorGridContainer
		private var tabButton:Array; // of TabSprites

		private var currTab:int = 0;
		private var tabsActive:int = 0;
		private var currGrid:EditorGrid;
		private var tabOpen:TabOpenButton;
		private var buttonContainer:TileList;
		private var page:EditorPage;

		public function EditorTabContainer(p:EditorPage, buttonContainer:TileList) {
			this.page = p;
			this.buttonContainer = buttonContainer;

			//create some pictures and some text fields for each button
			tabButton = new Array(MAX_ARRAY_SIZE);
			gridContainerArray = new Array(MAX_ARRAY_SIZE);
			for (var i:int = 0, width:int = 3; i < MAX_ARRAY_SIZE; i++, width += 134) {
				// create some editorcontainers
				gridContainerArray[i] = new EditorGridContainer(buttonContainer);

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
			tabOpen.width = 100;
			tabOpen.height = 35;
			addChild(tabOpen);
			
			addTab();
		}

		/**
		 * add a new tab with a new grid
		 */
		public function addTab(grid:EditorGrid = null):void {
			if (tabsActive == MAX_ARRAY_SIZE)
				return; // cannot add more than 3 tabs

			if (grid == null) {
				//create a new game
				gridContainerArray[tabsActive].setCurrentGrid(new EditorGrid(DEFAULT_LEVEL_HEIGHT, DEFAULT_LEVEL_WIDTH));
			} else {
				//set the new game
				gridContainerArray[tabsActive] = grid;
			}
			
			//add the tab to this
			addChild(tabButton[tabsActive]);
			
			//add the editorContainer to this
			switchTabs(tabsActive);
			
			tabsActive++;
		}

		/**
		 * remove tab at position i
		 */
		public function removeTab(i:int):void {
			trace("removeTab "+i);
			if (tabsActive == 1)
				return; // cannot remove if there is only one tab

			//remember if the current tab is being removed
			var b:int=0;
			if (currTab == i)
				b=1;

			//create a new array without the ith tab
			var gridArrayLocal:Array=new Array(MAX_ARRAY_SIZE);
			for (var j:int=0, count:int=0; j < MAX_ARRAY_SIZE; j++, count++) {
				if (count == i) {
					count--; // if count is i then remove it from the new array
				} else {
					gridArrayLocal[count] = gridContainerArray[j];
				}
			}
			//set the new array
			gridContainerArray[i] = gridArrayLocal;
			
			for (var k:int=0; k < MAX_ARRAY_SIZE; k++) {
				this.tabButton[k].tabNum = k;
			}

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
			//deactivate current tab
			tabButton[currTab].deactivate();
			
			if(tabsActive != 0) { // if there exist a grid already
				removeChild(this.gridContainerArray[currTab]);
				trace ("removing grid "+currTab+ " tabs active "+tabsActive);
			}
			
			//activate next tab
			currTab = tabNumber;
			tabButton[currTab].activate();
			
			buttonContainer.addContainer(gridContainerArray[currTab]);
			addChild(this.gridContainerArray[currTab]);
			
//			page.setGrid(this.gridContainerArray[currTab]);
		}

		public function getCurrentGridContainer():EditorGridContainer {
			return gridContainerArray[currTab];
		}

		/**
		 * set the current grid to the current one
		 */
		public function setCurrentGridContainer(setGrid:EditorGrid):void {
			gridContainerArray[currTab] = setGrid;
		}

		public function resizeCurrentGrid(rows:int, cols:int):void {
			var g:EditorGrid = gridContainerArray[tabsActive - 1];
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
		}
	}
}

