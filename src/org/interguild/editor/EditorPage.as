package org.interguild.editor {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	
	import org.interguild.Aeon;
	import org.interguild.editor.grid.EditorLevelPane;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.game.level.LevelProgressBar;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Page {

		private static const BACKGROUND_COLOR:uint = 0x0f1d2f;
		
		private static var selectedTile:String;
		
		public static function get currentTile():String{
			return selectedTile;
		}
		
		public static function set currentTile(s:String):void{
			selectedTile = s;
			if(s == TileList.SELECTION_TOOL_CHAR){
				//do selection tool stuff
			}
		}

		private var loader:Loader;

		private var progressBar:LevelProgressBar;
		private var levelPane:EditorLevelPane;
		
		private var filereader:FileReference;
		private var keys:KeyManEditor;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(stage:Stage):void {
			initBG();

			var tileList:TileList = new TileList(this);
			addChild(tileList);

			levelPane = new EditorLevelPane(this);
			addChild(levelPane);
//			tabsContainer = new EditorTabContainer(this, tileList);
//			addChild(tabsContainer);

			loader = new EditorLoader();
			loader.addInitializedListener(levelPane.addLevel);
			loader.addErrorListener(onLoadError);

			keys = new KeyManEditor(stage);
			keys.addOpenLevelCallback(openFromFile);
			keys.addSaveLevelCallback(saveToFile);
//			keys.addUndoLevelCallback(tabsContainer.getCurrentGridContainer().undoClick);
//			keys.addRedoLevelCallback(tabsContainer.getCurrentGridContainer().redoClick);
//			keys.addDeleteLevelCallback(tabsContainer.getCurrentGridContainer().deleteTiles);

			// must be initialized last so that overlay can cover everything
			// and disable editor mouse evemts for certain menus
			var topBar:TopBar = new TopBar(this);
			addChild(topBar);
		}

		private function initBG():void {
			graphics.beginFill(BACKGROUND_COLOR);
			graphics.drawRect(0, 0, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			graphics.endFill();
		}

//		private function initOldButtons():void {
//			//undo button:
//			var undoBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
//			setBackgroundSize(undoBackground, 0, 660, 200);
//			addChild(undoBackground);
//
//			undoButton = new UndoButton();
//			setButtonSize(undoButton, 55, 665, 100, 25);
//			undoButton.addEventListener(MouseEvent.CLICK, undoClick);
//			addChild(undoButton);
//
//			//redobutton:
//			var redoBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
//			setBackgroundSize(redoBackground, 0, 725, 200);
//			addChild(redoBackground);
//
//			redoButton = new RedoButton();
//			setButtonSize(redoButton, 57, 725, 100, 25);
//			redoButton.addEventListener(MouseEvent.CLICK, redoClick);
//			addChild(redoButton);
//
//			//clear button:
//			var clearBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
//			setBackgroundSize(clearBackground, 0, 600, 200);
//			addChild(clearBackground);
//
//			clearButton = new ClearAllButton();
//			setButtonSize(clearButton, 5, 605, 200, 25);
//			clearButton.addEventListener(MouseEvent.CLICK, clearClick);
//			addChild(clearButton);
//
//			//Test button:
//			var testBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
//			setBackgroundSize(testBackground, 330, 40, 200);
//			addChild(testBackground);
//
//			testButton = new TestButton();
//			setButtonSize(testButton, 345, 42, 160, 25);
//			testButton.addEventListener(MouseEvent.CLICK, testGame);
//			addChild(testButton);
//
//			//change size button:
//			var resizeBackground:Bitmap = new Bitmap(new MenuButtonSelectBG());
//			setBackgroundSize(resizeBackground, 735, 37, 150);
//			addChild(resizeBackground);
//
//			resizeButton = new ResizeButton();
//			setButtonSize(resizeButton, 745, 37, 120, 35);
//			resizeButton.addEventListener(MouseEvent.CLICK, resizeClick);
//			addChild(resizeButton);
//		}
//
//		private function initTextFields():void {
//			//title text field
//			titlef = new TextField();
//			titlef.text = "Title:";
//			titlef.textColor = 0xFFFFFF;
//			titlef.x = 25;
//			titlef.y = 50;
//			titlef.width = 25;
//			titlef.height = 15;
//			addChild(titlef);
//
//			//width text field
//			widthf = new TextField();
//			widthf.text = "Width:";
//			widthf.textColor = 0xFFFFFF;
//			widthf.x = 625;
//			widthf.y = 35;
//			addChild(widthf);
//
//			//height text field
//			heightf = new TextField();
//			heightf.text = "Height:";
//			heightf.textColor = 0xFFFFFF;
//			heightf.x = 625;
//			heightf.y = 60;
//			addChild(heightf);
//
//			//for entering a title name
//			title = new TextInput();
//			title.width = 250;
//			title.height = 25;
//			title.x = 55;
//			title.y = 50;
//			title.text = "Level Name";
//			addChild(title);
//
//			//for entering a width and height
//			widthBox = new TextInput();
//			widthBox.width = 50;
//			widthBox.height = 25;
//			widthBox.x = 680;
//			widthBox.y = 35;
//			addChild(widthBox);
//
//			heightBox = new TextInput();
//			heightBox.width = 50;
//			heightBox.height = 25;
//			heightBox.x = 680;
//			heightBox.y = 60;
//			addChild(heightBox);
//		}

//		private function resizeClick(e:MouseEvent):void {
//			var w:Number = Number(widthBox.text);
//			var h:Number = Number(heightBox.text);
//			if (isNaN(w) || isNaN(h) || w <= 0 || h <= 0)
//				throw new Error("Invalid Level Dimensions: '" + w + "' by '" + h + "'");
//			tabsContainer.resizeCurrentGrid(h, w);
//		}
		
		public function newLevel():void{
			levelPane.addLevel();
		}

		public function saveToFile():void {
			var file:FileReference = new FileReference();
			var levelcode:String = getLevelCode();
			var filename:String = levelcode.substring(0, levelcode.indexOf("\n")) + ".txt";
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
		}

//		public function setUpEditorPage(title:String, newGrid:EditorGrid):void {
//			this.title.text = title;
//		}

		/**
		 * error found, report then return to original state
		 */
		private function onLoadError(e:Array):void {
			trace(e);
			returnFromError(e);
			//TODO display error to user
		}

		private function returnFromError(e:Array):void {
			Aeon.getMe().returnFromError(e, "Editor");
		}

		/**
		 * This function returns to the title menu
		 */
		public function gotoMainMenu():void {
			Aeon.getMe().gotoMainMenu();
		}

		/**
		 * This function ask the grid for the code of the level so we may
		 * save this code
		 */
		public function getLevelCode():String {
			var string:String = "";
//			string += this.title.text + "\n";
			string += "Untitled\n";
//			string += tabsContainer.getCurrentGridContainer().getGrid().levelHeight + "x" + tabsContainer.getCurrentGridContainer().getGrid().levelWidth + "\n";
//			string += tabsContainer.getCurrentGridContainer().getGrid().toStringCells();
			return string;
		}

		/**
		 * listener that clears the grid
		 */
		private function clearClick(e:MouseEvent):void {
//			tabsContainer.getCurrentGridContainer().getGrid().clearGrid();
		}

		/**
		 * This function deletes level editor and moves on to level page
		 */
		public function testGame(e:MouseEvent):void {
			var s:String = getLevelCode();
			Aeon.getMe().playLevelCode(s);
		}
	}
}
