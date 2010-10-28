package mfui.widgets.linkone
{
	import flash.events.Event;
	
	import mx.controls.Image;
	
	public class TileImage extends Image
	{
		
		public static const uri_root:String = 'http://a028856:8080/ria/linkone?';
		
		private var _tile:Tile;
		
		public function TileImage(tile:Tile)
		{
			super();
			this.addEventListener(Event.COMPLETE, _complete);
			this._tile = tile;
			this.width = tile._w;
			this.height = tile._h;
			_load();
		}
		
		private function _load():void
		{
			this.source = uri_root + _tile._tile_source 
				+ '&tileLevel=' + (_tile._tile_level + Tile.tile_level_offset) 
				+ '&tilePositionX=' + _tile._tile_x 
				+ '&tilePositionY=' + _tile._tile_y;
		}
		
		
		
		private function _complete(e:Event):void
		{
			if (e.target == this)
			{
				if (this.contentWidth < Tile.virtual_height && this.contentHeight < Tile.virtual_height)
				{
					trace(this.source, 'w:', this.contentWidth, 'h:', this.contentHeight, 'smaller than virtual tile');
					var pch:Number = 100 * this.contentHeight / Tile.virtual_height;
					this.percentHeight = pch;
					var pcw:Number = 100 * this.contentWidth / Tile.virtual_width;
					this.percentWidth = pcw;
				}
				this.validateNow();
			}
		}
		
		/* TODO: image load failure */
		/* TODO: dimensions +- 1px overlap */

	}
}