package loadandsave
{
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	[Event(name="select", type="flash.events.Event")]
	public class SaveCompleteStateView extends Sprite
	{
		// ------- Child controls -------
		public var _restartBtn:Button;
		
		
		// ------- Constructor -------
		public function SaveCompleteStateView()
		{
			addEventListener(Event.ADDED, setupChildren);
		}
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			var restartBtnText:TextFormat = new TextFormat();
			restartBtnText.size = 16;
			_restartBtn.setStyle("textFormat", restartBtnText);
			
			_restartBtn.addEventListener(MouseEvent.CLICK, restartClickHandler);
		}
		
		
		private function restartClickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}