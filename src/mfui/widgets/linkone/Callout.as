package mfui.widgets.linkone
{
	import mx.core.UIComponent;
	
	public class Callout extends UIComponent
	{
		public function Callout(x:int, y:int)
		{
			super();
			this.graphics.beginFill(0xffaaaa);
			this.graphics.drawCircle(x, y, 20);
		}
	}
}