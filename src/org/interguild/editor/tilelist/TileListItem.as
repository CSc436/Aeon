package org.interguild.editor.tilelist {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Aeon;

	public class TileListItem extends Sprite {

		private static const PADDING_LEFT:uint = 14;
		private static const PADDING_Y:uint = 8;

		private static const CLICK_AREA_WIDTH:uint = TileList.MASK_WIDTH;
		private static const CLICK_AREA_HEIGHT:uint = Aeon.TILE_HEIGHT + (2 * PADDING_Y);

		private static const OVER_COLOR:uint = 0x2c93b1;
		private static const OVER_ALPHA:Number = 1;
		private static const SELECTED_COLOR:uint = 0x0c4d68;
		private static const SELECTED_ALPHA:Number = 0.5;

		private static const ICON_BG_COLOR:uint = 0x417dce;
		private static const ICON_BORDER_COLOR:uint = 0x222222;
		private static const ICON_BORDER_WIDTH:uint = 1;

		private static const LABEL_FONT:String = "Verdana";
		private static const LABEL_COLOR:uint = 0xFFFFFF;
		private static const LABEL_SIZE:uint = 13;
		private static const LABEL_PADDING_LEFT:uint = 57;
		private static const LABEL_PADDING_TOP:uint = 13;

		private static const DIVIDER_LIGHT:uint = 0x209ed1;
		private static const DIVIDER_DARK:uint = 0x0f5571;

		private var overBG:Sprite;
		private var selectedBG:Sprite;
		private var icon:Bitmap;

		private var isSelected:Boolean;
		private var code:String;

		public function TileListItem(name:String, code:String) {
			this.code = code;
			this.mouseChildren = false;

			//init rollover highlight
			overBG = new Sprite();
			overBG.graphics.beginFill(OVER_COLOR, OVER_ALPHA);
			overBG.graphics.drawRect(0, 0, CLICK_AREA_WIDTH, CLICK_AREA_HEIGHT);
			overBG.graphics.endFill();
			overBG.visible = false;
			addChild(overBG);

			//init selected highlight
			selectedBG = new Sprite();
			selectedBG.graphics.beginFill(SELECTED_COLOR, SELECTED_ALPHA);
			selectedBG.graphics.drawRect(0, 0, CLICK_AREA_WIDTH, CLICK_AREA_HEIGHT + 1);
			selectedBG.graphics.endFill();
			selectedBG.visible = false;
			addChild(selectedBG);

			//init icon
			changeIcon(TileList.getIcon(code));

			//draw border
			var border:Shape = new Shape();
			border.graphics.beginFill(ICON_BORDER_COLOR);
			border.graphics.drawRect(icon.x - ICON_BORDER_WIDTH, icon.y - ICON_BORDER_WIDTH, icon.width + (2 * ICON_BORDER_WIDTH), icon.height + (2 * ICON_BORDER_WIDTH));
			border.graphics.endFill();
			border.graphics.beginFill(ICON_BG_COLOR);
			border.graphics.drawRect(icon.x, icon.y, icon.width, icon.height);
			border.graphics.endFill();			
			addChildAt(border, numChildren - 1);

			//drop shadow
//			var dropShadow:DropShadowFilter = new DropShadowFilter(2, 60, 0, 0.75, 2, 2, 1, BitmapFilterQuality.HIGH);

			//init label
			var label:TextField = new TextField();
			var format:TextFormat = new TextFormat(LABEL_FONT, LABEL_SIZE, LABEL_COLOR);
			label.defaultTextFormat = format;
			label.x = LABEL_PADDING_LEFT;
			label.y = LABEL_PADDING_TOP;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.text = name;
//			label.filters = [dropShadow];
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

		public function changeIcon(newIcon:BitmapData):void {
			if (icon)
				removeChild(icon);
			icon = new Bitmap(newIcon);
			icon.x = PADDING_LEFT;
			icon.y = PADDING_Y;
			addChild(icon);
		}

		public function drawBottomBorder():void {
			var border:Shape = new Shape();
			border.graphics.beginFill(DIVIDER_DARK);
			border.graphics.drawRect(0, CLICK_AREA_HEIGHT, CLICK_AREA_WIDTH, 1);
			border.graphics.endFill();
			border.graphics.beginFill(DIVIDER_LIGHT);
			border.graphics.drawRect(0, CLICK_AREA_HEIGHT + 1, CLICK_AREA_WIDTH, 1);
			border.graphics.endFill();
			addChild(border);
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

		public function select():void {
			isSelected = true;
			selectedBG.visible = true;
			overBG.visible = false;
		}

		public function deselect():void {
			isSelected = false;
			selectedBG.visible = false;
		}

		public function getCharCode():String {
			return code;
		}
	}
}
