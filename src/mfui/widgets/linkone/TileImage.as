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
			this.maintainAspectRatio = false;
			this.scaleContent = false;
			
			this._tile = tile;
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
			
			/* assume the dimensions of the image */
			this.width = this.contentWidth;
			this.height = this.contentHeight;
			
			/* proportions of avail w/h */
			var _pw:Number = this.width / _tile.width;
			var _ph:Number = this.height / _tile.height;
			
			var _cw:int = this.contentWidth, 
				_ch:int = this.contentHeight,
				_iw:int = this.width, 
				_ih:int = this.height, 
				_tvw:int = _tile.virtual_width, 
				_tvh:int = _tile.virtual_height,
				_tw:int = _tile.width, 
				_th:int = _tile.height;

			trace(_tile);
			trace(' ' + _tvw + 'x' + _tvh + ' (virtual tile size)');
			trace('  ' + _cw + 'x' + _ch + ' (image content size)');
			
			/* scale */
			this.scaleContent = true;
			
			if (_pw > _ph)
			{
				trace('   scale by width');
				this.width = this.width / _pw;
				this.height = this.height / _pw;
			}
			else
			{
				trace('   scale by height');
				this.width = this.width / _ph;
				this.height = this.height / _ph;
			}
			
			trace('   ' + this.width + 'x' + this.height + ' (scaled image size)');
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