package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import org.interguild.menu.FancyButton;
	import org.interguild.editor.dropdown.FileMenu;

	public class TopBar extends Sprite {

		private var editor:EditorPage;

		public function TopBar(editor:EditorPage) {
			this.editor = editor;

			//init bg
			var bg:Bitmap = new Bitmap(new EditorTopBarSprite());
			addChild(bg);

			initIcons();
			initButtons();

			//init File button
			var fileButton:FileMenu = new FileMenu(editor);
			addChild(fileButton);
		}

		private function initIcons():void {
			//no icons to initialize yet
		}

		/**
		 * Initializes the "Play Level" button and "Publish" button
		 */
		private function initButtons():void {
			var up:DisplayObject;
			var over:DisplayObject;
			var hit:Sprite;

			//init play level button
			up = new Bitmap(new PlayLevelButtonSprite());
			over = new Bitmap(new PlayLevelRolloverSprite());
			hit = new Sprite();
			hit.graphics.beginFill(0, 0); //define button's hit region
			hit.graphics.moveTo(25, 1);
			hit.graphics.lineTo(200, 1);
			hit.graphics.lineTo(175, 47);
			hit.graphics.lineTo(0, 47);
			hit.graphics.lineTo(25, 1);
			hit.graphics.endFill();
			var playGameButton:FancyButton = new FancyButton(up, over, hit);
			playGameButton.x = 545;
			playGameButton.y = 18;
			playGameButton.addEventListener(MouseEvent.CLICK, editor.testGame);
			addChild(playGameButton);

			//init publish button
			up = new Bitmap(new PublishButtonSprite());
			over = new Bitmap(new PublishRolloverSprite());
			hit = new Sprite();
			hit.graphics.beginFill(0, 0); //define button's hit region
			hit.graphics.moveTo(25, 1);
			hit.graphics.lineTo(147, 1);
			hit.graphics.lineTo(147, 47);
			hit.graphics.lineTo(0, 47);
			hit.graphics.lineTo(25, 1);
			hit.graphics.endFill();
			var publishButton:FancyButton = new FancyButton(up, over, hit);
			publishButton.x = 734;
			publishButton.y = 18;
			//todo make button publish to website
			addChild(publishButton);
		}
	}
}
