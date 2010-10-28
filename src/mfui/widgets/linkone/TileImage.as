package mfui.widgets.linkone
{
	import flash.events.Event;
	
	import mx.controls.Image;
	
	public class TileImage extends Image
	{
		
		public static const uri_root:String = 'http://a028856:8080/ria/linkone?';
		
		private var _w:int, _h:int, _tile_level:int,  _tile_x:int,  _tile_y:int;
		private var _tile_source:String;
		
		public function TileImage(w:int, h:int, tile_source:String, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			this.addEventListener(Event.COMPLETE, _complete);
			this.width = this._w = w;
			this.height = this._h = h;
			this._tile_level = tile_level;
			this._tile_x = tile_x;
			this._tile_y = tile_y;
			this._tile_source = tile_source;
			
			_load();
		}
		
		private function _load():void
		{
			this.source = uri_root + _tile_source + '&tileLevel=' + _tile_level + '&tilePositionX=' + _tile_x + '&tilePositionY=' + _tile_y;
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