package org.interguild.editor.topbar {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import org.interguild.Assets;
	import org.interguild.components.FancyButton;
	import org.interguild.editor.EditorPage;

	public class TopBar extends Sprite {

		private static const ICON_PADDING_TOP:uint = 1;
		private static const ICON_PADDING_LEFT:uint = 100;
		private static const ICON_WIDTH:uint = 48;
		private static const ICON_SPACING:uint = 0;

		private static const DISABLED_ALPHA:Number = 0.5;

		private var iconX:Number = ICON_PADDING_LEFT;
		private var iconRollover:Bitmap;
		private var iconClick:Bitmap;

		private var undoBtn:Sprite;
		private var redoBtn:Sprite;
		private var zoomInBtn:Sprite;
		private var zoomOutBtn:Sprite;

		private var editor:EditorPage;
		private var fileButton:FileMenu;

		public function TopBar(editor:EditorPage) {
			this.editor = editor;

			initIcons();
			initPlayAndPublishButtons();
			initFileButton();
		}

		private function initIcons():void {
			//rollover image
			iconRollover = new Bitmap(Assets.EDITOR_ICON_BG_ON_OVER);
			iconRollover.visible = false;
			iconRollover.y = ICON_PADDING_TOP;
			addChild(iconRollover);

			//on click image
			iconClick = new Bitmap(Assets.EDITOR_ICON_BG_ON_CLICK);
			iconClick.visible = false;
			iconClick.y = ICON_PADDING_TOP;
			addChild(iconClick);

			//all the icons
			initIcon(Assets.EDITOR_ICON_NEW, "New Level (Ctrl+N)", function(evt:MouseEvent):void {
				editor.newLevel();
			});

			initIcon(Assets.EDITOR_ICON_OPEN, "Open Level (Ctrl+O)", function(evt:MouseEvent):void {
				editor.openFromFile();
			});

			initIcon(Assets.EDITOR_ICON_SAVE, "Save Level (Ctrl+S)", function(evt:MouseEvent):void {
				editor.saveToFile();
			});

			undoBtn = initIcon(Assets.EDITOR_ICON_UNDO, "Undo (Ctrl+Z)", function(evt:MouseEvent):void {
				editor.undo();
			});
			disable(undoBtn);

			redoBtn = initIcon(Assets.EDITOR_ICON_REDO, "Redo (Ctrl+Y)", function(evt:MouseEvent):void {
				editor.redo();
			});
			disable(redoBtn);

			zoomInBtn = initIcon(Assets.EDITOR_ICON_ZOOM_IN, "Zoom In (Ctrl++)", function(evt:MouseEvent):void {
				editor.zoomIn();
			});
			disable(zoomInBtn);

			zoomOutBtn = initIcon(Assets.EDITOR_ICON_ZOOM_OUT, "Zoom Out (Ctrl+–)", function(evt:MouseEvent):void {
				editor.zoomOut();
			});

			initIcon(Assets.EDITOR_ICON_LEVEL_PROPS, "Level Properties", function(evt:MouseEvent):void {
				editor.showLevelProperties();
			});

			initIcon(Assets.EDITOR_ICON_HELP, "Help", function(evt:MouseEvent):void {
				editor.showHelpScreen();
			});
		}

		private function initIcon(image:BitmapData, toolTip:String, onClick:Function):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginBitmapFill(image);
			s.graphics.drawRect(0, 0, image.width, image.height);
			s.graphics.endFill();
			s.x = iconX;
			s.y = ICON_PADDING_TOP;
			s.buttonMode = true;
			s.mouseChildren = false;
			s.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
			s.addEventListener(MouseEvent.MOUSE_OUT, onIconOut);
			s.addEventListener(MouseEvent.MOUSE_DOWN, onIconDown);
			s.addEventListener(MouseEvent.MOUSE_UP, onIconUp);
			s.addEventListener(MouseEvent.CLICK, onClick);
			addChild(s);

			var tt:ToolTip = new ToolTip(s, toolTip);
			addChild(tt);

			iconX += ICON_WIDTH + ICON_SPACING;

			return s;
		}

		private function onIconOver(evt:MouseEvent):void {
			iconRollover.x = DisplayObject(evt.target).x;
			iconRollover.visible = true;
			iconClick.visible = false;
		}

		private function onIconOut(evt:MouseEvent):void {
			iconRollover.visible = false;
		}

		private function onIconDown(evt:MouseEvent):void {
			iconClick.x = DisplayObject(evt.target).x;
			iconClick.visible = true;
			iconRollover.visible = false;
		}

		private function onIconUp(evt:MouseEvent):void {
			iconRollover.x = DisplayObject(evt.target).x;
			iconRollover.visible = true;
			iconClick.visible = false;
		}

		private function initPlayAndPublishButtons():void {
			var up:DisplayObject;
			var over:DisplayObject;
			var hit:Sprite;

			//init play level button
			up = new Bitmap(Assets.PLAY_LEVEL_BUTTON);
			over = new Bitmap(Assets.PLAY_LEVEL_ROLLOVER);
			hit = new Sprite();
			hit.graphics.beginFill(0, 0); //define button's hit region
			hit.graphics.moveTo(25, 1);
			hit.graphics.lineTo(200, 1);
			hit.graphics.lineTo(175, 47);
			hit.graphics.lineTo(0, 47);
			hit.graphics.lineTo(25, 1);
			hit.graphics.endFill();
			var playGameButton:FancyButton = new FancyButton(up, over, hit);
			playGameButton.x = 549;
			playGameButton.y = 19;
			playGameButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				editor.playLevel();
			});
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
			publishButton.x = 738;
			publishButton.y = 19;
			//todo make button publish to website
			addChild(publishButton);
		}

		private function initFileButton():void {
			fileButton = new FileMenu(editor);
			addChild(fileButton);
		}
		
		private function disable(s:Sprite):void {
			s.alpha = DISABLED_ALPHA;
			s.mouseEnabled = false;
		}
		
		private function enable(s:Sprite):void {
			s.alpha = 1;
			s.mouseEnabled = true;
		}
		
		public function enableZoomIn():void{
			enable(zoomInBtn);
		}
		
		public function enableZoomOut():void{
			enable(zoomOutBtn);
		}
		
		public function disableZoomIn():void{
			disable(zoomInBtn);
		}
		
		public function disableZoomOut():void{
			disable(zoomOutBtn);
		}

		public function toggleMenu():void {
			fileButton.toggleMenu();
		}

		public function hideMenu():void {
			fileButton.hideMenu();
		}
	}
}
