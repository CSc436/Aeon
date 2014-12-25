package org.interguild.menu {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class LevelListItem extends Sprite {
		
		private static const HEIGHT:int = 30;
		private static const PADDING:int = 2;
		private static const BG_COLOR:uint = 0x1b779c;
		private static const BG_COLOR_ROLLOVER:uint = 0x2c93b1;
		
		private var bg1:Sprite;
		private var bg2:Sprite;
		
		private var title:TextField;
		private var author:TextField
		private var date:TextField
		
		private var ID:uint;
		
		public function LevelListItem(xml:XML, width:Number) {
			ID = xml.@id;
//			var sw:int = Aeon.getMe().stage.stageWidth;
			var sw:int = width;
			
			buttonMode = true;
			mouseChildren = false;
			
			bg1 = new Sprite();
			bg1.graphics.beginFill(BG_COLOR);
			bg1.graphics.drawRect(0,0,sw,HEIGHT);
			bg1.graphics.endFill();
			addChild(bg1);
			
			bg2 = new Sprite();
			bg2.graphics.beginFill(BG_COLOR_ROLLOVER);
			bg2.graphics.drawRect(0,0,sw,HEIGHT);
			bg2.graphics.endFill();
			bg2.visible = false;
			addChild(bg2);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut,false,0,true);
			
			title = new TextField();
			title.defaultTextFormat = new TextFormat("Arial", 13, 0xFFFFFF,true);
			title.autoSize = TextFieldAutoSize.LEFT;
			title.selectable = false;
			title.x = 10;
			title.y = 4;
			title.text = xml.title;
			addChild(title);
			
			var format:TextFormat = new TextFormat("Arial", 13, 0xFFFFFF);
			
			author = new TextField();
			author.defaultTextFormat = format
			author.autoSize = TextFieldAutoSize.LEFT;
			author.selectable = false;
			author.x = sw - 310;
			var limit:Number = title.x + title.width+2;
			if(author.x < limit){
				author.x = limit;
			}
			author.y = 4;
			author.text = xml.author;
			addChild(author);
			
			date = new TextField();
			date.defaultTextFormat = format
			date.autoSize = TextFieldAutoSize.LEFT;
			date.selectable = false;
			date.x = sw - 104;
			var limit2:Number = author.x + author.width+2;
			if(date.x < limit2){
				date.x = limit2; 
			}
			date.y = 4;
			date.text = xml.date;
			addChild(date);
		}
		
		private function onOver(evt:MouseEvent):void{
			bg2.visible = true;
			bg1.visible = false;
		}
		
		private function onOut(evt:MouseEvent):void{
			bg1.visible = true;
			bg2.visible = false;
		}
		
		public override function get height():Number{
			return HEIGHT + PADDING;
		}
		
		public override function set width(newWidth:Number):void{
			bg1.width = bg2.width = newWidth;
			
			author.x = newWidth - 310;
			var limit1:Number = title.x + title.width+2;
			if(author.x < limit1){
				author.x = limit1; 
			}
			
			date.x = newWidth - 104;
			var limit2:Number = author.x + author.width+2;
			if(date.x < limit2){
				date.x = limit2; 
			}
		}
		
		public function get id():uint{
			return ID;
		}
	}
}
