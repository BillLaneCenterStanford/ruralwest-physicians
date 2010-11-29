package
{
  import flare.display.TextSprite;
  
  import flash.display.Sprite;
  import flash.events.*;

  public class ZoomUI extends Sprite
  {
    private var scale_factor:Number;
    private var frame_height:int;
    private var frame_width:int;
    private var image_left:int;
    private var image_top:int;
    
    private var image_left2:int;
    private var image_top2:int;
    
    private var ZoomLabel:TextSprite;
    private var ZoomNumber:TextSprite = new TextSprite(scale_factor.toString());
    private var ZoomIn:Sprite;
    private var ZoomOut:Sprite;
    private var PanLeft:Sprite;
    private var PanRight:Sprite;
    private var PanUp:Sprite;
    private var PanDown:Sprite;
    private var Recenter:Sprite;
    private var RecenterTT:TextSprite = new TextSprite();
    
    private var scale_factor_min:Number = 1;
    private var scale_factor_max:Number = 4;
    
    public function ZoomUI(SCALE_FACTOR_DEFAULT:Number = 2.3,
                           SCALE_FACTOR_MIN:Number = 1, 
                           SCALE_FACTOR_MAX:Number = 4)
    {
        ZoomLabel = new TextSprite();
        ZoomNumber = new TextSprite();
        
        scale_factor_min = SCALE_FACTOR_MIN;
        scale_factor_max = SCALE_FACTOR_MAX;
        scale_factor = SCALE_FACTOR_DEFAULT;

        frame_height = 540;
        frame_width = 720;
        image_left = 60;
        image_top = 50;
        
        image_left2 = 46;
        image_top2 = 4;
    }
    
    public function addMapControl():void
    {  
      var COLOR:uint = 0xffffff;
      var COLOR_DARK:uint = 0xffffff;
      var COLOR_LABELS:uint = 0xffffff;
      var ALPHA:Number = 0.4;
      var ALPHA_LIGHT:Number = 0.4;
      var drawX:Number = 728;
      var drawY:Number = 130;
      var offset:Number = 34;
      var triW:Number = 30;      // width of triangles for arrows
      
      ZoomLabel = new TextSprite("ZOOM:");
      ZoomLabel.x = drawX - 35;      ZoomLabel.y = drawY + 50;
      ZoomLabel.font = "arial";  ZoomLabel.bold = true;
      ZoomLabel.color = COLOR;  ZoomLabel.alpha = 0.7;
      addChild(ZoomLabel);
      
      // number display:
      
      ZoomNumber = new TextSprite((Number((scale_factor)*10)/10.00).toPrecision(2).toString());
      ZoomNumber.x = drawX + 8;      ZoomNumber.y = drawY + 50;
      ZoomNumber.font = "arial";  ZoomNumber.bold = true;
      ZoomNumber.color = COLOR;  ZoomNumber.alpha = 0.7;
      addChild(ZoomNumber);
      
  
      
      var matrix:Array;
      
      // add a clickable label
        ZoomIn = new Sprite();
        //larger.graphics.beginGradientFill("radial", gradientZoom, alphaZoom, ratiosZoom);
        ZoomIn.graphics.beginFill(COLOR, ALPHA_LIGHT);
        ZoomIn.graphics.drawCircle(0, 0, 11);
        ZoomIn.graphics.endFill();
        
        ZoomIn.graphics.beginFill(0xffffff, 0.7);
        ZoomIn.graphics.drawRect(-8, -2, 6, 4);
        ZoomIn.graphics.endFill();
        
        ZoomIn.graphics.beginFill(0xffffff, 0.7);
        ZoomIn.graphics.drawRect(2, -2, 6, 4);
        ZoomIn.graphics.endFill();
        
        ZoomIn.graphics.beginFill(0xffffff, 0.7);
        ZoomIn.graphics.drawRect(-2, -8, 4, 16);
        ZoomIn.graphics.endFill();
        
        ZoomIn.buttonMode = true;
  
        ZoomIn.x = drawX;
        ZoomIn.y = drawY;
        addChild( ZoomIn );
        
        // Set up an event listener to handle clicks
        ZoomIn.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            { 
              if (scale_factor > scale_factor_max) {
                //do nothing
              } else if (scale_factor*1.2 > scale_factor_max) {
                image_left = (image_left-frame_width/2)*(scale_factor_max/scale_factor)+frame_width/2;
                image_top  = (image_top-frame_height/2)*(scale_factor_max/scale_factor)+frame_height/2;
                image_left2 = (image_left2-frame_width/2)*(scale_factor_max/scale_factor)+frame_width/2;
                image_top2  = (image_top2-frame_height/2)*(scale_factor_max/scale_factor)+frame_height/2;
                scale_factor = scale_factor_max;
              } else {
                image_left = (image_left-frame_width/2)*1.2+frame_width/2;
                image_top  = (image_top-frame_height/2)*1.2+frame_height/2;
                image_left2 = (image_left2-frame_width/2)*1.2+frame_width/2;
                image_top2  = (image_top2-frame_height/2)*1.2+frame_height/2;
                scale_factor = scale_factor*1.2;
              }
              ZoomNumber.text = (Number((scale_factor)*10)/10.00).toPrecision(2).toString();
              dispatchEvent(new Event(Event.CHANGE));
          }
        );
        
        // add a clickable label
        ZoomOut = new Sprite();
        //smaller.graphics.beginGradientFill("radial", gradientOut, alphaOut, ratiosOut);
        ZoomOut.graphics.beginFill(COLOR, ALPHA_LIGHT);
        ZoomOut.graphics.drawCircle(0, 0, 30);
        ZoomOut.graphics.drawCircle(0, 0, 16);
        ZoomOut.graphics.endFill();
        ZoomOut.graphics.beginFill(0xffffff, 0.7);
        ZoomOut.graphics.drawRect(-8, 20, 16, 4);
        ZoomOut.graphics.endFill();
        ZoomOut.buttonMode = true;
        ZoomOut.x = drawX;
        ZoomOut.y = drawY;
        addChild( ZoomOut );
        
        // Set up an event listener to handle clicks
        ZoomOut.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            { 
              if (scale_factor < scale_factor_min) {
                //do nothing
              }  else if (scale_factor/1.2 < scale_factor_min) {
                image_left = (image_left-frame_width/2)/(scale_factor/scale_factor_min)+frame_width/2;
                image_top  = (image_top-frame_height/2)/(scale_factor/scale_factor_min)+frame_height/2;
                image_left2 = (image_left2-frame_width/2)/(scale_factor/scale_factor_min)+frame_width/2;
                image_top2  = (image_top2-frame_height/2)/(scale_factor/scale_factor_min)+frame_height/2;
                scale_factor = scale_factor_min;
              } else {
                image_left = (image_left-frame_width/2)/1.2+frame_width/2;
                image_top  = (image_top-frame_height/2)/1.2+frame_height/2;
                image_left2 = (image_left2-frame_width/2)/1.2+frame_width/2;
                image_top2  = (image_top2-frame_height/2)/1.2+frame_height/2;
                scale_factor = scale_factor/1.2;
              }
              ZoomNumber.text = (Number((scale_factor)*10)/10).toPrecision(2).toString();
              dispatchEvent(new Event(Event.CHANGE));
            }
        );
        
        // add a clickable label
        PanLeft = new Sprite();
        PanLeft.graphics.beginFill(COLOR, ALPHA_LIGHT);
        PanLeft.graphics.moveTo( -offset, triW/2 );
        PanLeft.graphics.lineTo( -offset - triW/2, 0);
        PanLeft.graphics.lineTo( -offset, -triW/2);
        PanLeft.graphics.lineTo( -offset, triW/2 );
        PanLeft.graphics.endFill();
        PanLeft.buttonMode = true;
        PanLeft.x = drawX;
        PanLeft.y = drawY;
        addChild( PanLeft );
        
        // Set up an event listener to handle clicks
        PanLeft.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            { 
              image_left = image_left + 30;
              image_left2 = image_left2 + 30;
              dispatchEvent(new Event(Event.CHANGE));
            }
        );
        
        // add a clickable label
        PanRight = new Sprite();
        PanRight.graphics.beginFill(COLOR, ALPHA_LIGHT);
        PanRight.graphics.moveTo( offset, triW/2 );
        PanRight.graphics.lineTo( offset + triW/2, 0);
        PanRight.graphics.lineTo( offset, -triW/2);
        PanRight.graphics.lineTo( offset, triW/2 );
        PanRight.graphics.endFill();
        PanRight.buttonMode = true;
        PanRight.x = drawX;
        PanRight.y = drawY;
        addChild( PanRight );
        
        // Set up an event listener to handle clicks
        PanRight.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            {
              image_left = image_left - 30; 
              image_left2 = image_left2 - 30;
              dispatchEvent(new Event(Event.CHANGE));
            }
        );
        
        
        // add a clickable label
        PanUp = new Sprite();
        PanUp.graphics.beginFill(COLOR, ALPHA_LIGHT);
        PanUp.graphics.moveTo( 0, -offset );
        PanUp.graphics.lineTo( -triW/2, -offset);
        PanUp.graphics.lineTo( 0, -offset -triW/2);
        PanUp.graphics.lineTo( triW/2, -offset );
        PanUp.graphics.endFill();
        PanUp.buttonMode = true;
        PanUp.x = drawX;
        PanUp.y = drawY;
        addChild( PanUp );
        
        // Set up an event listener to handle clicks
        PanUp.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            { 
              image_top = image_top + 30;     
              image_top2 = image_top2 + 30;     
              dispatchEvent(new Event(Event.CHANGE));     
            }
        );
        
        // add a clickable label
        PanDown = new Sprite();
        PanDown.graphics.beginFill(COLOR, ALPHA_LIGHT);
        PanDown.graphics.moveTo( 0, offset );
        PanDown.graphics.lineTo( -triW/2, offset);
        PanDown.graphics.lineTo( 0, offset + triW/2);
        PanDown.graphics.lineTo( triW/2, offset );
        PanDown.graphics.endFill();
        PanDown.buttonMode = true;
        PanDown.x = drawX;
        PanDown.y = drawY;
        addChild( PanDown );
        
        // Set up an event listener to handle clicks
        PanDown.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            {
              image_top = image_top - 30; 
              image_top2 = image_top2 - 30; 
              dispatchEvent(new Event(Event.CHANGE));
            }
        );
        
        Recenter = new Sprite();
        Recenter.graphics.beginFill(COLOR, ALPHA_LIGHT);
        Recenter.graphics.drawRoundRect(-50, -50, 20, 20, 6, 6);
        Recenter.graphics.endFill();
        Recenter.graphics.lineStyle(1, 0xffffff);
        Recenter.graphics.drawCircle(-40, -40, 1);
        Recenter.graphics.lineStyle(1, 0xffffff, 0.75);
        Recenter.graphics.drawCircle(-40, -40, 4);
        Recenter.graphics.lineStyle(1, 0xffffff, 0.4);
        Recenter.graphics.drawCircle(-40, -40, 8);
        Recenter.buttonMode = true;
        Recenter.x = drawX;
        Recenter.y = drawY;
        addChild( Recenter );
        
        // Set up an event listener to handle clicks
        Recenter.addEventListener( MouseEvent.CLICK,
            function( evt:MouseEvent ):void 
            {
              // restore to default
              image_left = 60;
              image_top = 50;
              
              image_left2 = 46;
              image_top2 = 4;
              
              scale_factor = 0.3;
              dispatchEvent(new Event(Event.CHANGE));
            }
        );
        
        Recenter.addEventListener(MouseEvent.MOUSE_OVER, showRecenterTT);
        Recenter.addEventListener(MouseEvent.MOUSE_OUT, hideRecenterTT);
        
        RecenterTT.x = 718;
        RecenterTT.y = 85;
        RecenterTT.graphics.beginFill(0xFFF7B5, 0.6);
        RecenterTT.graphics.drawRoundRect(0, 0, 80, 18, 4, 4);
        RecenterTT.graphics.endFill();
        RecenterTT.text = "Recenter Map";
        RecenterTT.visible = false;
        RecenterTT.font = "Calibri";
        addChild(RecenterTT);
        
    }
    
    		
		protected function showRecenterTT(event:MouseEvent):void
		{
		  RecenterTT.visible = true;
		}
		
		protected function hideRecenterTT(event:MouseEvent):void
		{
		  RecenterTT.visible = false;
		}
    
    public function getScaleFactor():Number
    {
      return scale_factor;
    }
    public function getFrameHeight():int
    {
      return frame_height;
    }
    public function getFrameWidth():int
    {
      return frame_width;
    }
    public function getImageLeft():int
    {
      return image_left;
    }
    public function getImageTop():int
    {
      return image_top;
    }
    public function getImageLeft2():int
    {
      return image_left2;
    }
    public function getImageTop2():int
    {
      return image_top2;
    }
    
    
    
    public function setImageLeft(left:int, left2:int):void
    {
      image_left = left;
      image_left2 = left2;
      dispatchEvent(new Event(Event.CHANGE));
    }
    public function setImageTop(top:int, top2:int):void
    {
      image_top = top;
      image_top2 = top2;
      dispatchEvent(new Event(Event.CHANGE));
    }
    public function setScaleFactor(x:Number):void
    {
      scale_factor = x;
      dispatchEvent(new Event(Event.CHANGE));
    }    
    
  }
}








  