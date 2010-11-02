package mfui.widgets.linkone
{
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	public class CalloutContainer extends Canvas
	{
		private var _tile_container:TileContainer;
		
		public function CalloutContainer()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creation_complete);
			this.setStyle('backgroundColor', '0x000000');
			this.z = 9999; /* floats */
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
			this.width = this.height = tile_container.VIRTUAL_TILE_SIZE;
		}
	}
}