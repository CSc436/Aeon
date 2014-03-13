package org.interguild {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import fl.controls.Button;
	
	import org.interguild.editor.EditorPage;
	import org.interguild.game.KeyMan;
	import org.interguild.game.level.LevelPage;

	/**
	 * Aeon.as initializes the game, but it's also responsible for
	 * managing all of the menu transitions.
	 *
	 * TODO: Put all of the main menu screen's components into its
	 * own class or object.
	 */
	
	[SWF(backgroundColor = "0x000000", width = "900", height = "500", frameRate = "30")]
	
	public class Aeon extends Sprite {

		public static const TILE_WIDTH:uint=32;
		public static const TILE_HEIGHT:uint=32;

		public static const STAGE_WIDTH:uint=900;
		public static const STAGE_HEIGHT:uint=500;

		private static const BG_COLOR:uint = 0x050c0f;

		private var levelPage:LevelPage;
		private var editorPage:EditorPage;
		private var keys:KeyMan;

		private var playButton:Button;
		private var editorButton:Button;

		[Embed(source="../../../images/aeon_logo.png")]
		private var Aeon_Logo:Class;

		private var logo:Bitmap;

		public function Aeon() {
			//stop stage from scaling and stuff
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align=StageAlign.TOP_LEFT;
			scaleX=scaleY=stage.stageWidth / STAGE_WIDTH;

			//init bg
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			//adding in main menu
			addMainMenu();
			//init key man
			keys = new KeyMan(stage);
			
			CONFIG::DEBUG{
				var textField:TextField = new TextField();
				textField.defaultTextFormat = new TextFormat("Impact", 20, 0xFFFFFF, true);
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.selectable = false;
				textField.text = "DEBUGGING MODE";
				textField.x = 5;
				textField.y = Aeon.STAGE_HEIGHT - textField.height - 5;
				addChild(textField);
			}
		}

		private function gotoGame(event:MouseEvent):void {
			this.removeChild(logo);
			this.removeChild(playButton);
			this.removeChild(editorButton);

			//go to level page
			levelPage=new LevelPage();
			this.addChild(levelPage);
		}

		private function gotoEditor(evt:MouseEvent):void {
			this.removeChild(logo);
			this.removeChild(playButton);
			this.removeChild(editorButton);

			editorPage=new EditorPage(this);
			this.addChild(editorPage);
		}

		public function addMainMenu():void {
			//init logo image
			logo=new Aeon_Logo();
			logo.x=(STAGE_WIDTH / 2) - (logo.width / 2);
			this.addChild(logo);

			//int play button
			playButton=new Button();
			playButton.label="PLAY GAME!";
			playButton.y=125;
			playButton.x=(STAGE_WIDTH / 2) - 100;
			playButton.height=50;
			playButton.width=200;
			playButton.addEventListener(MouseEvent.CLICK, gotoGame);
			this.addChild(playButton);

			//init editor button
			editorButton=new Button();
			editorButton.label="Level Editor";
			editorButton.x=(STAGE_WIDTH / 2) - 75;
			editorButton.y=190;
			editorButton.height=25;
			editorButton.width=150;
			editorButton.addEventListener(MouseEvent.CLICK, gotoEditor);
			this.addChild(editorButton);
		}
	}
}
