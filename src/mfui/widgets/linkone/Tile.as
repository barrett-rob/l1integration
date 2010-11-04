package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	
	public class Tile extends LayoutContainer
	{
		
		private var _tile_container:TileContainer;
		private var _tile_image:TileImage = null;
		
		internal var level:int;
		internal var tile_x:int;
		internal var tile_y:int;
		internal var virtual_width:int, virtual_height:int;
		internal var region:Rectangle = null;
		
		public function Tile(tile_container:TileContainer, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			this.layout = 'absolute';
			this.clipContent = false;
			this.cacheAsBitmap = true;
			this.setStyle('borderStyle', 'solid');
			
			this._tile_container = tile_container;
			this.level = tile_level;
			this.tile_x = tile_x;
			this.tile_y = tile_y;
		}
		
		internal function loadImage():void
		{
			if (_tile_image)
				return;
			this._tile_image = new TileImage(this, TileContainer.TILE_URI_ROOT 
				+ _tile_container.tile_uri_source 
				+ '&tileLevel=' + (level + _tile_container.tile_uri_level_offset) 
				+ '&tilePositionX=' + tile_x 
				+ '&tilePositionY=' + tile_y);
			this.addElement(_tile_image);
		}
		
		internal function set_region(x:int, y:int, w:int, h:int):void
		{
			this.region = new Rectangle(x, y, w, h);
			// trace('region for tile (' + _tile_x + ':' + _tile_y + ') on level', tile_level, 'is:', this.region);
		}
		
		internal function discard():void
		{
			if (_tile_image)
				_tile_image.discard();
		}
		
		public override function toString():String
		{
			return 'tile ' + level + ':' + tile_x + ':' + tile_y + ' (' + width + 'x' + height + ')';
		}
		
	}
}