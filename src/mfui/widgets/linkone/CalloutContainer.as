package mfui.widgets.linkone
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
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
		private var _callout_data:XMLListCollection;
		
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
		}
		
		public function set_size(w:int, h:int):void
		{
			this.width = w;
			this.height = h;
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
			display_callouts();
		}
		
		internal function display_callouts():void
		{
			trace('displaying callouts');
			this.removeAllChildren();
			for each (var c:XML in this._callout_data.children())
			{
				if (c.localName() == 'rectangularCallout')
				{
					this.addChild(new Callout(c));
				} 
				else
				{
					trace('callout nodes of type', c.localName(), 'not handled');
				}
			}
		}
		
		
	}
}