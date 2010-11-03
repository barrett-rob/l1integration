package mfui.widgets.linkone
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.core.FlexSprite;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.primitives.Ellipse;
	
	public class CalloutContainer extends LayoutContainer
	{
		private var _tile_container:TileContainer;
		
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
			trace(this, e);
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('click at ' + e.localX + ':' + e.localY);
			
			this.addChild(new Callout(e.localX, e.localY));
		}
		
		private function _wheel(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* source point is */
			var p:Point = new Point(e.localX, e.localY);
			/* display tile */
			_tile_container.display_tile(e.delta, p);
		}
		
		public function set tileContainer(tile_container:TileContainer):void
		{
			if (this._tile_container)
				throw new Error('tile container is already set');
			this._tile_container = tile_container;
		}
	}
}