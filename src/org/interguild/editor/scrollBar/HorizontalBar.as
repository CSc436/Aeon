/***************************************************************************************************
* Website: www.warmforestflash.com
* Blog: www.warmforestflash.com/blog
* Email: hello@warmforestflash.com
* Feel free to use this code in any way you want other than selling it.
* Thanks. -Jay
***************************************************************************************************/

package org.interguild.editor.scrollBar
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.gs.OverwriteManager;
	import com.greensock.gs.TweenFilterLite;
	
	public class HorizontalBar extends Sprite
	{
		private var _content:DisplayObjectContainer;
		private var _trackColor:uint;
		private var _grabberColor:uint;
		private var _grabberPressColor:uint;
		private var _gripColor:uint;
		private var _trackThickness:int;
		private var _grabberThickness:int;
		private var _easeAmount:int;
		private var _hasShine:Boolean;
		
		private var _track:Sprite;
		private var _grabber:Sprite;
		private var _grabberGrip:Sprite;
		private var _grabberArrow1:Sprite;
		private var _grabberArrow2:Sprite;
		
		private var _tH:Number; // Track height
		private var _cH:Number; // Content height
		private var _scrollValue:Number;
		private var _defaultPosition:Number;
		private var _stageW:Number;
		private var _stageH:Number;
		private var _pressed:Boolean = false;
		
		//============================================================================================================================
		public function HorizontalBar(c:DisplayObjectContainer, tc:uint, gc:uint, gpc:uint, grip:uint, tt:int, gt:int, ea:int, hs:Boolean)
		//============================================================================================================================
		{
			_content = c;
			_trackColor = tc;
			_grabberColor = gc;
			_grabberPressColor = gpc;
			_gripColor = grip;
			_trackThickness = tt;
			_grabberThickness = gt;
			_easeAmount = ea;
			_hasShine = hs;
			init();
			OverwriteManager.init();
		}
		
		//============================================================================================================================
		private function init():void
		//============================================================================================================================
		{
			createTrack();
			createGrabber();
			createGrips();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			_defaultPosition = Math.round(_content.x);
			_grabber.x = 0;
		}
		
		//============================================================================================================================
		public function kill():void
		//============================================================================================================================
		{
			stage.removeEventListener(Event.RESIZE, onStageResize);
		}
		
		//============================================================================================================================
		private function stopScroll(e:Event):void
		//============================================================================================================================
		{
			onUpListener();
		}
		
		//============================================================================================================================
		private function scrollContent(e:Event):void
		//============================================================================================================================
		{
			var ty:Number;
			var dist:Number;
			var moveAmount:Number;
			
			ty = -((_cH - _tH) * (_grabber.x / _scrollValue));
			dist = ty - _content.x + _defaultPosition;
			moveAmount = dist / _easeAmount;
			_content.x += Math.round(moveAmount);
			
			if (Math.abs(_content.x - ty - _defaultPosition) < 1.5)
			{
				_grabber.removeEventListener(Event.ENTER_FRAME, scrollContent);
				_content.x = Math.round(ty) + _defaultPosition;
			}
			
			positionGrips();
		}
		
		//============================================================================================================================
		public function adjustSize():void
		//============================================================================================================================
		{
			this.y = _stageH - _trackThickness;
			_track.width = _stageW;
			_track.x = 0;
			_tH = _track.width;
			_cH = _content.width + _defaultPosition;
			
			// Set height of grabber relative to how much content
			_grabber.getChildByName("bg").width = Math.ceil((_tH / _cH) * _tH);
			
			// Set minimum size for grabber
			if(_grabber.getChildByName("bg").width < 35) _grabber.getChildByName("bg").width = 35;
			if(_hasShine) _grabber.getChildByName("shine").width = _grabber.getChildByName("bg").width;
			
			// If scroller is taller than stage height, set its y position to the very bottom
			if ((_grabber.x + _grabber.getChildByName("bg").width) > _tH) _grabber.x = _tH - _grabber.getChildByName("bg").width;
			
			// If content height is less than stage height, set the scroller y position to 0, otherwise keep it the same
			_grabber.x = (_cH < _tH) ? 0 : _grabber.x;
			
			// If content height is greater than the stage height, show it, otherwise hide it
			this.visible = (_cH + 8 > _tH);
			
			// Distance left to scroll
			_scrollValue = _tH - _grabber.getChildByName("bg").width;
			
			_content.x = Math.round(-((_cH - _tH) * (_grabber.x / _scrollValue)) + _defaultPosition);
			
			positionGrips();
			
			if(_content.width < stage.stageWidth) { stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener); } else { stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener); }
		}
		
		//============================================================================================================================
		private function positionGrips():void
		//============================================================================================================================
		{
			_grabberGrip.x = Math.ceil(_grabber.getChildByName("bg").x + (_grabber.getChildByName("bg").width / 2) - (_grabberGrip.width / 2));
			_grabberArrow1.x = _grabber.getChildByName("bg").x + 8;
			_grabberArrow2.x = _grabber.getChildByName("bg").width - 8;
		}
		
		
		
		
		//============================================================================================================================
		
		
		// CREATORS
		
		
		//============================================================================================================================
		
		//============================================================================================================================
		private function createTrack():void
		//============================================================================================================================
		{
			_track = new Sprite();
			var t:Sprite = new Sprite();
			t.graphics.beginFill(_trackColor); 
			t.graphics.drawRect(0, 0, _trackThickness, _trackThickness);
			t.graphics.endFill();
			_track.addChild(t);
			addChild(_track);
		}
		
		//============================================================================================================================
		private function createGrabber():void
		//============================================================================================================================
		{
			_grabber = new Sprite();
			var t:Sprite = new Sprite();
			t.graphics.beginFill(_grabberColor); 
			t.graphics.drawRect(0, 0, _grabberThickness, _grabberThickness);
			t.graphics.endFill();
			t.name = "bg";
			_grabber.addChild(t);
			
			if(_hasShine)
			{
				var shine:Sprite = new Sprite();
				var sg:Graphics = shine.graphics;
				sg.beginFill(0xffffff, 0.15);
				sg.drawRect(0, 0, Math.ceil(_trackThickness/2), _trackThickness);
				sg.endFill();
				shine.x = Math.floor(_trackThickness/2);
				shine.name = "shine";
				_grabber.addChild(shine);
			}
			
			addChild(_grabber);
		}
		
		//============================================================================================================================
		private function createGrips():void
		//============================================================================================================================
		{
			_grabberGrip = createGrabberGrip();
			_grabber.addChild(_grabberGrip);
			
			_grabberArrow1 = createPixelArrow();
			_grabber.addChild(_grabberArrow1);
			
			_grabberArrow2 = createPixelArrow();
			_grabber.addChild(_grabberArrow2);
			
			_grabberArrow1.rotation = -90;
			_grabberArrow1.y = ((_grabberThickness - 7) / 2) + 1;
			_grabberArrow2.rotation = 90;
			_grabberArrow2.y = ((_grabberThickness - 7) / 2) + 6;
		}
		
		//============================================================================================================================
		private function createGrabberGrip():Sprite
		//============================================================================================================================
		{
			var w:int = 7;
			var xp:int = (_grabberThickness - w) / 2;
			var t:Sprite = new Sprite();
			t.graphics.beginFill(_gripColor, 1);
			t.graphics.drawRect(xp, 0, w, 1);
			t.graphics.drawRect(xp, 0 + 2, w, 1);
			t.graphics.drawRect(xp, 0 + 4, w, 1);
			t.graphics.drawRect(xp, 0 + 6, w, 1);
			t.graphics.drawRect(xp, 0 + 8, w, 1);
			t.graphics.endFill();
			return t;
		}
		
		//============================================================================================================================
		private function createPixelArrow():Sprite
		//============================================================================================================================
		{
			var t:Sprite = new Sprite();			
			t.graphics.beginFill(_gripColor, 1);
			t.graphics.drawRect(0, 0, 1, 1);
			t.graphics.drawRect(1, 1, 1, 1);
			t.graphics.drawRect(2, 2, 1, 1);
			t.graphics.drawRect(1, 3, 1, 1);
			t.graphics.drawRect(0, 4, 1, 1);
			t.graphics.endFill();
			return t;
		}
		
		
		
		
		//============================================================================================================================
		
		
		// LISTENERS
		
		
		//============================================================================================================================
		
		//============================================================================================================================
		private function mouseWheelListener(me:MouseEvent):void
		//============================================================================================================================
		{
			var d:Number = me.delta;
			if (d > 0)
			{
				if ((_grabber.x - (d * 4)) >= 0)
				{
					_grabber.x -= d * 4;
				}
				else
				{
					_grabber.x = 0;
				}
				
				if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
			else
			{
				if (((_grabber.x + _grabber.height) + (Math.abs(d) * 4)) <= stage.stageWidth)
				{
					_grabber.x += Math.abs(d) * 4;
				}
				else
				{
					_grabber.x = stage.stageWidth - _grabber.width;
				}
				if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent);
			}
		}
		
		//============================================================================================================================
		private function onDownListener(e:MouseEvent):void
		//============================================================================================================================
		{
			_pressed = true;
			_grabber.startDrag(false, new Rectangle(0, 0, _stageW - _grabber.getChildByName("bg").width, 0));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener, false, 0, true);
			TweenFilterLite.to(_grabber.getChildByName("bg"), 0.5, { tint:_grabberPressColor } );
		}
		
		//============================================================================================================================
		private function onUpListener(e:MouseEvent = null):void
		//============================================================================================================================
		{
			if (_pressed)
			{
				_pressed = false;
				_grabber.stopDrag();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener);
				TweenFilterLite.to(_grabber.getChildByName("bg"), 0.5, { tint:null } );
			}
		}
		
		//============================================================================================================================
		private function onMouseMoveListener(e:MouseEvent):void
		//============================================================================================================================
		{
			e.updateAfterEvent();
			if (!_grabber.willTrigger(Event.ENTER_FRAME)) _grabber.addEventListener(Event.ENTER_FRAME, scrollContent, false, 0, true);
		}
		
		//============================================================================================================================
		private function onTrackClick(e:MouseEvent):void
		//============================================================================================================================
		{
			var p:int;
			var s:int = 150;
			
			p = Math.ceil(e.stageY);
			if(p < _grabber.x)
			{
				if(_grabber.x < _grabber.width)
				{
					TweenFilterLite.to(_grabber, 0.5, {x:0, onComplete:reset, overwrite:1});
				}
				else
				{
					TweenFilterLite.to(_grabber, 0.5, {x:"-150", onComplete:reset});
				}
				
				if(_grabber.x < 0) _grabber.x = 0;
			}
			else
			{
				if((_grabber.x + _grabber.width) > (_stageW - _grabber.width))
				{
					TweenFilterLite.to(_grabber, 0.5, {x:_stageW - _grabber.width, onComplete:reset, overwrite:1});
				}
				else
				{
					TweenFilterLite.to(_grabber, 0.5, {x:"150", onComplete:reset});
				}
				
				if(_grabber.x + _grabber.getChildByName("bg").width > _track.width) _grabber.x = stage.stageWidth - _grabber.getChildByName("bg").width;
			}
			
			function reset():void
			{
				if(_grabber.x < 0) _grabber.x = 0;
				if(_grabber.x + _grabber.getChildByName("bg").width > _track.width) _grabber.x = stage.stageWidth - _grabber.getChildByName("bg").width;
			}
			
			_grabber.addEventListener(Event.ENTER_FRAME, scrollContent, false, 0, true);
		}
		
		//============================================================================================================================
		private function onAddedToStage(e:Event):void
		//============================================================================================================================
		{
			stage.addEventListener(Event.MOUSE_LEAVE, stopScroll);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelListener);
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpListener, false, 0, true);
			_grabber.addEventListener(MouseEvent.MOUSE_DOWN, onDownListener, false, 0, true);
			_grabber.buttonMode = true;
			_track.addEventListener(MouseEvent.CLICK, onTrackClick, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_stageW = 565;
			_stageH = stage.stageHeight;
			adjustSize();
		}
		
		//============================================================================================================================
		private function onStageResize(e:Event):void
		//============================================================================================================================
		{
			_stageW = 565;
			_stageH = stage.stageHeight;
			adjustSize();
		}
		
	}
}