package org.interguild.editor {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import org.interguild.Aeon;
	import org.interguild.editor.levelpane.EditorLevelPane;
	import org.interguild.editor.tilelist.TileList;
	import org.interguild.editor.topbar.TopBar;
	import org.interguild.loader.EditorLoader;
	import org.interguild.loader.Loader;

	// EditorPage handles all the initialization for the level editor gui and more
	public class EditorPage extends Sprite {

		public static const BACKGROUND_COLOR:uint = 0x0f1d2f;
		
		private static const HINT_FONT:String = "Verdana";
		private static const HINT_SIZE:Number = 12;
		private static const HINT_COLOR:uint = 0xFFFFFF;

		private static var selectedTile:String;
		//TODO, replace this with a simple check in the undo/redo feature
		public static var hasMadeFirstChange:Boolean = false;

		public static function get currentTile():String {
			return selectedTile;
		}

		public static function set currentTile(s:String):void {
			selectedTile = s;
		}

		private var loader:Loader;
		private var keys:EditorKeyMan;

		private var topBar:TopBar;
		private var levelPane:EditorLevelPane;
		private var tileList:TileList
		private var hint:TextField;
		private var levelProps:LevelPropertiesScreen;

		/**
		 * Creates grid holder and populates it with objects.
		 */
		public function EditorPage(stage:Stage):void {
			keys = new EditorKeyMan(this, stage);

			initBG();

			tileList = new TileList(this);
			addChild(tileList);

			levelPane = new EditorLevelPane(this);
			addChild(levelPane);
			
			initHintText();

			loader = new EditorLoader();
			loader.addInitializedListener(levelPane.addLevel);
			loader.addErrorListener(onLoadError);

			// these must be initialized last so that overlay can cover everything
			// and disable editor mouse evemts for certain menus
			
			topBar = new TopBar(this);
			addChild(topBar);
			
			levelProps = new LevelPropertiesScreen(keys);
			addChild(levelProps);
		}

		private function initBG():void {
			graphics.beginFill(BACKGROUND_COLOR);
			graphics.drawRect(0, 0, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			graphics.endFill();
		}
		
		private function initHintText():void{
			var tip:TextField = new TextField();
			tip.autoSize = TextFieldAutoSize.LEFT;
			tip.defaultTextFormat = new TextFormat(HINT_FONT, HINT_SIZE, HINT_COLOR, true, true);
			tip.selectable = false;
			tip.text = "Tip: ";
			tip.y = Aeon.STAGE_HEIGHT - tip.height - 1;
			tip.x = 2;
			addChild(tip);
			
			hint = new TextField();
			hint.autoSize = TextFieldAutoSize.LEFT;
			hint.defaultTextFormat = new TextFormat(HINT_FONT, HINT_SIZE, HINT_COLOR);
			hint.selectable = false;
			hint.y = tip.y;
			hint.x = tip.x + tip.width;
			hint.text = Hints.HINT_SHIFT_DRAWING;
			addChild(hint);
		}
		
		public function set hintText(s:String):void{
			hint.text = s;
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
			returnFromError(e);
		}

		private function returnFromError(e:Array):void {
			Aeon.getMe().returnFromError(e, "Editor");
		}
		
		public function showLevelProperties():void{
			levelProps.visible = true;
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
			hintText = Hints.HINT_SHIFT_PASTE;
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
		
		/**
		 * When spacebar is pressed, allow user to click-and-drag to scroll
		 * through the level.
		 */
		public function set handToolEnabled(b:Boolean):void{
			if(b){
				Mouse.cursor = MouseCursor.HAND;
			}else{
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
			topBar.hideMenu();
			trace("TODO");
		}

		public function redo():void {
			topBar.hideMenu();
			trace("TODO");
		}
		
		public function zoomIn():void{
			levelPane.zoom(true);
		}
		
		public function zoomOut():void{
			levelPane.zoom(false);
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
