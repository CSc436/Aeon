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

		public function newLevel():void{
			levelPane.addLevel();
		}
		
		public function closeLevel():void{
			levelPane.closeLevel();
		}
		
		public function closeAllLevels():void{
			levelPane.closeAllLevels()
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
			loader.loadFromCode(data, "Editor");
		}

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
		
		public function copy():void{
			levelPane.level.copy();
		}
		
		public function cut():void{
			levelPane.level.cut();
		}
		
		/**
		 * TileList notifies EditorLevel when it's time to deselect
		 */
		public function deselect():void{
			levelPane.level.deselect();
		}

		/**
		 * This function ask the grid for the code of the level so we may
		 * save this code
		 */
		public function getLevelCode():String {
			return levelPane.level.getLevelCode();
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
