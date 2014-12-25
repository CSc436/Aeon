package org.interguild.menu {
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.components.SquareButton;

	/**
	 * This page allows users to browse through levels in the level database.
	 *
	 * The responsibilities of this class are to provide the basic visual elements for the page.
	 * The actual loading of the level data is handled by the LevelLister class.
	 */
	public class LevelsPage extends Sprite {

		private var title:TextField;

		private var desc:TextField;
		private static const DESC_PADDING:int = 10;

		private var search:Sprite;
		private var searchBox:TextField;
		private var levels:LevelLister;
		private var exit:SquareButton;
		private var local:SquareButton;

		private var file:FileReference;
		private var fileLoader:Loader;

		private var theStage:Stage;


		public function LevelsPage() {
			theStage = Aeon.STAGE;

			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;
			
			this.addChildAt(new Bitmap(Assets.MAIN_MENU_BG), 0);

			//initialize title text
			title = new TextField();
			var titleForm:TextFormat = new TextFormat("Arial", 30, 0xFFFFFF, true);
			titleForm.align = TextFormatAlign.CENTER;
			title.defaultTextFormat = titleForm;
			title.autoSize = TextFieldAutoSize.CENTER;
			title.text = "User Level Database";
			title.x = sw / 2 - title.width / 2;
			title.y = 10;
			addChild(title);

			//initialize description text
			desc = new TextField();
			desc.defaultTextFormat = new TextFormat("Verdana", 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			desc.autoSize = TextFieldAutoSize.CENTER;
			desc.width = sw - DESC_PADDING * 2;
			desc.multiline = true;
			desc.wordWrap = true;
			desc.htmlText = "Visit <a href=\"http://www.interguild.org\" target=\"_blank\">interguild.org</a> to rate and comment on your favorite levels!";
			desc.x = DESC_PADDING;
			desc.y = 60;
			addChild(desc);


			//initialize search area
			search = new Sprite();

			var searchText:TextField = new TextField();
			searchText.defaultTextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true);
			searchText.autoSize = TextFieldAutoSize.LEFT;
			searchText.text = "Search:";
			search.addChild(searchText);

			searchBox = new TextField();
			searchBox.defaultTextFormat = new TextFormat("Verdana", 13, 0);
			searchBox.type = TextFieldType.INPUT;
			searchBox.border = true;
			searchBox.backgroundColor = 0xFFFFFF;
			searchBox.background = true;
			searchBox.width = 200;
			searchBox.height = 20;
			searchBox.x = searchText.width + 10;
			searchBox.addEventListener(KeyboardEvent.KEY_DOWN, onSearchKey, false, 0, true);
			search.addChild(searchBox);

			search.x = sw / 2 - search.width / 2;
			search.y = desc.y + desc.height + 10;
			addChild(search);


			//initialize level list:
			levels = new LevelLister();
			levels.y = search.y + search.height + 10;
			levels.width = sw;
			levels.height = sh - levels.y - 50;
			addChild(levels);


			//initialize exit button
			exit = new SquareButton("Back to Home", 0x8f2929, 0xb73232, 0xFFFFFF, 130, 40, true);
			exit.x = sw / 2 - exit.width - 10;
			exit.y = sh - exit.height - 10;
			exit.addEventListener(MouseEvent.CLICK, onExitClick, false, 0, true);
			addChild(exit);

			//initialize local file button
			local = new SquareButton("Load Local File...", 0x8f2929, 0xb73232, 0xFFFFFF, 160, 40, true);
			local.x = sw / 2 + 10;
			local.y = sh - local.height - 10;
			local.addEventListener(MouseEvent.CLICK, onLocalClick, false, 0, true);
			addChild(local);
		}


		private function onStageResize(evt:Event):void {
			var sw:int = theStage.stageWidth;
			var sh:int = theStage.stageHeight;

			title.x = sw / 2 - title.width / 2;
			desc.width = sw - DESC_PADDING * 2;
			search.x = sw / 2 - search.width / 2;
			search.y = desc.y + desc.height + 10;

			levels.y = search.y + search.height + 30;
			levels.x = 100;
			levels.width = sw - 200;
			levels.height = sh - levels.y - 80;

			exit.x = sw / 2 - exit.width - 10;
			exit.y = sh - exit.height - 20;
			local.x = sw / 2 + 10
			local.y = sh - local.height - 20;
		}


		private function onSearchKey(evt:KeyboardEvent):void {
			if (evt.keyCode == Keyboard.ENTER) {
				levels.searchFor(searchBox.text);
			}
		}


		private function onExitClick(evt:Event):void {
			Aeon.getMe().gotoMainMenu();
		}


		private function onLocalClick(evt:MouseEvent):void {
			file = new FileReference();

			var imageFileTypes:FileFilter = new FileFilter("Text (*.txt)", "*.txt");

			file.browse([imageFileTypes]);
			file.addEventListener(Event.SELECT, selectFile);
		}


		private function selectFile(evt:Event):void {
			file.addEventListener(Event.COMPLETE, playLevel);
			file.load();
		}

		
		private function playLevel(evt:Event):void{
			Aeon.getMe().playLevelCode(file.data.readUTFBytes(file.data.length));
		}
		
		private function onKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == 27) { //pressed Esc
				Aeon.getMe().gotoMainMenu();
			}
		}
		
		public override function set visible(b:Boolean):void {
			super.visible = b;
			if (b){
				Aeon.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
				onStageResize(null);
				searchBox.text = "";
				levels.reset();
			}else{
				Aeon.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
	}
}
