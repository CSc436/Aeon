package org.interguild.editor.levelprops {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.components.DropdownMenuItem;

	public class PictureMenuItem extends DropdownMenuItem {

		private static const BORDER_COLOR:uint = 0x222222;

		private static const TEXT_FONT:String = "Arial";
		private static const TEXT_SIZE:uint = 13;
		private static const TEXT_COLOR:uint = 0x000000; //black
		private static const TEXT_COLOR_OVER:uint = 0xFFFFFF; //white

		private static const IMG_PADDING_Y:uint = 6;
		private static const IMG_PADDING_LEFT:uint = 6;
		private static const IMG_PADDING_RIGHT:uint = 6;
		private static const TEXT_PADDING_TOP:uint = 12;

		private static const BG_HEIGHT:uint = 32 + 2 + (2 * IMG_PADDING_Y) + 1;
		private static const BG_WIDTH:uint = 150;

		private var myID:uint;
		private var myImage:BitmapData;
		private var label:TextField;
		private var normalFormat:TextFormat;
		private var overFormat:TextFormat;

		public function PictureMenuItem(id:uint, image:BitmapData, name:String, onClick:Function) {
			super(onClick);
			myID = id;
			myImage = image;

			//add border to image:
			var bdata:BitmapData = new BitmapData(image.width + 2, image.height + 2, false, BORDER_COLOR);
			bdata.copyPixels(image, new Rectangle(0, 0, image.width, image.height), new Point(1, 1));
			var bm:Bitmap = new Bitmap(bdata);
			bm.x = IMG_PADDING_LEFT;
			bm.y = IMG_PADDING_Y;
			addChildAt(bm, 1);

			//init formats
			normalFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR);
			overFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR_OVER);

			//init left text
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
			label.text = name;
			label.setTextFormat(normalFormat);
			label.x = bm.x + bm.width + IMG_PADDING_RIGHT;
			label.y = TEXT_PADDING_TOP;
			addChildAt(label, 1);
		}
		
		public function get id():uint{
			return myID;
		}
		
		public function get picture():BitmapData{
			return myImage;
		}

		protected override function get bgWidth():uint {
			return BG_WIDTH;
		}

		protected override function get bgHeight():uint {
			return BG_HEIGHT;
		}

		protected override function onMouseOver(evt:MouseEvent):void {
			super.onMouseOver(evt);
			label.setTextFormat(overFormat);
		}

		protected override function onMouseOut(evt:MouseEvent):void {
			super.onMouseOut(evt);
			label.setTextFormat(normalFormat);
		}
	}
}
