package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class Tile extends BorderContainer
	{
		
		public static const virtual_height:int = 1024;
		public static const virtual_width:int = 1024;
		
		
		private var _tile_container:TileContainer;
		private var _tile_x:int;
		private var _tile_y:int;
		private var _tile_level:int;
		
		private var _tile_image:TileImage = null;
		
		internal var region:Rectangle = null;
		
		public function Tile(tile_container:TileContainer, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			
			this.setStyle('borderStyle', 'none');
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
			
			this._tile_container = tile_container;
			this._tile_level = tile_level;
			this._tile_x = tile_x;
			this._tile_y = tile_y;
			
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
			this.toolTip = 'level:' 
				+ (_tile_level + _tile_container.tile_uri_level_offset) 
				+ ' (' + _tile_x + ':' + _tile_y + ')' 
				+ '\n' + this.width + 'x' + this.height;
		}
		
		public function get tile_level():int
		{		
			return _tile_level;
		}
		
		public function get tile_x():int
		{		
			return _tile_x;
		}
		
		public function get tile_y():int
		{		
			return _tile_y;
		}
		
		internal function loadImage():void
		{
			if (_tile_image)
				return;
			this._tile_image = new TileImage(this, TileContainer.TILE_URI_ROOT 
				+ _tile_container.tile_uri_source 
				+ '&tileLevel=' + (_tile_level + _tile_container.tile_uri_level_offset) 
				+ '&tilePositionX=' + _tile_x 
				+ '&tilePositionY=' + _tile_y);
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
			
			/* target point is */
			var p:Point = new Point(e.localX, e.localX);
			/* target level (up or down) is */
			var l:int = (e.delta > 0) ? this._tile_level + 1 : this._tile_level - 1;
			
			_tile_container.display_tile(l, p);
			return;
		}
		
		/* TODO: coords resolve to level coords */
		/* TODO: coords resolve to next level down */
		
	}
}