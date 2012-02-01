package dk.atkins
{
	import org.alivepdf.pdf.PDF;
	import mx.controls.Text;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.fonts.Style;

	public class CustomPDF extends PDF
	{
		public var footerText:String = "";
		
		public function CustomPDF(orientation:String="Portrait", unit:String="Mm", pageSize:Object=null, rotation:int=0)
		{
			super(orientation, unit, pageSize, rotation);
		}
		override public function footer():void{
			setFont(FontFamily.ARIAL , Style.NORMAL, 11);
   			addText(footerText,5, getCurrentPage().h - 2);
   		}   		
	}
}