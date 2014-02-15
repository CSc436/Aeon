package loadandsave
{
	import fl.controls.Button;
	import fl.managers.StyleManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	[Event(name="select", type="flash.events.Event")]
	public class LoadStateView extends Sprite
	{
		// ------- Child controls -------
		public var _loadImageBtn:Button;
		
		
		// ------- Private vars -------
		private var loadBtnText:TextFormat;
		
		
		// ------- Constructor -------
		public function LoadStateView()
		{
			addEventListener(Event.ADDED, setupChildren);
		}


		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			loadBtnText = new TextFormat();
			loadBtnText.size = 16;
			_loadImageBtn.setStyle("textFormat", loadBtnText);
			
			_loadImageBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		
		private function clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}