package org.interguild.editor {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.interguild.editor.EditorGrid;
	import org.interguild.editor.tilelist.TileList;

	/**
	 * Store mltiple instances of Editor Page such that the user
	 */
	public class EditorTabContainer extends Sprite {
		private static const DEFAULT_LEVEL_WIDTH:uint=15;
		private static const DEFAULT_LEVEL_HEIGHT:uint=15;
		private static const MAX_ARRAY_SIZE:uint=5;

		private var gridContainer:Array; // of EditorGridContainers
		private var tabButton:Array; // of TabSprites
		private var tabText:Array; // of textFields
		private var tabClose:Array; // of buttons to close the current tab
		private var tabOpen:TabOpenButton;
		
		private var currTab:int;	
		private var currGrid:EditorGrid;
		private var tabsActive:int=0;
		private var buttonContainer:TileList;

		public function EditorTabContainer(buttonContainer:TileList) {
			this.buttonContainer = buttonContainer;
			gridContainer=new Array(MAX_ARRAY_SIZE);
			
			//create 5 pictures and 5 text fields for each button
			tabButton=new Array(MAX_ARRAY_SIZE);
			tabText=new Array(MAX_ARRAY_SIZE);
			tabClose=new Array(MAX_ARRAY_SIZE);
			for (var i:int=0, width:int = 19; i < MAX_ARRAY_SIZE; i++, width+=85) {
				// preset the text for each tab
				tabText[i]=new TextField();
				tabText[i].text="Grid " + i;
				tabText[i].y = 65;
				
				//place tab
				tabButton[i]=new TabButton();
				tabButton[i].x = width;
				tabButton[i].y = 65;
				tabButton[i].width = 100;
				tabButton[i].height = 35;
				tabButton[i].tabNum = i; // set their number
				tabButton[i].addEventListener(MouseEvent.CLICK, switchClick);
				
				//place the close for each button
				tabClose[i] = new TabCloseButton();
				tabClose[i].x = width+50;
				tabClose[i].y = 65;
				tabClose[i].tabNum = i; // set their number
				tabClose[i].addEventListener(MouseEvent.CLICK, removeClick);
				
			}
			//create one new tab button
			tabOpen = new TabOpenButton();
			tabOpen.x = 470;
			tabOpen.y = 65;
			tabOpen.addEventListener(MouseEvent.CLICK, addClick);
//			tabOpen.width = 100;
//			tabOpen.height = 35;
			addChild(tabOpen);
			
			tabsActive=0;
			currTab=0;
			addTab();
		}

		/**
		 * add a new tab with a new grid
		 */
		public function addTab(grid:EditorGrid = null):void {
			if (tabsActive == MAX_ARRAY_SIZE)
				return; // cannot add more than 5 tabs
			
			if(grid == null){
			gridContainer[tabsActive]=new EditorGridContainer(new EditorGrid(DEFAULT_LEVEL_HEIGHT, DEFAULT_LEVEL_WIDTH), buttonContainer); //default 15x15
			}else{
				gridContainer[tabsActive]=new EditorGridContainer(grid, buttonContainer); //default 15x15
			}
			
			addChild(tabButton[tabsActive]);
			addChild(tabClose[tabsActive]);
			
			tabsActive++;
		}

		/**
		 * remove tab at position i
		 */
		public function removeTab(i:int):void {
			if (tabsActive == 1)
				return; // cannot remove if there is only one tab

			//remember if the current tab is being removed
			var b:int=0;
			if (currTab == i)
				b=1;
			
			//create a new array without the ith tab
			var garray:Array=new Array(MAX_ARRAY_SIZE);
			for (var j:int=0, count:int=0; j < MAX_ARRAY_SIZE; j++, count++) {
				if (count == i) {
					count--; // if count is i then remove it from the new array
				} else {
					garray[count]=gridContainer[j];
				}
			}
			//set the new array
			gridContainer=garray;

			// the active tab was removed change the view so it is not the removed tab
			if (b == 1)
				switchTabs(0);

			tabsActive--;
			//TODO update gui
			removeChild(tabButton[i]);
			removeChild(tabClose[i]);
		}

		/**
		 * switches the currently active tab with the new one
		 */
		public function switchTabs(tabNumber:int):void {
			var eg2:EditorGridContainer=gridContainer[tabNumber];
			// TODO hide eg1 and show eg2

			currTab=tabNumber;
			currGrid = eg2.getGrid();
			
			//TODO tell editorpage to update the grid sprite
		}
		
		/**
		 * return the current tabbed grid
		 */
		public function getCurrentGridContainer():EditorGridContainer {
			return gridContainer[currTab];
		}
		
		public function getCurrentGrid():EditorGrid{
			var e:EditorGridContainer = gridContainer[currTab];
			return currGrid;
		}
		
		/**
		 * set the current grid to the current one
		 */
		public function setCurrentGridContainer(setGrid:EditorGrid):void {
			gridContainer[currTab] = setGrid;
		}
		
		public function resizeCurrentGrid(rows:int, cols:int):void {
			var g:EditorGridContainer = gridContainer[tabsActive-1];
			g.resize(rows, cols);
		}
		
		/**
		 * listener for tab buttons
		 */
		private function addClick(e:MouseEvent):void {
			//this function creates a new tab
			addTab();
		}
		private function removeClick(e:MouseEvent):void {
			//this function removes the button of interest
			var b:TabCloseButton = TabCloseButton(e.target);
			this.removeTab(b.tabNum);
		}
		
		private function switchClick(e:MouseEvent):void {
			// when the user clicks the tab they should switch to that tab
			var b:TabButton = TabButton(e.target);
			trace("switching to tab "+b.tabNum);
			switchTabs(b.tabNum);
		}
	}
}

