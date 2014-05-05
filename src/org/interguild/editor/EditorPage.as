package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	
	import fl.controls.Button;
	import fl.controls.TextInput;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.level.LevelProgressBar;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Page {

		private static const BACKGROUND_COLOR:uint = 0x0f1d2f;

		//following are objects on this sprite
		private var testButton:TestButton;
		private var resizeButton:ResizeButton;
		private var widthBox:TextInput;
		private var heightBox:TextInput;
		private var titlef:TextField;
		private var widthf:TextField;
		private var heightf:TextField;
		private var title:TextInput;

		private var loader:Loader;
		private var gridContainer:Sprite;
		private var tabsContainer:EditorTabContainer;

		private var clearButton:ClearAllButton;
		private var undoButton:UndoButton;
		private var redoButton:RedoButton;
		// UNDO REDO ACTIONS ARRAYLIST
		private var undoList:Array;
		private var redoList:Array;

		private var progressBar:LevelProgressBar;

		//variable to hold level code if coming back from test level
		private var currentLevel:String;

		private var filereader:FileReference;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage():void {
			undoList = new Array();
			redoList = new Array();

			initBG();
			//initOldButtons();
			//initTextFields();

//			editorButtons = new EditorButtonContainer();
//			addChild(editorButtons);
			var tileList:TileList = new TileList();
			addChild(tileList);
			
			tabsContainer = new EditorTabContainer(tileList);
			addChild(tabsContainer);
			addChild(tabsContainer.getCurrentGridContainer());

			loader = new EditorLoader();
			loader.addInitializedListener(tabsContainer.addTab);
			loader.addErrorListener(onLoadError);
			
			//must be initialized last
			var topBar:TopBar = new TopBar(this);
			addChild(topBar);
		}

		private function initBG():void {
			graphics.beginFill(BACKGROUND_COLOR);
			graphics.drawRect(0, 0, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			graphics.endFill();
		}

		private function initOldButtons():void {
			//undo button:
			var undoBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(undoBackground, 0, 660, 200);
			addChild(undoBackground);

			undoButton = new UndoButton();
			setButtonSize(undoButton, 55, 665, 100, 25);
			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
			addChild(undoButton);

			//redobutton:
			var redoBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(redoBackground, 0, 725, 200);
			addChild(redoBackground);

			redoButton = new RedoButton();
			setButtonSize(redoButton, 57, 725, 100, 25);
			redoButton.addEventListener(MouseEvent.CLICK, redoClick);
			addChild(redoButton);

			//clear button:
			var clearBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(clearBackground, 0, 600, 200);
			addChild(clearBackground);

			clearButton = new ClearAllButton();
			setButtonSize(clearButton, 5, 605, 200, 25);
			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
			addChild(clearButton);

			//Test button:
			var testBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(testBackground, 330, 40, 200);
			addChild(testBackground);

			testButton = new TestButton();
			setButtonSize(testButton, 345, 42, 160, 25);
			testButton.addEventListener(MouseEvent.CLICK, testGame);
			addChild(testButton);

			//change size button:
			var resizeBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
			setBackgroundSize(resizeBackground, 735, 37, 150);
			addChild(resizeBackground);

			resizeButton = new ResizeButton();
			setButtonSize(resizeButton, 745, 37, 120, 35);
			resizeButton.addEventListener(MouseEvent.CLICK, resizeClick);
			addChild(resizeButton);
		}

		private function initTextFields():void {
			//title text field
			titlef = new TextField();
			titlef.text = "Title:";
			titlef.textColor = 0xFFFFFF;
			titlef.x = 25;
			titlef.y = 50;
			titlef.width = 25;
			titlef.height = 15;
			addChild(titlef);

			//width text field
			widthf = new TextField();
			widthf.text = "Width:";
			widthf.textColor = 0xFFFFFF;
			widthf.x = 625;
			widthf.y = 35;
			addChild(widthf);

			//height text field
			heightf = new TextField();
			heightf.text = "Height:";
			heightf.textColor = 0xFFFFFF;
			heightf.x = 625;
			heightf.y = 60;
			addChild(heightf);

			//for entering a title name
			title = new TextInput();
			title.width = 250;
			title.height = 25;
			title.x = 55;
			title.y = 50;
			title.text = "Level Name";
			addChild(title);

			//for entering a width and height
			widthBox = new TextInput();
			widthBox.width = 50;
			widthBox.height = 25;
			widthBox.x = 680;
			widthBox.y = 35;
			addChild(widthBox);

			heightBox = new TextInput();
			heightBox.width = 50;
			heightBox.height = 25;
			heightBox.x = 680;
			heightBox.y = 60;
			addChild(heightBox);
		}

		private function resizeClick(e:MouseEvent):void {
			var w:Number = Number(widthBox.text);
			var h:Number = Number(heightBox.text);
			if (isNaN(w) || isNaN(h) || w <= 0 || h <= 0)
				throw new Error("Invalid Level Dimensions: '" + w + "' by '" + h + "'");
			tabsContainer.resizeCurrentGrid(h, w);
		}
		
		private function saveToFile():void{
			var file:FileReference = new FileReference();
			var levelcode:String = getLevelCode();
			var filename:String = levelcode.substring(0,levelcode.indexOf("\n")) + ".txt";
			file.save(levelcode, filename);
		}

		public function openFromFile():void {
			filereader = new FileReference();
			filereader.addEventListener(Event.SELECT, selectHandler);
			filereader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			filereader.browse(); // ask user for file
			
			function selectHandler(event:Event):void {
				filereader.removeEventListener(Event.SELECT, selectHandler);
				filereader.load();
			}
			
			function loadCompleteHandler(event:Event):void {
				filereader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				var lvlCode:String = (String(filereader.data)).split("\r").join("");
				openLevel(lvlCode);
			}
		}
		
		/**
		 * We have the level data use that so we can
		 * create a level
		 */
		public function openLevel(data:String):void {
			trace(data);
			loader.loadFromCode(data, "Editor");
			//adding in mask and new scrollbar
//			resetComponents();
		}

		public function setUpEditorPage(title:String, newGrid:EditorGrid):void {
			this.title.text = title;
//			createNewGird(newGrid);

		}

		/**
		 * error found, report then return to original state
		 */
		private function onLoadError(e:ArrayList):void {
			trace(e);
			returnFromError(e);
			//TODO display error to user
		}

		private function returnFromError(e:ArrayList):void {
			Aeon.getMe().returnFromError(e, "Editor");
		}

		/**
		 * Helps populate the sprite by setting up buttons
		 *
		 * @param   index
		 * @param   row
		 * @param   column
		 */
		private function makeButton(label:String, image:Class, xpixel:int, ypixel:int):Button {
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
			string += this.title.text + "\n";
			string += tabsContainer.getCurrentGrid().levelHeight + "x" + tabsContainer.getCurrentGrid().levelWidth + "\n";
			string += tabsContainer.getCurrentGrid().toStringCells();
			return string;
		}

		/**
		 * listener that clears the grid
		 */
		private function clearClick(e:MouseEvent):void {
			tabsContainer.getCurrentGrid().clearGrid();
		}

		/**
		 * This function deletes level editor and moves on to level page
		 */
		public function testGame(e:MouseEvent):void {
			var s:String = getLevelCode();
			Aeon.getMe().playLevelCode(s);
		}

		/**
		 * listener for undo button
		 */
		private function undoClick(e:MouseEvent):void {
			//this function takes from the undo stack and puts it back on the grid
			if (undoList.length > 0) {
				var popped:EditorGrid = undoList.pop();
				redoList.push(tabsContainer.getCurrentGrid().clone());
				tabsContainer.setCurrentGridContainer(popped);
			}
		}

		/**
		 * listener for redo button
		 */
		private function redoClick(e:MouseEvent):void {
			if (redoList.length > 0) {
				var popped:EditorGrid = redoList.pop();
				undoList.push(tabsContainer.getCurrentGrid().clone());
				tabsContainer.setCurrentGridContainer(popped);
			}
		}

	}
}
