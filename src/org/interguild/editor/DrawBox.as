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
		import flash.events.MouseEvent;
		import flash.display.Sprite;
		import flash.events.Event;
		
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
				
				_canvas.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				_canvas.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				_canvas.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
			
			private function onMouseMoveHandler(event:MouseEvent):void
			{
				_endX = mouseX;
				_endY = mouseY;
			}
			
			private function onMouseUpHandler(event:MouseEvent):void
			{
				trace('removed');
				_canvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
				_canvas.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
				_canvas.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			}
			
			private function onEnterFrameHandler(event:Event):void
			{
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
		}
	}
}