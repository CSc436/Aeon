package org.interguild.menu {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.interguild.KeyMan;

	public class ListBasedMenu extends Sprite {
		
		private static const ANIMATION_TIMER_DELAY:uint = 75;
		
		private var buttonSelect:Bitmap;
		private var buttonClick:Bitmap;
		
		private var animTimer:Timer;
		
		protected var selectedButton:int = 0;
		private var listOfButtons:Array;
		
		private var offsetX:int;
		private var offsetY:int;
		
		private var isEnabled:Boolean = true;
		
		public function ListBasedMenu(centerX:int, selectorOffsetY:int) {			
			//init selectors
			buttonSelect = new Bitmap(new MenuButtonSelectBG());
			buttonClick = new Bitmap(new MenuButtonClickBG());
			buttonSelect.visible = false;
			buttonClick.visible = false;
			addChild(buttonSelect);
			addChild(buttonClick);
			
			offsetX = centerX - buttonSelect.width / 2;
			offsetY = selectorOffsetY;
			
			listOfButtons = new Array();
			
			animTimer = new Timer(ANIMATION_TIMER_DELAY);
			animTimer.addEventListener(TimerEvent.TIMER, handleClick);
			
			buttonSelect.visible = true;
			
			KeyMan.getMe().addMenuCallback(onKeyDown);
		}
		
		protected function addButton(b:MovieClip):void{
			listOfButtons.push(b);
			
			b.addEventListener(MouseEvent.CLICK, handleClick);
			b.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			b.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		protected function selectItem(t:MovieClip):void {
			buttonSelect.x = offsetX;
			buttonSelect.y = t.y + offsetY;
			buttonSelect.visible = true;
			buttonClick.visible = false;
		}
		
		protected function simMouseDown(t:MovieClip):void {
			buttonClick.x = offsetX;
			buttonClick.y = t.y + offsetY;
			buttonClick.visible = true;
			buttonSelect.visible = false;
		}
		
		protected function handleClick(evt:Object = null):void {
			animTimer.stop();
			buttonSelect.visible = true;
			buttonClick.visible = false;
			onItemClicked(selectedButton);
		}
		
		private function onMouseDown(evt:MouseEvent):void {
			simMouseDown(MovieClip(evt.target));
		}
		
		private function onMouseOver(evt:MouseEvent):void {
			var t:MovieClip = MovieClip(evt.target);
			selectedButton = listOfButtons.indexOf(t);
			selectItem(MovieClip(evt.target));
		}
		
		private function pressItem(t:MovieClip):void {
			simMouseDown(t);
			animTimer.start();
		}
		
		private function onKeyDown(keyCode:uint):void {
			if (!isEnabled)
				return;
			switch (keyCode) {
				case 40: //down arrow key
					selectedButton++;
					if (selectedButton >= listOfButtons.length)
						selectedButton = 0;
					selectItem(MovieClip(listOfButtons[selectedButton]));
					break;
				case 38: //up arrow key
					selectedButton--;
					if (selectedButton < 0)
						selectedButton = listOfButtons.length - 1;
					selectItem(MovieClip(listOfButtons[selectedButton]));
					break;
				case 32: //spacebar
				case 13: //enter
					pressItem(MovieClip(listOfButtons[selectedButton]));
					break;
			}
		}
		
		public override function set visible(b:Boolean):void {
			super.visible = b;
			isEnabled = b;
			KeyMan.getMe().addMenuCallback(onKeyDown);
		}
		
		protected function onItemClicked(selectedButton:uint):void{
			throw new Error("A subclass must override this method");
		}
	}
}
