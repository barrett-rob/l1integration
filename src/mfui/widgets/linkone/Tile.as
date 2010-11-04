package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	import mx.core.LayoutContainer;
	import mx.events.FlexEvent;
	
	public class Tile extends LayoutContainer
	{
		
		internal var virtual_size:int;
		internal var tile_level:int;
		internal var tile_x:int;
		internal var tile_y:int;
		
		internal var primary:Boolean = true;
		
		private var _tile_container:TileContainer;
		private var _tile_image:TileImage;
		
		internal var region:Rectangle;
		
		public function Tile(tile_container:TileContainer, tile_level:int, tile_x:int, tile_y:int)
		{
			super();
			this.setStyle('borderStyle', 'solid');
			this.layout = 'absolute';
			this.clipContent = false;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, _creationComplete);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, _mouseWheel);
			this.addEventListener(MouseEvent.CLICK, _click);
			this._tile_container = tile_container;
			this.tile_level = tile_level;
			this.tile_x = tile_x;
			this.tile_y = tile_y;
			set_size_and_position();
		}
		
		internal function get level_width():int
		{
			return this._tile_container.get_level_width(this.tile_level);
		}
		
		internal function set_size_and_position():void
		{
			this.width = this.height = this._tile_container.width / this.level_width;
			this.left = this.tile_x * this.width;
			this.top = this.tile_y * this.height;
			
			this.region = new Rectangle(Number(this.left), Number(this.top), this.width, this.height);
			
			this.toolTip = toString();
		}
		
		private function _creationComplete(e:FlexEvent):void
		{
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
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			var _x_proportion:Number = e.localX / this.width;
			var _virtual_x:Number = _x_proportion * virtual_size;
			
			var _y_proportion:Number = e.localY / this.height;
			var _virtual_y:Number = _y_proportion * virtual_size;
			
			trace('\t local (' + e.localX + ':' + e.localY + ')' 
				+ '\t virtual (' + _virtual_x + ':' + _virtual_y 
				+ '\t dimensions (' + this.width + 'x' + this.height + ')')
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
		
		internal function add_tile(x_plus:int, y_plus:int):void
		{
			_tile_container.add_tile(this.tile_level, this.tile_x + x_plus, this.tile_y + y_plus);
		}
		
		public override function toString():String
		{
			return 'tile ' + tile_level + ':' + tile_x + ':' + tile_y + ' (' + this.width + 'x' + this.height + ')';
		}
	}
}