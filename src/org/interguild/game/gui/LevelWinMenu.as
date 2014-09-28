package org.interguild.game.gui {
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.menu.ListBasedMenu;

	public class LevelWinMenu extends ListBasedMenu {

		private static var instance:LevelWinMenu = null;

		public static function getMe():LevelWinMenu {
			if (instance == null) {
				instance = new LevelWinMenu();
			}
			return instance;
		}

		private static const CENTER_X:Number = Aeon.STAGE_WIDTH / 2;
		private static const CENTER_Y:Number = Aeon.STAGE_HEIGHT / 2;

		private static const SPACING_Y:uint = 64;
		private static const PLAY_AGAIN_Y:uint = 215;
		private static const LEVEL_EDITOR_Y:uint = PLAY_AGAIN_Y + SPACING_Y;
		private static const QUIT_Y:uint = LEVEL_EDITOR_Y + SPACING_Y;

		private static const SELECTOR_X:int = -111;
		private static const SELECTOR_Y:int = -7;

		private static const TODO_PLAY_AGAIN:uint = 0x0;
		private static const TODO_LEVEL_EDITOR:uint = 0x1;
		private static const TODO_QUIT:uint = 0x2;

		// Buttons for the pause menu
		private var playAgainButton:MovieClip;
		private var editorButton:MovieClip;
		private var quitButton:MovieClip;

		public function LevelWinMenu() {
			super(CENTER_X, SELECTOR_Y);

			//init bg
			var bg:Bitmap = new Bitmap(Assets.WIN_MENU_BG);
			bg.x = CENTER_X - bg.width / 2;
			bg.y = CENTER_Y - bg.height / 2;
			addChildAt(bg, 0);

			// init resume button
			playAgainButton = new PlayAgainButton();
			playAgainButton.buttonMode = true;
			playAgainButton.x = CENTER_X;
			playAgainButton.y = PLAY_AGAIN_Y;
			addChild(playAgainButton);
			addButton(playAgainButton);

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

			selectItem(playAgainButton);
		}

		protected override function onItemClicked(selectedButton:uint):void {
			switch (selectedButton) {
				case TODO_PLAY_AGAIN:
					this.stage.focus = stage;
					Aeon.getMe().playLastLevel();
					break;
				case TODO_LEVEL_EDITOR:
					Aeon.getMe().gotoEditorPage();
					break;
				case TODO_QUIT:
					Aeon.getMe().gotoMainMenu();
					break;
			}
		}
	}
}
