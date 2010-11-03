package mfui.widgets.linkone
{
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
		}
		
		private function _creation_complete(e:FlexEvent):void
		{
			trace(this, e);
		}
		
		public function set tileContainer(tile_container:TileContainer):void
		{
			if (this._tile_container)
				throw new Error('tile container is already set');
			this._tile_container = tile_container;
		}
	}
}