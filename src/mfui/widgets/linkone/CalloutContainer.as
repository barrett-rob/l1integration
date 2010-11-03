package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
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
			
		}
		
		public function set tileContainer(tile_container:TileContainer):void
		{
			if (this._tile_container)
				throw new Error('tile container is already set');
			this._tile_container = tile_container;
		}
	}
}