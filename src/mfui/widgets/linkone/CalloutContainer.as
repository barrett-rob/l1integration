package mfui.widgets.linkone
{
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	public class CalloutContainer extends Canvas
	{
		private var _tile_container:TileContainer;
		
		public function CalloutContainer(tile_container:TileContainer)
		{
			super();
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creation_complete);
			this.setStyle('backgroundColor', '0x000000');
			this.z = 9999; /* floats */
			
			this._tile_container = tile_container;
		}
		
		private function _creation_complete(e:FlexEvent):void
		{
			this.width = this._tile_container.width;
			this.height = this._tile_container.height;
		}
	}
}