package mfui.widgets.linkone
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	
	import mx.controls.Image;
	
	public class TileImage extends Image
	{
		
		private var _tile:Tile;
		private var _image_uri:String;
		
		public function TileImage(tile:Tile, image_uri:String)
		{
			super();
			
			this.addEventListener(Event.COMPLETE, _complete);
			this.addEventListener(HTTPStatusEvent.HTTP_STATUS, _http_status);
			
			this.cacheAsBitmap = true;
			
			this._tile = tile;
			this.width = tile.width;
			this.height = tile.height;
			this.left = this.top = 0;
			this._image_uri = image_uri;
			_load();
		}
		
		private function _load():void
		{
			this.source = this._image_uri;
		}
		
		private function _complete(e:Event):void
		{
			if (e.currentTarget != this)
				return;
			
			trace(_tile.level + ' (' + _tile.tile_x + ':' + _tile.tile_y + ')' 
				+ ': ' + _tile.virtual_width + 'x' + _tile.virtual_height 
				+ ' (' + this.contentWidth + 'x' + this.contentHeight + ')'
				+ ' (' + this.left + ':' + this.top + ')');
			
		}
		
		private function _http_status(e:HTTPStatusEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* TODO: handle image load failure */
		}
		
		/* TODO: dimensions +- 1px overlap */
		
		internal function discard():void
		{
			this.source = null;
		}
		
	}
	
}