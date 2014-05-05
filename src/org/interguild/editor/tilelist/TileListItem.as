package org.interguild.editor.tilelist {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Aeon;

	public class TileListItem extends Sprite {

		private static const PADDING_LEFT:uint = 16;
		private static const PADDING_Y:uint = 14;
		private static const BORDER_PADDING:uint = PADDING_LEFT / 2;

		private static const CLICK_AREA_WIDTH:uint = TileList.MASK_WIDTH;
		private static const CLICK_AREA_HEIGHT:uint = Aeon.TILE_HEIGHT + (2 * PADDING_Y);

		private static const OVER_COLOR:uint = 0x1e6c7d;
		private static const OVER_CORNER_RADIUS:uint = 10;
		private static const OVER_WIDTH:uint = CLICK_AREA_WIDTH - (2 * BORDER_PADDING);
		private static const OVER_HEIGHT:uint = CLICK_AREA_HEIGHT;

		private static const ICON_BORDER_COLOR:uint = 0x222222;
		private static const ICON_BORDER_WIDTH:uint = 1;

		private static const LABEL_FONT:String = "Verdana";
		private static const LABEL_COLOR:uint = 0xFFFFFF;
		private static const LABEL_SIZE:uint = 14;
		private static const LABEL_PADDING_LEFT:uint = 57;
		private static const LABEL_PADDING_TOP:uint = 19;

		private var overBG:Sprite;
		private var selectedBG:Bitmap;

		private var isSelected:Boolean;
		private var code:String;
		private var icon:BitmapData;

		public function TileListItem(name:String, code:String) {
			this.code = code;
			this.icon = TileList.getIcon(code);
			this.mouseChildren = false;

			//init rollover highlight
			overBG = new Sprite();
			overBG.graphics.beginFill(OVER_COLOR);
			overBG.graphics.drawRoundRect(BORDER_PADDING, 0, OVER_WIDTH, OVER_HEIGHT, OVER_CORNER_RADIUS, OVER_CORNER_RADIUS);
			overBG.graphics.endFill();
			overBG.visible = false;
			addChild(overBG);

			//init selected highlight
			selectedBG = new Bitmap(new TileSelectedSprite());
			selectedBG.x = BORDER_PADDING;
			selectedBG.y = OVER_HEIGHT / 2 - selectedBG.height / 2;
			selectedBG.visible = false;
			addChild(selectedBG);

			//init icon
			var img:Bitmap = new Bitmap(icon);
			img.x = PADDING_LEFT;
			img.y = PADDING_Y;
			addChild(img);

			//draw border
			var border:Sprite = new Sprite();
			border.graphics.beginFill(ICON_BORDER_COLOR);
			border.graphics.drawRect(img.x - ICON_BORDER_WIDTH, img.y - ICON_BORDER_WIDTH, img.width + (2 * ICON_BORDER_WIDTH), img.height + (2 * ICON_BORDER_WIDTH));
			border.graphics.endFill();
			addChildAt(border, numChildren - 1);

			//init label
			var label:TextField = new TextField();
			var format:TextFormat = new TextFormat(LABEL_FONT, LABEL_SIZE, LABEL_COLOR);
			label.defaultTextFormat = format;
			label.x = LABEL_PADDING_LEFT;
			label.y = LABEL_PADDING_TOP;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = name;
			addChild(label);

			//init click area
			var clickArea:Sprite = new Sprite();
			clickArea.graphics.beginFill(0, 0);
			clickArea.graphics.drawRect(0, 0, CLICK_AREA_WIDTH, CLICK_AREA_HEIGHT);
			clickArea.graphics.endFill();
			clickArea.buttonMode = true;
			addChild(clickArea);

			//init events
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
		}

		private function onMouseOver(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			if (!isSelected)
				overBG.visible = true;
		}

		private function onMouseOut(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			overBG.visible = false;
		}
		
		public function select():void{
			isSelected = true;
			selectedBG.visible = true;
			overBG.visible = false;
		}
		
		public function deselect():void{
			isSelected = false;
			selectedBG.visible = false;
		}
		
		public function getCharCode():String{
			return code;
		}
		
		public function getIcon():BitmapData{
			return icon;
		}
	}
}