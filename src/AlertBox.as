// ActionScript file
// ActionScript file
package {
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class AlertBox extends Sprite
	{
	  private static var close_button:Button = new Button();
	  
	  // dimensional variables
	  private static var box_height:int = 500;
	  private static var box_width:int = 400;
	  private static var box_x:int = 20;
	  private static var box_y:int = 20;
	  
	  // color variables
	  private static var box_color:uint = 0x888888;
	  private static var box_alpha:Number = 0.95;
	  private static var text_color:Number = 0x000000;

		private var box:Sprite = new Sprite();
		private var bg_black:Sprite = new Sprite();
		private var alert_text:TextField = new TextField();

		//private var tmr:Timer;
		
		public function AlertBox(x:int,y:int,width:int,height:int, text:String)
		{
		  //tmr = new Timer(500, 100);
		  //tmr.addEventListener("timer", tmrHandler);
		  
		  box_height = height;
		  box_width = width;
		  box_x = x;
		  box_y = y;
			
			box = new Sprite();
			
      draw_box();
      close_button.label = "Close";
      //close_button.x = box_x + width/2 - 50;  // centered version, bottom
      //close_button.y = box_y + height - 35;
      
      close_button.x = box_x + width - 57;  // top right version
      close_button.y = box_y + 7;
      close_button.width = 50;
      close_button.addEventListener(MouseEvent.CLICK, onClose);
      
      alert_text.selectable = false;
      alert_text.text = text;
      alert_text.textColor = text_color;
      alert_text.x = box_x + 15;
      alert_text.y = box_y + 10;
      alert_text.width = box_width - 30;
      var myTextFormat:TextFormat = new TextFormat();
      myTextFormat.font = "Calibri";
      alert_text.setTextFormat(myTextFormat);
      alert_text.wordWrap = true;
      // HOW TO DO FONTalert_text.text.
      alert_text.height = box_height - 20;
      
      addChild( bg_black );
 			addChild( box );
 			addChild( alert_text );
 			addChild( close_button );
		}
		
		public function draw_box():void{
		  // draw the background black
		  bg_black.graphics.clear();
		  bg_black.graphics.beginFill(0x000000, 0.75);
		  bg_black.graphics.drawRect(0, 0, 2000, 2000);
		  bg_black.graphics.endFill();
		  // draw the text box
		  box.graphics.clear();
      box.graphics.lineStyle(1, 0x444444);
      box.graphics.beginFill(box_color, box_alpha);
      box.graphics.drawRoundRect(box_x, box_y, box_width, box_height, 8, 8);
      box.graphics.endFill();
    }
		
		public function close_box():void{
		  close_button.visible = false;
		  close_button.enabled = false;
		  box.visible = false;
		  alert_text.visible = false;
		  bg_black.visible = false;
		  /*
		  removeChild(close_button);
		  removeChild(box);
		  removeChild(alert_text);
		  removeChild(bg_black);
		  */
		}
		
		public function show_box():void{
		  close_button.visible = true;
		  close_button.enabled = true;
		  box.visible = true;
		  alert_text.visible = true;
		  bg_black.visible = true;
		}
		
		protected function onClose(event:MouseEvent):void
		{
		  close_box();
		}
	}
}
