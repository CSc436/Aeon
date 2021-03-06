package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.editor.help.EditorHelpScreen;
	import org.interguild.editor.levelpane.EditorLevelPane;
	import org.interguild.editor.levelprops.LevelPropertiesScreen;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.editor.topbar.TopBar;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Sprite {
		
		//public static const BACKGROUND_COLOR:uint = 0x0f1d2f;
		public static const OVERLAY_ALPHA:Number = 0.25;

		private static var selectedTile:String;
		//TODO, replace this with a simple check in the undo/redo feature
		public static var hasMadeFirstChange:Boolean = false;

		public static function get currentTile():String {
			return selectedTile;
		}

		public static function set currentTile(s:String):void {
			selectedTile = s;
		}
		
		private static var instance:EditorPage;
		
		public static function get myself():EditorPage{
			return instance;
		}

		private var loader:Loader;
		private var keys:EditorKeyMan;

		private var topBar:TopBar;
		private var levelPane:EditorLevelPane;
		private var tileList:TileList
		private var levelProps:LevelPropertiesScreen;
		private var help:EditorHelpScreen;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(stage:Stage):void {
			instance = this;
			keys = new EditorKeyMan(this, stage);

			initBG();

			tileList = new TileList(this);
			addChild(tileList);

			levelPane = new EditorLevelPane(this);
			addChild(levelPane);

			loader = new EditorLoader();
			loader.addInitializedListener(levelPane.addLevel);
			loader.addErrorListener(onLoadError);

			// these must be initialized last so that overlay can cover everything
			// and disable editor mouse evemts for certain menus

			topBar = new TopBar(this);
			addChild(topBar);

			levelProps = new LevelPropertiesScreen(keys, levelPane);
			addChild(levelProps);

			help = new EditorHelpScreen();
			addChild(help);
		}

		private var myBG:BitmapData;

		private function initBG():void {
			myBG = Assets.EDITOR_BG;
			addChild(new Bitmap(myBG));
		}

		public function getBG():BitmapData {
			return myBG;
		}

		public function newLevel():void {
			levelPane.addLevel();
			hasMadeFirstChange = true;
		}

		public function closeLevel():void {
			levelPane.closeLevel();
		}

		public function closeAllLevels():void {
			levelPane.closeAllLevels()
		}

		public function saveToFile():void {
			var file:FileReference = new FileReference();
			var levelcode:String = getLevelCode();
			var filename:String = levelcode.substring(0, levelcode.indexOf("\n")) + ".txt";
			file.save(levelcode, filename);
			hasMadeFirstChange = true;
		}

		public function openFromFile():void {
			var filereader:FileReference = new FileReference();
			filereader.addEventListener(Event.SELECT, selectHandler);
			filereader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			filereader.addEventListener(IOErrorEvent.IO_ERROR, loadCompleteHandler);
			filereader.browse(); // ask user for file

			function selectHandler(event:Event):void {
				filereader.removeEventListener(Event.SELECT, selectHandler);
				filereader.load();
			}

//			function errorHandler(evt:IOErrorEvent):void{
//				trace(evt);
//			}

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
			returnFromError(e);
		}

		private function returnFromError(e:Array):void {
			Aeon.getMe().returnFromError(e, "Editor");
		}

		public function showLevelProperties():void {
			levelProps.visible = true;
		}

		public function showHelpScreen():void {
			help.visible = true;
		}

		/**
		 * This function returns to the title menu
		 */
		public function gotoMainMenu():void {
			Aeon.getMe().gotoMainMenu();
		}

		public function copy():void {
			topBar.hideMenu();
			levelPane.level.copy();
		}

		public function cut():void {
			topBar.hideMenu();
			levelPane.level.cut();
		}

		public function paste():void {
			topBar.hideMenu();
			levelPane.level.prepareToPaste();
		}

		/**
		 * When the user presses delete when a selection is active,
		 * clear every cell in the selection.
		 */
		public function deleteSelection():void {
			topBar.hideMenu();
			levelPane.level.deleteSelection();
		}

		public function selectAll():void {
			levelPane.level.selectAll();
		}

		/**
		 * TileList notifies EditorLevel when it's time to deselect
		 */
		public function deselect():void {
			levelPane.level.deselect();
		}

		/**
		 * This function ask the grid for the code of the level so we may
		 * save this code
		 */
		private function getLevelCode():String {
			return levelPane.level.getLevelCode();
		}
		
		private function getLevelTitle():String {
			return levelPane.level.title;
		}
		
		public function publishLevel():void{
			var request:URLRequest = new URLRequest("http://www.interguild.org/levels/add.php?game=37");
			var postData:URLVariables = new URLVariables();
			postData.lvltitle = getLevelTitle();
			postData.lvlcode = getLevelCode();
			request.data = postData;
			request.method = URLRequestMethod.POST;
			navigateToURL(request, "_blank");
		}

		/**
		 * When spacebar is pressed, allow user to click-and-drag to scroll
		 * through the level.
		 */
		public function set handToolEnabled(b:Boolean):void {
			if (b) {
				Mouse.cursor = MouseCursor.HAND;
			} else {
				Mouse.cursor = MouseCursor.AUTO;
			}
			levelPane.handToolEnabled = b;
			tileList.handToolEnabled = b;
		}

		/**
		 * This function deletes level editor and moves on to level page
		 */
		public function playLevel():void {
			Aeon.getMe().playLevelCode(getLevelCode());
		}

		public function undo():void {
			levelPane.undo();
		}

		public function redo():void {
			levelPane.redo();
		}

		public function zoomIn():void {
			levelPane.zoom(true);
		}

		public function zoomOut():void {
			levelPane.zoom(false);
		}

		public function enableRedo():void {
			topBar.enableRedo();
		}

		public function enableUndo():void {
			topBar.enableUndo();
		}
		public function disableRedo():void {
			topBar.disableRedo();
		}

		public function disableUndo():void {
			topBar.disableUndo();
		}

		public function disableZoomIn():void {
			topBar.disableZoomIn();
		}

		public function disableZoomOut():void {
			topBar.disableZoomOut();
		}

		public function enableZoomIn():void {
			topBar.enableZoomIn();
		}

		public function enableZoomOut():void {
			topBar.enableZoomOut();
		}
		
		public function hasInitialized():Boolean{
			if(topBar)
				return true;
			return false;
		}

		/**
		 * When Esc is pressed, open the file menu, so that the
		 * user sees how to leave the level editor.
		 */
		public function toggleMenu():void {
			topBar.toggleMenu();
		}

		public override function set visible(b:Boolean):void {
			super.visible = b;
			if (!b) {
				deselect();
				keys.deactivate();
			} else {
				keys.activate();
			}
		}
	}
}
