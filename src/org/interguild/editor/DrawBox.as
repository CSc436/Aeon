package org.interguild.editor
{
	
	/**
	 * Draw Box class
	 * ---------------------
	 * VERSION: 1.0
	 * DATE: 11/14/2010
	 * AS3
	 
	 **/
	
	{
		import flash.display.DisplayObjectContainer;
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.MouseEvent;
		
		import org.interguild.Aeon;
		
		public class DrawBox extends Sprite
		{
			private var _canvas:DisplayObjectContainer;
			private var _startX:Number;
			private var _startY:Number;
			private var _endX:Number;
			private var _endY:Number;
		    	
			public function DrawBox($canvas:DisplayObjectContainer, $startX:Number, $startY:Number)
			{
				_canvas = $canvas;
				_startX = $startX;
				_startY = $startY;
				_endX = mouseX;
				_endY = mouseY;
				
				this.mouseEnabled=false;
				
				_canvas.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, true);
				
				_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler, true);
				Aeon.getMe().stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false);
			}
			
			private function onMouseMoveHandler(event:MouseEvent):void
			{
				//trace('moving');
				_endX = mouseX;
				_endY = mouseY;
			}
			
			private function onMouseUpHandler(event:MouseEvent):void
			{
				_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				_canvas.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				Aeon.getMe().stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
			
			private function onEnterFrameHandler(event:Event):void
			{
	//			trace('drawing rect');
				graphics.clear();
				graphics.lineStyle(2, 0x88B1CC);
				graphics.moveTo(_startX, _startY);
				graphics.beginFill(0x88B1CC, .25);
				graphics.lineTo(_endX, _startY);
				graphics.lineTo(_endX, _endY);
				graphics.lineTo(_startX, _endY);
				graphics.lineTo(_startX, _startY);
				graphics.endFill();
			}
			
			public function get startX():int{
				return _startX;
			}
			public function get startY():int{
				return _startY;
			}
			public function get endX():int{
				return _endX;
			}
			public function get endY():int{
				return _endY;
			}
		}
	}
}