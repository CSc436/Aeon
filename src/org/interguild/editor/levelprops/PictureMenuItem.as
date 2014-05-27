package org.interguild.editor.levelprops {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.interguild.components.DropdownMenuItem;

	public class PictureMenuItem extends DropdownMenuItem {
		
		private static const PADDING_TOP:uint = 2;
		private static const PADDING_LEFT:uint = 10;
		private static const PADDING_RIGHT:uint = 10;
		
		private static const BG_HEIGHT:uint = 32 + 6;
		
		public function PictureMenuItem(image:BitmapData, name:String, onClick:Function) {
			super(onClick);
			
			var bm:Bitmap = new Bitmap(image);
			bm.x = PADDING_LEFT;
			bm.y = PADDING_TOP;
			addChild(bm);
		}
		
		protected override function get bgHeight():uint{
			return BG_HEIGHT;
		}
	}
}
