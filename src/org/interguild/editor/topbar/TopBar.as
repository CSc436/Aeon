package org.interguild.editor.topbar {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import org.interguild.editor.EditorPage;
	import org.interguild.menu.FancyButton;

	public class TopBar extends Sprite {

		private static const NEW_LEVEL_ICON:String = "icons/new-level-icon.png";
		private static const OPEN_LEVEL_ICON:String = "icons/open-level-icon.png";
		private static const SAVE_LEVEL_ICON:String = "icons/save-level-icon.png";
		private static const UNDO_ICON:String = "icons/undo-icon.png";
		private static const REDO_ICON:String = "icons/redo-icon.png";
		private static const LEVEL_PROPS_ICON:String = "icons/level-properties-icon.png";
		private static const ZOOM_IN_ICON:String = "icons/zoom-in-icon.png";
		private static const ZOOM_OUT_ICON:String = "icons/zoom-out-icon.png";
		private static const HELP_ICON:String = "icons/help-icon.png";
		
		private static const ICON_ROLLOVER:String = "icons/rollover.png";
		private static const ICON_CLICK:String = "icons/onclick.png";
		
		private static const ICON_PADDING_TOP:uint = 1;
		private static const ICON_PADDING_LEFT:uint = 100;
		private static const ICON_WIDTH:uint = 48;
		private static const ICON_SPACING:uint = 0;

		private var iconX:Number = ICON_PADDING_LEFT;
		private var iconRollover:Loader;
		private var iconClick:Loader;

		private var editor:EditorPage;
		private var fileButton:FileMenu;

		public function TopBar(editor:EditorPage) {
			this.editor = editor;

			initBG();
			initIcons();
			initButtons();
			initFileButton();
		}

		private function initBG():void {
			var bg:Bitmap = new Bitmap(new EditorTopBarSprite());
			addChild(bg);
		}

		private function initIcons():void {
			//rollover image
			iconRollover = new Loader();
			iconRollover.load(new URLRequest(ICON_ROLLOVER));
			iconRollover.visible = false;
			iconRollover.y = ICON_PADDING_TOP;
			addChild(iconRollover);
			
			//on click image
			iconClick = new Loader();
			iconClick.load(new URLRequest(ICON_CLICK));
			iconClick.visible = false;
			iconClick.y = ICON_PADDING_TOP;
			addChild(iconClick);

			//all the icons
			loadIcon(NEW_LEVEL_ICON, "New Level", function(evt:MouseEvent):void{
				editor.newLevel();
			});
			loadIcon(OPEN_LEVEL_ICON, "Open Level", function(evt:MouseEvent):void{
				editor.openFromFile();
			});
			loadIcon(SAVE_LEVEL_ICON, "Save Level", function(evt:MouseEvent):void{
				editor.saveToFile();
			});
			loadIcon(UNDO_ICON, "Undo", function(evt:MouseEvent):void{
				editor.undo();
			});
			loadIcon(REDO_ICON, "Redo", function(evt:MouseEvent):void{
				editor.redo();
			});
			loadIcon(ZOOM_IN_ICON, "Zoom In", function(evt:MouseEvent):void{
				editor.zoomIn();
			});
			loadIcon(ZOOM_OUT_ICON, "Zoom Out", function(evt:MouseEvent):void{
				editor.zoomOut();
			});
			loadIcon(LEVEL_PROPS_ICON, "Level Properties", function(evt:MouseEvent):void{
				trace("TODO");
			});
			loadIcon(HELP_ICON, "Help", function(evt:MouseEvent):void{
				trace("TODO");
			});
		}

		private function loadIcon(iconURL:String, toolTip:String, onClick:Function):void {
			var image:Loader = new Loader();
			image.load(new URLRequest(iconURL));

			var s:Sprite = new Sprite();
			s.x = iconX;
			s.y = ICON_PADDING_TOP;
			s.buttonMode = true;
			s.mouseChildren = false;
			s.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
			s.addEventListener(MouseEvent.MOUSE_OUT, onIconOut);
			s.addEventListener(MouseEvent.MOUSE_DOWN, onIconDown);
			s.addEventListener(MouseEvent.MOUSE_UP, onIconUp);
			s.addEventListener(MouseEvent.CLICK, onClick);
			s.addChild(image);
			addChild(s);

			var tt:ToolTip = new ToolTip(s, toolTip);
			addChild(tt);

			iconX += ICON_WIDTH + ICON_SPACING;
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
			publishButton.x = 734;
			publishButton.y = 18;
			//todo make button publish to website
			addChild(publishButton);
		}

		private function initFileButton():void {
			fileButton = new FileMenu(editor);
			addChild(fileButton);
		}

		public function toggleMenu():void {
			fileButton.toggleMenu();
		}

		public function hideMenu():void {
			fileButton.hideMenu();
		}
	}
}
