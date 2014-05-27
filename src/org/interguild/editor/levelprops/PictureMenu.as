package org.interguild.editor.levelprops {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.components.DropdownMenu;

	public class PictureMenu extends DropdownMenu {
		
		private static const IMAGE_WIDTH:uint = 46;
		private static const IMAGE_HEIGHT:uint = 32;
		
		private var props:LevelPropertiesScreen;
		
		public function PictureMenu(props:LevelPropertiesScreen) {
			this.props = props;
			
			initButton(new Bitmap(new PictureButtonUp()), new Bitmap(new PictureButtonOver()));
		}
		
		public function addItem(image:BitmapData, name:String):void{
			var bd:BitmapData = new BitmapData(IMAGE_WIDTH, IMAGE_HEIGHT);
			bd.copyPixels(image, new Rectangle(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT), new Point(0, 0));
			
			super.addItem(new PictureMenuItem(bd, name, onSelect));
		}
		
		private function onSelect(evt:MouseEvent):void{
			
		}
	}
}
