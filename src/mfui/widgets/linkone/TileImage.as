package mfui.widgets.linkone
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.controls.Image;
	
	public class TileImage extends Image
	{
		
		private var _tile:Tile;
		private var _image_uri:String;
		
		public function TileImage(tile:Tile, image_uri:String)
		{
			super();
			this._tile = tile;
			this.width = tile.width;
			this.height = tile.height;
			this._image_uri = image_uri;
			this.addEventListener(Event.COMPLETE, _complete);
			this.addEventListener(IOErrorEvent.IO_ERROR, _io_error);
			this.source = this._image_uri;
		}
		
		private function _io_error(e:IOErrorEvent):void
		{
			if (e.currentTarget != this)
				return;

			trace(this._image_uri, 'not loaded');
			this.width = this.height = 0;
			discard();
		}
		
		private function _complete(e:Event):void
		{
			if (e.currentTarget != this)
				return;
			
			if (this.contentWidth < _tile.virtual_size && this.contentHeight < _tile.virtual_size)
			{
				/* image smaller than virtual tile */
				var pch:Number = 100 * this.contentHeight / _tile.virtual_size;
				this.percentHeight = pch;
				var pcw:Number = 100 * this.contentWidth / _tile.virtual_size;
				this.percentWidth = pcw;
			}
			this.toolTip = toString();
		}
		
		/* TODO: dimensions +- 1px overlap */
		
		internal function discard():void
		{
			this.source = null;
		}
		
		public override function toString():String
		{
			return this._tile.toString() + '\n(' + this.contentWidth + 'x' + this.contentHeight + ')'; 
		}
	}
	
}