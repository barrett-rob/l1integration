package mfui.widgets.linkone
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.XMLListCollection;
	import mx.containers.Canvas;
	import mx.core.FlexSprite;
	import mx.core.LayoutContainer;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.primitives.Ellipse;
	
	public class CalloutContainer extends LayoutContainer
	{
		public var tileContainer:TileContainer;
		
		private var _default_size:Rectangle;
		private var _callout_data:XMLListCollection;
		private var _callouts:Array;
		
		public function CalloutContainer()
		{
			super();
			this.layout = "absolute";
			this.left = this.top = 0;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creation_complete);
			this.addEventListener(MouseEvent.CLICK, _click);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _wheel);
			
			this.setStyle('backgroundColor', '0xccffcc');
			this.setStyle('backgroundAlpha', '0.1');
		}
		
		private function _creation_complete(e:FlexEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* the container itself is not interesting */
			this.width = this.height = 1;
		}
		
		public function set_default_size(w:int, h:int):void
		{
			this._default_size = new Rectangle(0, 0, w, h);
		}
		
		public function set_level_size(w:int, h:int):void
		{
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
		}
		
		private function _wheel(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* source point is */
			var p:Point = new Point(e.localX, e.localY);
			/* display tile */
			//_tile_container.display_tile(e.delta, p);
		}
		
		public function set calloutData(callout_data:XMLListCollection):void
		{
			if (this._callout_data)
				throw new Error('callout data is already set');
			this._callout_data = callout_data;
			this._callout_data.addEventListener(CollectionEvent.COLLECTION_CHANGE, _callout_data_change);
			this._callout_data.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
		}
		
		private function _callout_data_change(e:CollectionEvent):void
		{
			if (e.currentTarget != this._callout_data)
				return;
			
			create_callouts();
			display_callouts();
		}
		
		internal function create_callouts():void
		{
			_callouts = new Array();
			for each (var c:XML in this._callout_data.children())
			{
				if (c.localName() == 'rectangularCallout')
				{
					_callouts.push((new Callout(c, 1)));
				} 
				else
				{
					trace('callout nodes of type', c.localName(), 'not handled');
				}
			}
		}
		
		internal function display_callouts():void
		{
			if (!_callouts)
				return;
			
			this.removeAllChildren();
			for each (var c:Callout in _callouts)
			{
				this.addChild(c);
			}
			
		}
		
		
	}
}