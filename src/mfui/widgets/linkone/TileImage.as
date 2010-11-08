package mfui.widgets.linkone
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
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
				if (_tile.level == 0)
				{
					/* special case, allow tile to scale up */
				}
				else
				{
					this.width = this.width * (this.contentWidth / _tile.virtual_size)
					this.height = this.height * (this.contentHeight / _tile.virtual_size)
				}
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

		private function _normalise(_x:Number, _y:Number):Point
		{
			var _x_offset_this_tile:Number = _x;
			var _x_offset_all_tiles:Number = _x_offset_this_tile + (_tile.x_pos * _tile.virtual_size);
			var _x_offset_normalised:Number = _x_offset_all_tiles / _tile.level_width;
			
			var _y_offset_this_tile:Number = _y;
			var _y_offset_all_tiles:Number = _y_offset_this_tile + (_tile.y_pos * _tile.virtual_size);
			var _y_offset_normalised:Number = _y_offset_all_tiles / _tile.level_width;
			
			return new Point(_x_offset_normalised, _y_offset_normalised);
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('normalised click at:', _normalise(e.localX, e.localY));
		}
		
		private function _mouseWheel(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			var at:Point = _normalise(e.localX, e.localY);
			// trace('normalised wheel at:', at);
			
			/* show next level up or down */
			var l:int = (e.delta > 0) ? _tile.level + 1 : _tile.level - 1;
			_tile.tile_container.display_level(l);
			_tile.tile_container.center_display(l, at);
			return;
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