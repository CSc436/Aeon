package org.interguild.game.level {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.interguild.Aeon;
	import org.interguild.KeyMan;
	import org.interguild.ListBasedMenu;

	public class LevelPauseMenu extends ListBasedMenu {
		
		private static const CENTER_X:Number = Aeon.STAGE_WIDTH / 2;
		private static const CENTER_Y:Number = Aeon.STAGE_HEIGHT / 2;
		
		private static const SPACING_Y:uint = 55;
		private static const RESUME_Y:uint = 206;
		private static const RESTART_Y:uint = RESUME_Y + SPACING_Y;
		private static const LEVEL_EDITOR_Y:uint = RESTART_Y + SPACING_Y;
		private static const QUIT_Y:uint = LEVEL_EDITOR_Y + SPACING_Y;
		
		private static const SELECTOR_X:int = -111;
		private static const SELECTOR_Y:int = -7;
		
		private static const TODO_RESUME:uint = 0x0;
		private static const TODO_RESTART:uint = 0x1;
		private static const TODO_LEVEL_EDITOR:uint = 0x2;
		private static const TODO_QUIT:uint = 0x3;
		
		// Buttons for the pause menu
		private var resumeButton:MovieClip;
		//private var restartCheckpointButton:Button;
		private var restartGameButton:MovieClip;
		private var editorButton:MovieClip;
		private var quitButton:MovieClip;
		
		public function LevelPauseMenu() {
			super(SELECTOR_X, SELECTOR_Y);
			
			//init bg
			var bg:Bitmap = new Bitmap(new PauseMenuBG());
			bg.x = CENTER_X - bg.width / 2;
			bg.y = CENTER_Y - bg.height / 2;
			addChildAt(bg, 0);
			
			// init resume button
			resumeButton = new ResumeButton();
			resumeButton.buttonMode = true;
			resumeButton.x = CENTER_X;
			resumeButton.y = RESUME_Y;
			addChild(resumeButton);
			addButton(resumeButton);
			
			// Make button for restarting from a checkpoint
			//			restartCheckpointButton = new Button();
			//			restartCheckpointButton.label = "Restart from Checkpoint";
			//			restartCheckpointButton.x = 350;
			//			restartCheckpointButton.y = 175;
			//			restartCheckpointButton.height = 25;
			//			restartCheckpointButton.width = 150;
			//			// Make this work once we actually have checkpoints in the game
			//			//restartCheckpointButton.addEventListener(MouseEvent.CLICK, restartFromCheckpoint);
			//			this.parent.addChild(restartCheckpointButton);
			
			// Make button for restarting from the beginning of a level
			restartGameButton = new RestartButton();
			restartGameButton.buttonMode = true;
			restartGameButton.x = CENTER_X;
			restartGameButton.y = RESTART_Y;
			addChild(restartGameButton);
			addButton(restartGameButton);
			
			// Make button for going to the level editor
			editorButton = new LevelEditorPauseButton();
			editorButton.buttonMode = true;
			editorButton.x = CENTER_X;
			editorButton.y = LEVEL_EDITOR_Y;
			addChild(editorButton);
			addButton(editorButton);
			
			// Make button for quitting the game
			quitButton = new QuitButton();
			quitButton.buttonMode = true;
			quitButton.x = CENTER_X;
			quitButton.y = QUIT_Y;
			addChild(quitButton);
			addButton(quitButton);
			
			selectItem(resumeButton);
		}
		
		protected override function onItemClicked(selectedButton:uint):void{
			switch (selectedButton) {
				case TODO_RESUME:
					KeyMan.getMe().resumeFromButton();
					break;
				case TODO_RESTART:
					this.stage.focus = stage;
					// This is hardcoded right now, but we probably want some kind of
					// global reference to the current file so that we know what level
					// needs to be restarted
					CONFIG::DEPLOY {
						Aeon.getMe().playLevelCode(TestLevel.getCode());
					}
						CONFIG::NODEPLOY {
						Aeon.getMe().playLevelFile(LevelPage.TEST_LEVEL_FILE);
					}
					break;
				case TODO_LEVEL_EDITOR:
					// Probably want to give the user some kind of dialog warning them
					// that exiting to the editor will cause them to lose their progress
					// in the current level
					Aeon.getMe().gotoEditorPage();
					break;
				case TODO_QUIT:
					Aeon.getMe().gotoMainMenu();
					break;
			}
		}
	}
}
