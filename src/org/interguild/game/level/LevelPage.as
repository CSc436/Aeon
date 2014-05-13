package org.interguild.game.level {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import fl.controls.Button;
	
	import flexunit.utils.ArrayList;
	
	import org.interguild.Aeon;
	import org.interguild.INTERGUILD;
	import org.interguild.KeyMan;
	import org.interguild.loader.LevelLoader;

	/**
	 * LevelPage will handle every screen that happens when you're playing a level.
	 * This includes:
	 * 		-The level preloader
	 * 		-The pause menu
	 * 		-The win screen?
	 * 		-The level itself
	 */
	public class LevelPage extends Sprite {
		
		//remote file
		public static const TEST_LEVEL_FILE:String = INTERGUILD.ORG + "/levels/levels/65180.txt";
		//local file
//		public static const TEST_LEVEL_FILE:String = "../gamesaves/coollevel.txt";

		private var level:Level;
		private var loader:LevelLoader;
		private var progressBar:LevelProgressBar;
		private var startScreen:LevelStartScreen;
		private var pauseMenu:LevelPauseMenu;
		private var winDialog:Sprite;

		public function LevelPage() {
			//init progress bar
			progressBar = new LevelProgressBar();
			progressBar.x = Aeon.STAGE_WIDTH / 2 - progressBar.width / 2;
			progressBar.y = Aeon.STAGE_HEIGHT / 2 - progressBar.height / 2;
			addChild(progressBar);

			//init Level Loader
			loader = new LevelLoader();
			loader.addProgressListener(progressBar.setProgress);
			loader.addInitializedListener(onFileLoad);
			loader.addErrorListener(onLoadError);
			loader.addCompletionListener(onLoadComplete);
		}

		public function playLevelFromFile(file:String):void {
			loader.loadFromFile(file);
		}

		public function playLevelFromCode(code:String):void {
			loader.loadFromCode(code, "MainMenu");
		}

		private function onFileLoad(lvl:Level):void {
			level = lvl;
			level.onWinCallback = onWonGame;

			//init start screen
			startScreen = new LevelStartScreen(level.title);
			addChild(startScreen);
			showPreviewLevel();

			//add level to display list on top of start screen
			addChild(level);

			//init pause menu on top of level
			pauseMenu = new LevelPauseMenu();
			pauseMenu.visible = false;
			addChild(pauseMenu);
		}

		private function onLoadError(e:ArrayList):void {
			Aeon.getMe().returnFromError(e, "LevelLoader");
		}

		private function onLoadComplete():void {
			removeChild(progressBar);
			startScreen.loadComplete();

			var keys:KeyMan = KeyMan.getMe();
			keys.addSpacebarListener(onSpacebar);
			keys.addEscapeListener(onPauseGame);
		}

		private function showPreviewLevel():void {
			startScreen.visible = true;
			level.hudVisibility = false;

			//scale level preview:
			var box:Rectangle = startScreen.getPreviewRegion();
			level.scaleX = level.scaleY = box.height / level.heightInPixels;
			var tmpScale:Number = box.width / level.widthInPixels;
			if (tmpScale < level.scaleX)
				level.scaleX = level.scaleY = tmpScale;
			if (level.scaleX > 1)
				level.scaleX = level.scaleY = 1;

			//position level preview:
			level.x = Aeon.STAGE_WIDTH / 2 - level.widthInPixels * level.scaleX / 2;
			level.y = box.y + (box.height / 2) - level.heightInPixels * level.scaleY / 2;

			level.hideBackground();
		}

		private function onPauseGame():void {
			if (!pauseMenu.visible) { //pause
				if (!startScreen.visible) {
					level.pauseGame();
				}
				pauseMenu.visible = true;
			} else {
				if (!startScreen.visible) {
					level.continueGame(); //unpause
				}
				pauseMenu.visible = false;
			}
		}
		
		public function onWonGame():void {
			var header:TextField = new TextField();
			var content:TextField = new TextField();
			winDialog = new Sprite();
			var rect:Shape = new Shape();
			rect.graphics.lineStyle(1);
			rect.graphics.beginFill(0X333333,1);
			rect.graphics.drawRect(0,0,300,160);
			winDialog.addChild(rect);
			//header box
			var headerOutline:Shape = new Shape();
			headerOutline.graphics.lineStyle(1);
			headerOutline.graphics.drawRect(0,0, 300, 22);
			headerOutline.x = 0;
			headerOutline.y = 0;
			winDialog.addChild(headerOutline);
			
			//format header text
			var headerFormat:TextFormat = new TextFormat();
			headerFormat.bold = false;
			headerFormat.color = 0x000000;
			headerFormat.size = 14;
			headerFormat.font = "Verdana";
			
			//format dialog text
			var dialogFormat:TextFormat = new TextFormat();
			dialogFormat.size = 12;
			dialogFormat.font = "Verdana";
			
			//title of dialog box
			var headerTxt:String = "VICTORY!!";
			header = new TextField();
			header.text = headerTxt;
			header.setTextFormat(headerFormat);
			header.x = 5;
			header.y = 0;
			header.width = 275;
			header.height = 22;
			header.wordWrap = true;
			header.multiline = false;
			winDialog.addChild(header);
			
			var txt:String = "Congratulations, you've beaten the level!";
			//outline for scrolling text area
			var outline:Shape = new Shape();
			outline.graphics.lineStyle(1);
			outline.graphics.beginFill(0,0);
			outline.graphics.drawRect(0,0, 275, 100);
			outline.x = 5;
			outline.y = 25;
			winDialog.addChild(outline);
			content = new TextField();
			content.background = true;
			content.backgroundColor = 0Xffffff;
			content.text = txt;
			content.x = 5;
			content.y = 25;
			content.width = 275;
			content.height = 100;
			content.wordWrap = true;
			content.multiline = true;
			content.setTextFormat(dialogFormat);
			winDialog.addChild(content);
			
			//close dialog box
			var close:Button = new Button();
			close.label = "Close";
			close.x = 100;
			close.y = 130;
			close.addEventListener(MouseEvent.CLICK, closeDialog, true, 0);
			winDialog.addChild(close); 
			
			winDialog.x = Aeon.STAGE_WIDTH / 2 - winDialog.width / 2;
			winDialog.y = Aeon.STAGE_HEIGHT / 2 - winDialog.height / 2;
			
			var aeon:Aeon = Aeon.getMe();
			aeon.gotoMainMenu();
			//this.addChild(winDialog);
		}
		
		private function closeDialog(e:MouseEvent):void
		{
			
				LevelPage(this).removeChild(winDialog);
			
		}
		
		private function onSpacebar():void{
			if(!pauseMenu.visible && !level.isRunning){
				showFullLevel();
			}
		}

		private function showFullLevel():void {
			if (startScreen.visible) {
				startScreen.visible = false;
				level.showBackground();
				level.scaleX = level.scaleY = 1;
				level.x = level.y = 0;
				level.startGame();
			}
			level.hudVisibility = true;
		}
	}
}
