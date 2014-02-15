package loadandsave
{
	import fl.controls.ProgressBar;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	public class ProgressStateView extends Sprite
	{
		// ------- Child controls -------
		public var _progressBar:ProgressBar;
		public var _progressTxt:Label;
		
		
		// ------- Constructor -------
		public function ProgressStateView()
		{
			addEventListener(Event.ADDED, setupChildren);
		}
		
		
		// ------- Public Properties -------
		private var _label:String;
		
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
			updateLabel();
		}
		
		
		public function get source():Object
		{
			return _progressBar.source;
		}
		public function set source(value:Object):void
		{
			_progressBar.source = value;
		}
		
		
		// ------- Event Handling -------
		private function setupChildren(event:Event):void
		{
			removeEventListener(Event.ADDED, setupChildren);
			
			_progressBar.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_progressBar.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		
		private function progressHandler(event:ProgressEvent):void
		{
			updateLabel();
		}
		
		
		private function completeHandler(event:Event):void
		{
			updateLabel();
		}
		
		
		// ------- Private Methods -------
		private function updateLabel():void
		{
			if (_progressBar.percentComplete > 0 && _progressBar.percentComplete < 100)
			{
				_progressTxt.text = _label + " (" + Math.round(_progressBar.percentComplete).toString() + "%)";
			}
			else
			{
				_progressTxt.text = _label;
			}
		}
	}
}