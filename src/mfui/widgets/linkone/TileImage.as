package mfui.widgets.linkone
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	
	public class TileImage extends Image
	{
		
		private var _tile:Tile;
		private var _image_uri:String;
		private var _dimensions:Rectangle;
		
		public function TileImage(tile:Tile, image_uri:String)
		{
			super();
			this._tile = tile;
			this.width = tile.width;
			this.height = tile.height;
			this._image_uri = image_uri;
			this.addEventListener(Event.COMPLETE, _complete);
			this.addEventListener(IOErrorEvent.IO_ERROR, _io_error);
			this.addEventListener(MouseEvent.CLICK, _click);
			this.source = this._image_uri;
		}
		
		private function _io_error(e:IOErrorEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace(this._image_uri, 'not found');
			this.width = this.height = 0;
			discard();
		}
		
		private function _complete(e:Event):void
		{
			if (e.currentTarget != this)
				return;
			
			this._dimensions = new Rectangle(0, 0, this.contentWidth, this.contentHeight);
			
			if (this.contentWidth < _tile.virtual_size && this.contentHeight < _tile.virtual_size)
			{
				/* image smaller than virtual tile */
				this.width = this.width * (this.contentWidth / _tile.virtual_size)
				this.height = this.height * (this.contentHeight / _tile.virtual_size)
			}
			
			/* register this image width and height */
			_tile.register_image(this.contentWidth, this.contentHeight);
			
			/* check images on the right and bottom edges */
			if ((_tile.x_pos >= _tile.column_count - 1) && (this.contentWidth > _tile.virtual_size + 1))
			{
				/* another tile to the right of */
				_tile.add_tile(1, 0);
			}
			if ((_tile.y_pos >= _tile.column_count - 1) && (this.contentHeight > _tile.virtual_size + 1))
			{
				/* another tile beneath */
				_tile.add_tile(0, 1);
			}
			
			this.toolTip = toString();
		}
		
		/* TODO: dimensions +- 1px overlap */
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('image width:', _dimensions.width);
			trace('_tile.width:', _tile.width);
			
			var _image_to_tile_ratio:Number = _dimensions.width / _tile.width;
			trace('_image_to_tile_ratio:', _image_to_tile_ratio);
			
//			var _tile_to_virtual_ratio:Number = _tile.width / _tile.virtual_size;
//			_tile_to_virtual_ratio = (_tile_to_virtual_ratio > 1) ? 1 : _tile_to_virtual_ratio;
//			trace('_tile_to_virtual_ratio:', _tile_to_virtual_ratio);
//			
//			var _x_offset_this_tile:Number = e.localX;
//			trace('_x_offset_this_tile:', _x_offset_this_tile);
//			
//			var _x_proportion_this_tile:Number = _x_offset_this_tile / this.width;
//			trace('_x_proportion_this_tile:', _x_proportion_this_tile);
		}
		
		internal function discard():void
		{
			this.source = null;
		}
		
		public override function toString():String
		{
			return this._tile.toString() + '\nimage (' + this.contentWidth + 'x' + this.contentHeight + ')'; 
		}
	}
	
}