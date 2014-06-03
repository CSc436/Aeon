package org.interguild.editor.help {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import org.interguild.Aeon;
	import org.interguild.Assets;
	import org.interguild.components.SquareButton;
	import org.interguild.editor.EditorPage;

	public class EditorHelpScreen extends Sprite {
		
		private static const WINDOW_WIDTH:uint = 694;
		private static const WINDOW_HEIGHT:uint = 410;

		private static const BG_COLOR:uint = 0x003c43;
		private static const BG_ALPHA:Number = 0.9;
		private static const BORDER_COLOR:uint = 0x00878f;
		private static const BORDER_WIDTH:uint = 1;
		private static const CORNER_RADIUS:uint = 20;
		
		private static const SHADOW_DISTANCE:uint = 21;
		private static const SHADOW_ANGLE:Number = 60;
		private static const SHADOW_COLOR:uint = 0x000000;
		private static const SHADOW_ALPHA:Number = 0.75;
		private static const SHADOW_BLUR_X:Number = 50;
		private static const SHADOW_BLUE_Y:Number = 50;
		private static const SHADOW_STRENGTH:Number = 1.2;
		
		private static const TITLE_Y:uint = 18;

		private static const PADDING_X:uint = 30;
		private static const TEXT_START_Y:uint = 58;
		private static const COLUMN_WIDTH:uint = (WINDOW_WIDTH - (3 * PADDING_X)) / 2;

		private static const HEADING_FONT:String = "Arial";
		private static const HEADING_SIZE:uint = 20;
		private static const HEADING_COLOR:uint = 0xFFFFFF;
		private static const HEADING_BOLD:Boolean = true;
		private static const HEADING_ITALIC:Boolean = false;
		private static const HEADING_MARGIN_TOP:uint = 20;
		private static const HEADING_MARGIN_BOTTOM:uint = 4;
		private static const HEADING_MARGIN_LEFT:uint = 0;

		private static const TEXT_FONT:String = "Arial";
		private static const TEXT_SIZE:uint = 14;
		private static const TEXT_COLOR:uint = 0xFFFFFF;
		private static const TEXT_MARGIN_TOP:uint = 2;
		private static const TEXT_MARGIN_BOTTOM:uint = 2;
		private static const TEXT_MARGIN_LEFT:uint = 30;
		private static const TEXT_WIDTH:uint = COLUMN_WIDTH - TEXT_MARGIN_LEFT;

		private static const BULLET_RADIUS:uint = 4;
		private static const BULLET_COLOR:uint = 0xFFFFFF;
		private static const BULLET_X:uint = TEXT_MARGIN_LEFT / 2;
		private static const BULLET_Y:uint = 13;

		private static const BUTTON_BG_COLOR_UP:uint = 0x4b4b4b;
		private static const BUTTON_BG_COLOR_OVER:uint = 0x676767;
		private static const BUTTON_BORDER_COLOR:uint = 0x9e9e9e;
		private static const BUTTON_WIDTH:uint = 80;
		private static const BUTTON_HEIGHT:uint = 25;
		private static const BUTTON_X:uint = (WINDOW_WIDTH / 2) - (BUTTON_WIDTH / 2);
		private static const BUTTON_Y:uint = WINDOW_HEIGHT - BUTTON_HEIGHT - 15;

		private var nextX:Number = PADDING_X;
		private var nextY:Number = TEXT_START_Y;

		public function EditorHelpScreen() {
			initBackground();

			addHeading("Placing Tiles");
			addText("Select tiles from the list on the right and place them on the grid.");
			addText("Click and drag to place several tiles.");
			addText("Hold SHIFT while placing tiles to draw a square of tiles.");

			addHeading("The Hand Tool");
			addText("Press and hold SPACEBAR to use the Hand Tool, which lets you scroll through the level by click-and-dragging.");
			addText("You can also use the hand tool to scroll through the tile list.");

			addColumnBreak();
			
			addHeading("Level Properties");
			addText("You can edit your level's name, size, and colors by going to [File > Edit Level Properties].");

			addHeading("The Select Tool");
			addText("Use the select tool to copy, cut, or delete sections of your level.");
			addText("Use [File > Paste] to see your most recent copy, so that you can paste it again.");
			addText("When pasting, blank tiles are usually ignored. Hold SHIFT if you want blank tiles to be pasted as well.");

			initCloseButton();
		}

		public function addHeading(s:String):void {
			var heading:TextField = new TextField();
			heading.defaultTextFormat = new TextFormat(HEADING_FONT, HEADING_SIZE, HEADING_COLOR, HEADING_BOLD, HEADING_ITALIC);
			heading.autoSize = TextFieldAutoSize.LEFT;
			heading.x = nextX + HEADING_MARGIN_LEFT;
			heading.y = nextY + HEADING_MARGIN_TOP;
			heading.selectable = false;
			heading.text = s;
			addChild(heading);

			nextY = heading.y + heading.height + HEADING_MARGIN_BOTTOM;
		}

		private function addText(s:String):void {
			var bullet:Sprite = new Sprite();
			bullet.graphics.beginFill(BULLET_COLOR);
			bullet.graphics.drawCircle(nextX + BULLET_X, nextY + BULLET_Y, BULLET_RADIUS);
			bullet.graphics.endFill();
			addChild(bullet);

			var text:TextField = new TextField();
			text.defaultTextFormat = new TextFormat(TEXT_FONT, TEXT_SIZE, TEXT_COLOR);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.width = TEXT_WIDTH;
			text.wordWrap = true;
			text.x = nextX + TEXT_MARGIN_LEFT;
			text.y = nextY + TEXT_MARGIN_TOP;
			text.selectable = false;
			text.text = s;
			addChild(text);

			nextY = text.y + text.height + TEXT_MARGIN_BOTTOM;
		}

		private function addColumnBreak():void {
			nextX += COLUMN_WIDTH + PADDING_X;
			nextY = TEXT_START_Y;
		}

		private function onClick(evt:MouseEvent):void {
			visible = false;
		}

		private function initBackground():void {
			this.x = Aeon.STAGE_WIDTH / 2 - WINDOW_WIDTH / 2;
			this.y = Aeon.STAGE_HEIGHT / 2 - WINDOW_HEIGHT / 2;
			
			//inivsibile region to capture mouse events
			graphics.beginFill(0, EditorPage.OVERLAY_ALPHA);
			graphics.drawRect(-x, -y, Aeon.STAGE_WIDTH, Aeon.STAGE_HEIGHT);
			graphics.endFill();
			
			//background
			var bg:Sprite = new Sprite();
			bg.graphics.lineStyle(BORDER_WIDTH, BORDER_COLOR);
			bg.graphics.beginFill(BG_COLOR, BG_ALPHA);
			bg.graphics.drawRoundRect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, CORNER_RADIUS, CORNER_RADIUS);
			bg.graphics.endFill();
			addChild(bg);
			
			//drop shadow
			var dropShadow:DropShadowFilter = new DropShadowFilter(SHADOW_DISTANCE, SHADOW_ANGLE, SHADOW_COLOR, SHADOW_ALPHA, SHADOW_BLUR_X, SHADOW_BLUE_Y, SHADOW_STRENGTH, BitmapFilterQuality.HIGH);
			bg.filters = [dropShadow];

			//title
			var title:Bitmap = new Bitmap(Assets.HELP_TITLE);
			title.x = WINDOW_WIDTH / 2 - title.width / 2;
			title.y = TITLE_Y;
			addChild(title);

			this.visible = false;
		}

		private function initCloseButton():void {
			var b:SquareButton = new SquareButton("Back", BUTTON_BG_COLOR_UP, BUTTON_BG_COLOR_OVER, BUTTON_BORDER_COLOR, BUTTON_WIDTH, BUTTON_HEIGHT);
			b.x = BUTTON_X;
			b.y = BUTTON_Y;
			b.addEventListener(MouseEvent.CLICK, onClick);
			addChild(b);
		}
	}
}
