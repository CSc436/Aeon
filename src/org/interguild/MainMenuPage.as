package org.interguild {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	
	import org.interguild.game.level.LevelPage;

	public class MainMenuPage extends Page {

		private var playButton:Button;
		private var editorButton:Button;

		[Embed(source = "../../../images/aeon_logo.png")]
		private var Aeon_Logo:Class;
		private var logo:Bitmap;

		public function MainMenuPage() {
			//init logo image
			logo=new Aeon_Logo();
			logo.x=(Aeon.STAGE_WIDTH / 2) - (logo.width / 2);
			this.addChild(logo);
			
			//int play button
			playButton=new Button();
			playButton.label="PLAY GAME!";
			playButton.y=125;
			playButton.x=(Aeon.STAGE_WIDTH / 2) - 100;
			playButton.height=50;
			playButton.width=200;
			playButton.addEventListener(MouseEvent.CLICK, gotoGame);
			this.addChild(playButton);
			
			//init editor button
			editorButton=new Button();
			editorButton.label="Level Editor";
			editorButton.x=(Aeon.STAGE_WIDTH / 2) - 75;
			editorButton.y=190;
			editorButton.height=25;
			editorButton.width=150;
			editorButton.addEventListener(MouseEvent.CLICK, gotoEditor);
			this.addChild(editorButton);
		}
		
		private function gotoGame(event:MouseEvent):void {
			Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
		}
		
		private function gotoEditor(evt:MouseEvent):void {
			Aeon.getMe().gotoEditorPage();
		}
	}
}
