package org.interguild.menu {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.system.fscommand;

	import fl.controls.Button;


	public class MainMenu extends Sprite {
		private var playButton:Button;
		private var editorButton:Button;
		private var exitButton:Button;

		[Embed(source = "../../../../images/aeon_logo.png")]
		private var Aeon_Logo:Class;

		private var logo:Bitmap;

		private var currSprite:Sprite;
		private var levelPage:LevelPage;

		public function MainMenu(currSprite:Sprite, levelPage:LevelPage) {
			this.currSprite = currSprite;
			this.levelPage = levelPage;
			logo = new Aeon_Logo();
			currSprite.addChild(logo);

			playButton = new Button();
			playButton.label = "PLAY GAME!";
			playButton.y = 125;
			playButton.x = 90;
			playButton.height = 50;
			playButton.width = 200;
			playButton.addEventListener(MouseEvent.CLICK, playGame);
			currSprite.addChild(playButton);

			editorButton = new Button();
			editorButton.label = "Level Editor";
			editorButton.x = 115;
			editorButton.y = 190;
			editorButton.height = 25;
			editorButton.width = 150;
			currSprite.addChild(editorButton);

			exitButton = new Button();
			exitButton.label = "Exit Game";
			exitButton.x = 115;
			exitButton.y = 220;
			exitButton.height = 25;
			exitButton.width = 150;
			exitButton.addEventListener(MouseEvent.CLICK, exit);
			currSprite.addChild(exitButton);
		}

		//Exit is not working properly
		protected function exit(event:MouseEvent):void {
			try {
				System.exit(0);
			} catch (e:Error) {
				fscommand("quit");
			}
		}

		//Not sure how I'm supposed to make the game start playing
		protected function playGame(event:MouseEvent):void {
			currSprite.removeChild(logo);
			currSprite.removeChild(playButton);
			currSprite.removeChild(editorButton);
			currSprite.removeChild(exitButton);
			currSprite.addChild(levelPage);
		}


	}
}