package mfui.widgets.linkone
{
	import flash.events.Event;
	
	import mx.controls.Image;
	
	public class TileImage extends Image
	{
		
		public static const uri_root:String = 'http://a028856:8080/ria/linkone?';
		
		public function TileImage(w:int, h:int, tile_source:String, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			this.width = w;
			this.height = h;
			this.addEventListener(Event.COMPLETE, _imageLoadComplete);
			this.source = uri_root + tile_source + '&tileLevel=' + tile_level + '&tilePositionX=' + tile_x + '&tilePositionY=' + tile_y;
		}
		
		private function _imageLoadComplete(e:Event):void
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