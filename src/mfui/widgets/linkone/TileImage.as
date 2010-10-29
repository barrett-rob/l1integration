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
			this.width = tile.width;
			this.height = tile.height;
			_load();
		}
		
		private function _load():void
		{
			this.source = uri_root + _tile.tile_source 
				+ '&tileLevel=' + (_tile.tile_level + _tile.tile_level_offset) 
				+ '&tilePositionX=' + _tile.tile_x 
				+ '&tilePositionY=' + _tile.tile_y;
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
				this.toolTip = _tile.toolTip + '\n(' + this.contentWidth + 'x' + this.contentHeight + ')';
				this.validateNow();
			}
		}
		
		/* TODO: image load failure */
		/* TODO: dimensions +- 1px overlap */
		
		internal function discard():void
		{
			this.source = null;
		}
		
	}

}