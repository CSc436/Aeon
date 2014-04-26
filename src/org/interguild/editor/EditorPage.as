package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.editor.scrollBar.FullScreenScrollBar;
	import org.interguild.editor.scrollBar.HorizontalBar;
	import org.interguild.game.level.LevelProgressBar;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Page {
		//following are objects on this sprite
		private var testButton:TestButton;
		private var resizeButton:ResizeButton;
		private var tf:Sprite;
		private var widthBox:TextInput;
		private var heightBox:TextInput;
		private var titlef:TextField;
		private var widthf:TextField;
		private var heightf:TextField;
		private var title:TextInput;
		
		private var loader:Loader;
		private var gridContainer:Sprite;
		private var gridMask:Sprite;
		private var editorButtons:EditorButtonContainer;
		private var tab:EditorTab;
		private var dropDown:DropDownMenu;
		
		private var undoButton:UndoButton;
		private var redoButton:RedoButton;
		// UNDO REDO ACTIONS ARRAYLIST
		private var undoList:Array;
		private var redoList:Array;

		private var mainMenu:Aeon;

		private var progressBar:LevelProgressBar;
		
		private var scrollBar:FullScreenScrollBar;
		private var scroll:HorizontalBar;


		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(mainMenu:Aeon):void {
			this.mainMenu = mainMenu;
			
			undoList = new Array();
			redoList = new Array();
			
			//undo button:
			var undoBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(undoBackground, 0, 660, 200);
			undoButton=new UndoButton();
			setButtonSize(undoButton, 55, 665, 100, 25);
			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
			//redobutton:
			var redoBackground:Bitmap=new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(redoBackground, 0, 725, 200);
			redoButton=new RedoButton();
			setButtonSize(redoButton, 57, 725, 100, 25);
			redoButton.addEventListener(MouseEvent.CLICK, redoClick);
		
			//Test button:
			var testBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(testBackground, 330,40, 200);
			testButton = new TestButton();
			setButtonSize(testButton, 345,42,160,25);
			testButton.addEventListener(MouseEvent.CLICK, testGameButtonClick);
			/* Buttons to add to the branch
			ClearAllButton
			RedoButton
			ResizeButton
			TestButton
			UndoButton
			
			//editor tiles
			ArrowDownButton
			ArrowUpBotton
			ArrowRightButton
			ArrowLeftButton
			CollectableButton
			FinishLineButton
			StartLineButton
			SteelBoxButton
			WoodBoxButton
			TerrainBoxButton
			*/
			//change size button:
			var resizeBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(resizeBackground, 735,37,150);
			resizeButton = new ResizeButton();
			setButtonSize(resizeButton, 745,37, 120, 35);
			resizeButton.addEventListener(MouseEvent.CLICK, resizeClick);

			//title text field
			titlef = new TextField();
			titlef.text = "Title:";
			titlef.textColor = 0xFFFFFF;
			titlef.x = 25;
			titlef.y = 50;
			//width text field
			widthf = new TextField();
			widthf.text = "Width:";
			widthf.textColor = 0xFFFFFF;
			widthf.x = 625;
			widthf.y = 35;
			//height text field
			heightf = new TextField();
			heightf.text = "Height:";
			heightf.textColor = 0xFFFFFF;
			heightf.x = 625;
			heightf.y = 60;
			//for entering a title name
			title = new TextInput();
			title.width = 250;
			title.height = 25;
			title.x = 55;
			title.y = 50;
			title.text = "Level Name";

			//for entering a width and height
			widthBox = new TextInput();
			widthBox.width = 50;
			widthBox.height = 25;
			widthBox.x = 680;
			widthBox.y = 35;
			heightBox = new TextInput();
			heightBox.width = 50;
			heightBox.height = 25;
			heightBox.x = 680;
			heightBox.y = 60;
			//textfield
			tf = new Sprite();
			tf.x = 625;
			tf.y = 100;
			tf.graphics.beginFill(0xFFFFFF);
			tf.graphics.drawRect(0,0, 200,1000);
			tf.graphics.endFill();
			var maskTf:Sprite = new Sprite();
			maskTf.graphics.beginFill(0);
			maskTf.graphics.drawRect(0,0,Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT-75);
			maskTf.graphics.endFill();
			maskTf.x =625;
			maskTf.y = 100;
			tf.mask = maskTf;
			//add the drop down menu
			dropDown = new DropDownMenu(this);
			dropDown.x = 5;
			dropDown.y = 5;

			tab = new EditorTab();
			newGridReady(tab.getCurrentGrid());
			
			
			var textScrollBar:FullScreenScrollBar = new FullScreenScrollBar(tf, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true,845);
			textScrollBar.y = 100;
			addChild(textScrollBar);
			addChild(resizeBackground);
			addChild(resizeButton);
			addChild(heightf);
			addChild(widthf);
			addChild(widthBox);
			addChild(heightBox);
			addChild(title);
			addChild(titlef);
			addChild(testBackground);
			addChild(testButton);
			addChild(tf);
			addChild(undoBackground);
			addChild(undoButton);
			addChild(redoBackground);
			addChild(redoButton);
			
			editorButtons = new EditorButtonContainer();
			tf.addChild(editorButtons);
			
			addChild(dropDown);
			loader = new EditorLoader();
			loader.addInitializedListener(newGridReady);
			loader.addErrorListener(onLoadError);
		}
		
		/**
		 * We have the level data use that so we can 
		 * create a level
		 */
		public function openLevel(data:String):void {
			loader.loadFromCode(data,"Editor");
			//adding in mask and new scrollbar
			resetComponents();
		}

		/**
		 * Creates a new grid for the gui
		 */
		public function newGridReady(newGrid:EditorGrid):void {
//			public function newGridReady(title:String, newGrid:EditorGrid):void {
//			this.title.text = title;
			if (grid == null) {
				removeChild(grid);
			}
			grid = newGrid;
			grid.x = 20;
			grid.y = 100;
			addChild(grid);
			resetComponents();
			grid.addEventListener(MouseEvent.CLICK, leftClick, false, 0, true);
			grid.addEventListener(MouseEvent.MOUSE_OVER, altClick, false, 0, true);
		}
	

		/**
		 * error found, report then return to original state
		 */
		private function onLoadError(e:ArrayList):void {
			trace(e);
			returnFromError(e);
			//TODO display error to user
		}
		private function returnFromError(e:ArrayList):void{
			Aeon.getMe().returnFromError(e, "Editor");
		}
		
		/**
		 * Helps populate the sprite by setting up buttons
		 *
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		private function makeButton(label:String, image:Class,xpixel:int, ypixel:int):Button {
			var b:Button = new Button();
			b.label = label;
			b.width = 50;
			b.height = 50;
			b.setStyle("icon", image);
			b.x = xpixel;
			b.y = ypixel;
			b.useHandCursor = true;
			return b;
		}

		private function resizeClick(e:MouseEvent):void {
			var w:Number = Number(widthBox.text);
			var h:Number = Number(heightBox.text);
			if (isNaN(w) || isNaN(h) || w <= 0 || h <= 0)
				throw new Error("Invalid Level Dimensions: '" + w + "' by '" + h + "'");
			grid.resize(h, w);

			//reset scrollbar
			removeChild(scrollBar);
			removeChild(scroll);
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			scrollBar.y = 100;
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
		}

		private function resetComponents():void{
			//adding back mask, scrollbar, and listeners for undo grid
			gridMask = new Sprite();
			gridMask.graphics.beginFill(0);
			gridMask.graphics.drawRect(0,0,550,370);
			gridMask.graphics.endFill();
			gridMask.x = 20;
			gridMask.y = 100;
			grid.mask = gridMask;
			removeChild(scrollBar);
			removeChild(scroll);
			scrollBar = new FullScreenScrollBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true, 580);
			scrollBar.y = 100;
			addChild(scrollBar);
			scroll = new HorizontalBar(grid, 0x222222, 0xff4400, 0x05b59a, 0xffffff, 15, 15, 4, true);
			addChild(scroll);
		}
		/**
		 * This function returns to the title menu
		 */
		public function gotoMainMenu():void {
//			deleteSelf();
//			mainMenu.initMainMenu();
			Aeon.getMe().gotoMainMenu();
		}

		/**
		 * This function ask the grid for the code of the level so we may
		 * save this code
		 */
		public function getLevelCode():String {
			var string:String = "";
			string += this.title.text+"\n";
			string += this.grid.levelHeight+"x"+grid.levelWidth+"\n";
			string += this.grid.toStringCells();
			return string;
		}

		/**
		 * This function deletes level editor and moves on to level page
		 */
		private function testGameButtonClick(e:MouseEvent):void {
			var s:String = getLevelCode();
			Aeon.getMe().playLevelCode(s);
		}
		
		public function addTabListener(e:MouseEvent):void{
//			var b:Button = new Button();
			tab.addTab();
			
			newGridReady(tab.getCurrentGrid());
		}
		/**
		 * listener for undo button
		 */
		private function undoClick(e:MouseEvent):void {
			//this function takes from the undo stack and puts it back on the grid
			if (undoList.length > 0) {
				var popped:EditorGrid=undoList.pop();
				redoList.push(grid.clone());
				newGridReady(popped);
			}
		}
		
		/**
		 * listener for redo button
		 */
		private function redoClick(e:MouseEvent):void {
			if (redoList.length > 0) {
				var popped:EditorGrid=redoList.pop();
				undoList.push(grid.clone());
				newGridReady(popped);
			}
		}
		
		/**
		 * 	Event Listeners Section
		 *
		 */
		public function altClick(e:MouseEvent):void {
			var cell:EditorCell=EditorCell(e.target);
			
			if (e.altKey) {
				undoList.push(grid.clone());
				//switch to check what trigger is active
				cell.setTile(activeButton);
			}
		}
		
		public function leftClick(e:MouseEvent):void {
			var cell:EditorCell=EditorCell(e.target);
			//TODO make undo
			undoList.push(grid.clone());
			if (e.ctrlKey) {
				cell.clearTile();
			} else {
				cell.setTile(activeButton);
			}
			
			//switch to check what trigger is active
		}
	}
}
