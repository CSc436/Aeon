package org.interguild.menu {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import org.interguild.Aeon;
	

	/**
	 * The purpose of this class is to manage the list of levels and handle loading in level data from the database.
	 * Its size and location are handled by the LevelsPage class.
	 */
	public class LevelLister extends Sprite {
		
		private static const LEVEL_LIST_URL:String = "http://interguild.org/levels/xml.php";

		private var loader:URLLoader;
		private var loadingText:TextField;
		private var scrollpane:ScrollPane;
		private var container:Sprite;

		private var pagination:Sprite;
		private var pageBox:TextField;
		private var pageLimit:TextField;
		private var num_results:TextField;
		private var no_results:TextField;

		private var curSearch:String = "";
		private var curPage:uint;
		private var lastPage:uint;


		public function LevelLister() {
			//initialize scrollpane and container
			container = new Sprite();
			scrollpane = new ScrollPane();
			scrollpane.horizontalScrollPolicy = ScrollPolicy.OFF;
			scrollpane.verticalScrollPolicy = ScrollPolicy.AUTO;
			var mc:MovieClip = new MovieClip();
//			mc.graphics.beginFill(0x134c7d);
//			mc.graphics.drawRect(0, 0, 10, 10);
//			mc.graphics.endFill();
			scrollpane.setStyle("upSkin", mc);
			scrollpane.source = container;

			//initialize pagination
			pagination = new Sprite();

			var pageText:TextField = new TextField();
			pageText.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF, true);
			pageText.autoSize = TextFieldAutoSize.LEFT;
			pageText.text = "Page:";

			pageBox = new TextField();
			pageBox.defaultTextFormat = new TextFormat("Verdana", 13, 0, null, null, null, null, null, TextFormatAlign.CENTER);
			pageBox.type = TextFieldType.INPUT;
			pageBox.border = true;
			pageBox.backgroundColor = 0xFFFFFF;
			pageBox.background = true;
			pageBox.x = pageText.width + 4;
			pageBox.width = 24;
			pageBox.height = 20;
			pageBox.addEventListener(KeyboardEvent.KEY_DOWN, onPageBoxKey, false, 0, true);

			pageLimit = new TextField();
			pageLimit.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF, true);
			pageLimit.autoSize = TextFieldAutoSize.LEFT;
			pageLimit.text = "of 1";
			pageLimit.x = pageBox.x + pageBox.width + 4;


			//initialize results count
			num_results = new TextField();
			num_results.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			num_results.autoSize = TextFieldAutoSize.LEFT;
			num_results.text = "Results: 0";
			num_results.x = 10;

			//initialize no-results text
			no_results = new TextField();
			no_results.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			no_results.autoSize = TextFieldAutoSize.LEFT;
			no_results.text = "Your search returned zero results.";
			no_results.visible = false;

			//initialize loading text
			loadingText = new TextField();
			var loadingFormat:TextFormat = new TextFormat("Arial", 15, 0xFFFFFF);
			loadingFormat.align = TextFormatAlign.LEFT;
			loadingText.defaultTextFormat = loadingFormat;
			loadingText.autoSize = TextFieldAutoSize.LEFT;
			loadingText.x = 10;
			loadingText.text = "Loading...";
			loadingText.visible = false;
			
			//add children
			addChild(scrollpane);
			pagination.addChild(pageText);
			pagination.addChild(pageBox);
			pagination.addChild(pageLimit);
			addChild(pagination);
			addChild(num_results);
			addChild(no_results);
			addChild(loadingText);

			loader = new URLLoader();
		}


		private function onPageBoxKey(evt:KeyboardEvent):void {
			if (evt.keyCode == Keyboard.ENTER) {
				if (isNaN(Number(pageBox.text))) {
					pageBox.text = String(curPage);
				} else {
					loadList("?search=" + curSearch + "&page_number=" + pageBox.text);
				}
			}
		}


		public override function set width(newWidth:Number):void {
			scrollpane.width = newWidth;
			pagination.x = newWidth - pagination.width - 10;
			no_results.x = newWidth / 2 - no_results.width / 2;
			var num:int = container.numChildren;
			for (var i:int = 0; i < num; i++) {
				container.getChildAt(i).width = newWidth;
			}
		}


		public override function set height(newHeight:Number):void {
			scrollpane.height = newHeight - 26;
			scrollpane.y = 26;
			loadingText.y = newHeight + 10;
			no_results.y = newHeight / 2;
		}


		public function searchFor(txt:String):void {
			no_results.visible = false;
			loadList("?search=" + txt);
			curSearch = txt;
			curPage = 1;
			pageBox.text = String(1);
		}

		private function addLoaderListeners():void{
			loader.addEventListener(Event.COMPLETE, onDownloadComplete, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onDownloadError, false, 0, true);
		}
		
		private function removeLoaderListeners():void{
			loader.removeEventListener(Event.COMPLETE, onDownloadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onDownloadError);
		}

		private function loadList(txt:String = ""):void {
			addLoaderListeners();

			loadingText.text = "Loading...";
			loadingText.visible = true;

			loader.load(new URLRequest(LEVEL_LIST_URL + txt));
		}


		private function onDownloadComplete(evt:Event):void {
			clearList();
			removeLoaderListeners();

			var xml:XML = XML(loader.data);
			loadingText.visible = false;

			for each (var item:XML in xml.elements()) {
				addLevel(new LevelListItem(item, Aeon.STAGE_WIDTH - 200));
			}
			
			lastPage = uint(xml.@lastpage);
			pageLimit.text = "of " + xml.@lastpage;
			curPage = uint(xml.@curpage);
			pageBox.text = String(curPage);
			
			var num:int = int(xml.@results);
			num_results.text = "Results: " + num;
			if (num == 0)
				no_results.visible = true;
		}


		private function onDownloadError(evt:ErrorEvent):void {
			removeLoaderListeners()
			loadingText.text = "Error: URL failed to load.";
		}


		private function addLevel(level:LevelListItem):void {
			level.addEventListener(MouseEvent.CLICK, onLevelClick, false, 0, true);
			level.y = level.height * container.numChildren;
			container.addChild(level);
			scrollpane.source = container;
		}

		private function addLevelLoadListeners():void{
			loader.addEventListener(Event.COMPLETE, levelLoadComplete, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, noLevelError, false, 0, true);			
		}

		private function removeLevelLoadListeners():void{
			loader.removeEventListener(Event.COMPLETE, levelLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, noLevelError);
		}

		private function onLevelClick(evt:MouseEvent):void {
			var theID:uint = LevelListItem(evt.currentTarget).id;
			addLevelLoadListeners();
			loadingText.text = "Loading level ID #" + theID + "...";
			loadingText.visible = true;
			loader.load(new URLRequest("http://www.interguild.org/levels/xml.php?id=" + theID));
		}


		private function levelLoadComplete(event:Event):void {
			removeLevelLoadListeners()
			loadingText.visible = false;

			var levelCode:String = loader.data;
//			GamePage.instance.loadAndPlay(levelCode);
			trace(levelCode);
			Aeon.getMe().playLevelCode(levelCode);
		}


		private function noLevelError(evt:ErrorEvent):void {
			removeLevelLoadListeners();
			loadingText.text = "Error: Level failed to load.";
		}


		/**
		 * This is called whenever the LevelPage's open() method is called.
		 * It resets the list of levels to the default display.
		 */
		public function reset():void {
			clearList();
			no_results.visible = false;
			loadingText.visible = false;
			loadList();
		}


		/**
		 * Empties the list of all levels.
		 */
		public function clearList():void {
			container = new Sprite();
			scrollpane.source = container;
		}
	}
}
