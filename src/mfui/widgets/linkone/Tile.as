package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class Tile extends BorderContainer
	{
		
		internal var virtual_size:int;
		
		internal var tile_level:int;
		internal var tile_x:int;
		internal var tile_y:int;
		
		private var _tile_container:TileContainer;
		private var _tile_image:TileImage = null;
		
		internal var region:Rectangle = null;
		
		public function Tile(tile_container:TileContainer, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			
			this.setStyle('borderStyle', 'none');
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
			
			this._tile_container = tile_container;
			this.tile_level = tile_level;
			this.tile_x = tile_x;
			this.tile_y = tile_y;
			
			set_size_and_position(this.tile_level + 1);
		}
		
		internal function set_size_and_position(tile_count:int):void
		{
			this.width = this.height = this._tile_container.width / tile_count;
			this.left = this.tile_x * this.width;
			this.top = this.tile_y * this.height;
			
			this.region = new Rectangle(Number(this.left), Number(this.top), this.width, this.height);
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
			this.toolTip = toString();
		}
		
		internal function loadImage():void
		{
			if (_tile_image)
				return;
			this._tile_image = new TileImage(this, TileContainer.TILE_URI_ROOT 
				+ _tile_container.tile_uri_source 
				+ '&tileLevel=' + (tile_level + _tile_container.tile_uri_level_offset) 
				+ '&tilePositionX=' + tile_x 
				+ '&tilePositionY=' + tile_y);
			this.addElement(_tile_image);
		}
		
		internal function discard():void
		{
			if (_tile_image)
				_tile_image.discard();
		}
		
		private function _mouseWheel(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			/* show next level up or down */
			var l:int = (e.delta > 0) ? this.tile_level + 1 : this.tile_level - 1;
			_tile_container.display_level(l);
			return;
		}
		
		public override function toString():String
		{
			return 'tile ' + tile_level + ':' + tile_x + ':' + tile_y + ' (' + this.width + 'x' + this.height + ')';
		}
	}
}