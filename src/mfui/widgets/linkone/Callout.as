package mfui.widgets.linkone
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	
	public class Callout extends UIComponent
	{
		private var _id:String, _description:String, _part_number:String;
		private var _x:int, _y:int;
		
		public function Callout(xml:XML)
		{
			super();
			
			trace(xml);
			
			_x = xml.position.x;
			_y = xml.position.y;
			_id = xml.displayItemId;
			_part_number = xml.partNumber;
			_description = xml.description;
			
			this.toolTip = _description + ' (' + _part_number + ')'

			this.graphics.beginFill(0xffffff, 0.5);
			this.graphics.lineStyle(0.25, 0, 1);
			this.graphics.drawCircle(_x, _y, 15);
			
			var t:UITextField = new UITextField();
			t.textColor = 0x1111ff;
			t.text = _id;
			t.width = t.textWidth + 4;
			t.height = t.textHeight;
			// t.border = true;
			// t.borderColor = 0;
			t.x = _x - t.width / 2;
			t.y = _y - t.height / 2;
			/* TODO: better derivation of text position */
			this.addChild(t);
			
			this.addEventListener(MouseEvent.CLICK, _click);	
		}
		
		private function _click(e:MouseEvent):void
		{
			if (e.currentTarget != this)
				return;
			
			trace('clicked callout ' + this._id + ' at ' + e.localX + ':' + e.localY);
			e.stopImmediatePropagation();
		}
	}
}