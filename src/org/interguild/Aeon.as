package org.interguild {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	CONFIG::DEBUG {
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
	}

	import org.interguild.editor.EditorPage;
	import org.interguild.game.level.LevelPage;

	import org.interguild.loader.ErrorDialog;
	import flexunit.utils.ArrayList;


	/**
	 * Aeon.as initializes the game, but it's also responsible for
	 * managing all of the menu transitions.
	 *
	 * TODO: Put all of the main menu screen's components into its
	 * own class or object.
	 */

	[SWF(backgroundColor = "0x999999", width = "900", height = "500", frameRate = "30")]

	public class Aeon extends Sprite {



		private static var instance:Aeon;

		/**
		 * Aeon is a singleton, so use this to get a reference
		 * to it from where-ever you are.
		 */
		public static function getMe():Aeon {
			return instance;
		}

		public static const TILE_WIDTH:uint = 32;
		public static const TILE_HEIGHT:uint = 32;

		public static const STAGE_WIDTH:uint = 900;
		public static const STAGE_HEIGHT:uint = 500;

		private static const BG_COLOR:uint = 0x000b17;
		private static const BORDER_COLOR:uint = 0x000b17; //no border

		private var currentPage:Sprite;
		private var mainMenu:MainMenuPage;
		private var levelPage:LevelPage;
		private var editorPage:EditorPage;

		private var keys:KeyMan;

		public function Aeon() {
			instance = this;

			//stop stage from scaling and stuff
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			scaleX = scaleY = stage.stageWidth / STAGE_WIDTH;

			//init bg
			graphics.beginFill(BORDER_COLOR);
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			graphics.endFill();
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(1, 1, STAGE_WIDTH - 2, STAGE_HEIGHT - 2);
			graphics.endFill();

			//init key man
			keys = new KeyMan(stage);

			//init main menu
			mainMenu = new MainMenuPage();
			addChild(mainMenu);
			currentPage = mainMenu;

			//init editor
			editorPage = new EditorPage(stage);
			editorPage.visible = false;
			addChild(editorPage);

			//init debug mode
			CONFIG::DEBUG {
				var textField:TextField = new TextField();
				textField.defaultTextFormat = new TextFormat("Impact", 14, 0xFFFFFF);
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.selectable = false;
				textField.text = "DEBUGGING MODE";
				textField.x = 5;
				textField.y = Aeon.STAGE_HEIGHT - textField.height - 5;
				addChild(textField);
			}
		}

		public function gotoMainMenu():void {
			hideCurrentPage();
			mainMenu.visible = true;
			currentPage = mainMenu;
		}

		public function returnFromError(e:ArrayList, src:String):void {
			if (src == "MainMenu" || src.search("Loader") >= 0)
				gotoMainMenu();
			if (src == "Editor")
				gotoEditorPage();

			var dialog:ErrorDialog = new ErrorDialog(e, src);
			dialog.y = 120;
			dialog.x = (Aeon.STAGE_WIDTH / 2) - 150;
			addChild(dialog);
		}

		public function playLevelFile(file:String):void {
			hideCurrentPage();

			//go to level page
			levelPage = new LevelPage();
			levelPage.playLevelFromFile(file);
			this.addChild(levelPage);
			currentPage = levelPage;
		}

		public function playLevelCode(code:String):void {
			hideCurrentPage();

			levelPage = new LevelPage();
			levelPage.playLevelFromCode(code);
			this.addChild(levelPage);
			currentPage = levelPage;
		}

		public function gotoEditorPage():void {
			hideCurrentPage();
			editorPage.visible = true;
			currentPage = editorPage;
		}

//		public function getLevelPage():LevelPage {
//			return this.levelPage;
//		}

		public function hideCurrentPage():void {
			currentPage.visible = false;
			if (currentPage == levelPage) {
				removeChild(levelPage);
				levelPage = null;
			}
		}
	}
}
