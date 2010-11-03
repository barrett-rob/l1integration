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
		private var _id:String;
		
		public function Callout(x:int, y:int, id:String)
		{
			super();
			this.graphics.beginFill(0xffaaaa, 0.5);
			this.graphics.lineStyle(0.5, 0, 0.75);
			this.graphics.drawCircle(x, y, 15);
			this.useHandCursor = true;
			this.mouseChildren = false;
			
			var t:UITextField = new UITextField();
			t.text = this._id = id;
			t.width = t.textWidth + 4;
			t.height = t.textHeight;
			// t.border = true;
			// t.borderColor = 0;
			t.x = x - t.width / 2;
			t.y = y - t.height / 2;
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