package org.interguild.components {
	//look mom! no imports!

	public class DropdownMenuDivider extends DropdownMenuElement {
		
		private static const DEFAULT_HEIGHT:uint = 15;
		private static const DEFAULT_WIDTH:uint = 200;
		
		private static const LINE_WIDTH:Number = 0.9; //percent
		private static const LINE_THICKNESS:uint = 1;
		private static const DEFAULT_LINE_COLOR:uint = 0x999999;
		
		public function DropdownMenuDivider() {
			//set width and height for DropdownMenuPopup to use
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, bgWidth, bgHeight);
			graphics.endFill();
			
			//calculate line properties
			var lineWidth:Number = bgWidth * LINE_WIDTH;
			var lineHeight:Number = LINE_THICKNESS;
			var lineX:Number = (bgWidth - lineWidth) / 2;
			var lineY:Number = (bgHeight - lineHeight) / 2 - 1;
			
			//draw line
			graphics.beginFill(DEFAULT_LINE_COLOR);
			graphics.drawRect(lineX, lineY, lineWidth, lineHeight);
			graphics.endFill();
		}
		
		protected function get bgWidth():uint{
			return DEFAULT_WIDTH;
		}
		
		protected function get bgHeight():uint{
			return DEFAULT_HEIGHT;
		}
	}
}
