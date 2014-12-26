package org.interguild.editor.levelprops {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.interguild.components.DropdownMenu;

	public class PictureMenu extends DropdownMenu {

		private static const IMAGE_X:uint = 6;
		private static const IMAGE_Y:uint = 5;
		private static const IMAGE_WIDTH:uint = 46;
		private static const IMAGE_HEIGHT:uint = 32;

		private var props:LevelPropertiesScreen;

		private var id:uint = 0;
		private var hasPicture:Boolean;

		private var upFace:Bitmap;
		private var overFace:Bitmap;
		private var clickFace:Bitmap;

		private var items:Array;

		public function PictureMenu(props:LevelPropertiesScreen) {
			super(false);
			this.props = props;
			this.items = [];

			upFace = new Bitmap(new PictureButtonUp());
			overFace = new Bitmap(new PictureButtonOver());
			clickFace = new Bitmap(new PictureButtonOver());
			initButton(upFace, overFace);
			clickFace.visible = false;
			addChild(clickFace);
		}

		public function addItem(id:uint, image:BitmapData, name:String):void {
			var bd:BitmapData = new BitmapData(IMAGE_WIDTH, IMAGE_HEIGHT);
			bd.copyPixels(image, new Rectangle(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT), new Point(0, 0));

			var item:PictureMenuItem = new PictureMenuItem(id, bd, name, onSelect);
			super.addItem(item);
			items.push(item);

			if (!hasPicture) {
				hasPicture = true;
				placePicture(bd);
			}
		}

		private function placePicture(img:BitmapData):void {
			var b:Bitmap = new Bitmap(img);
			b.x = IMAGE_X;
			b.y = IMAGE_Y;
			addChild(b);
		}

		protected override function showPopup():void {
//			popup.x = clickFace.width+1;
			popup.y = -popup.height / 2;
			super.showPopup();
			clickFace.visible = true;
		}

		protected override function hidePopup(evt:MouseEvent = null):void {
			super.hidePopup(evt);
			clickFace.visible = false;
		}

		private function onSelect(evt:MouseEvent):void {
			if (evt.target is PictureMenuItem) {
				var item:PictureMenuItem = PictureMenuItem(evt.target);
				placePicture(item.picture);
				id = item.id;

				var e:Event = new Event(Event.CHANGE);
				this.dispatchEvent(e);
			}
		}

		public function get currentID():uint {
			return id;
		}

		public function set currentID(id:uint):void {
			for each(var item:PictureMenuItem in items){
				if (item.id == id) {
					placePicture(item.picture);
					return;
				}
			}
		}
	}
}
