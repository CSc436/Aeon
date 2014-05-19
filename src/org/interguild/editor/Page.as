package org.interguild.editor {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import org.interguild.editor.grid.EditorLevel;

	/**
	 * A "Page" is any major screen in the game. For example:
	 * MainMenuPage, LevelPage, EditorPage.
	 *
	 * Pages and page transitions are handled by Aeon.as.
	 * This class is mainly used for polymorphism, and
	 * clarity.
	 */
	public class Page extends Sprite {
		/**
		 * Method is called when placing a background for an editorButton
		 */
		protected function setBackgroundSize(background:Bitmap, x:int, y:int, width:int):void{
			background.x = x;
			background.y = y;
			background.width = width;
		}
		
		/**
		 * place the editorButton on the gui
		 */
		protected function setButtonSize(button:MovieClip,x:int, y:int, width:int, height:int):void{
			button.x = x;
			button.y = y;
			button.width = width;
			button.height = height;			
		}
	}
}
