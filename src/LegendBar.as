// ActionScript file
// combo boxes
package
{
  
  import flare.display.TextSprite;
  
  import flash.display.Sprite;
  import flash.events.*;

  public class LegendBar extends Sprite
  {
    private var ox:int;
    private var oy:int;
    private var segmentLength:int;
    //private var numSegments:int;

    private var pcpColorArray:Array;  // pcp = per capita physicians
    private var pcpArray:Array;
    
    public var showMode:String;
    
    private var legendSprite:Sprite = new Sprite();
    private var textContainer:Sprite = new Sprite();

    public function LegendBar(orgx:int, orgy:int, segLength:int, numSegs:int, _mode:String){
      
      ox = orgx;
      oy = orgy;
      segmentLength = segLength;
      showMode = _mode;
      
      pcpColorArray = new Array(7);
      pcpColorArray[0] = 0xFF4E37;
      pcpColorArray[1] = 0xFF8878;
      pcpColorArray[2] = 0xFFAE9A;
      pcpColorArray[3] = 0xFFDBC9;
      pcpColorArray[4] = 0xFFFAF7;
      pcpColorArray[5] = 0xbbbbbb;
      
      /////////////////////////////////////////////////
      
      pcpArray = new Array(7);
      pcpArray[0] = " > 10.0";
      pcpArray[1] = " > 3.0";
      pcpArray[2] = " > 1.0";
      pcpArray[3] = " > 0.5";
      pcpArray[4] = " > 0.0";
      pcpArray[5] = " Data N/A";

      drawLegend();
      addChild(legendSprite);
      addChild(textContainer);
    }
    
    public function drawLegend():void{
      
      var ltitle:TextSprite = new TextSprite("Physicians per 1000 \rpopulation");
      ltitle.color = 0xffffff;
      ltitle.x = ox - 3;
      ltitle.y = oy - 40;
      ltitle.font = "Calibri";
      ltitle.size = 14;
      addChild(ltitle);
      
      legendSprite.graphics.clear();
      while(textContainer.numChildren > 0)
        textContainer.removeChildAt(0);
        
      textContainer.graphics.clear();
      
      if(showMode == "none"){
        legendSprite.graphics.clear();
        return;
      }
      else {
        for (var i:int = 0; i < 6; i++){
          if (showMode == "percapita_physicians") {
            legendSprite.graphics.beginFill(pcpColorArray[i]);
          }
          
          legendSprite.graphics.drawRect(ox , oy + i * segmentLength, 14, segmentLength);
          legendSprite.graphics.endFill();
        }
      }
      
      for(var j:int = 0; j < 6; j++){
        var txt:TextSprite;
        if(showMode == "percapita_physicians"){
          if(j == 5)
            txt = new TextSprite(pcpArray[j]);
          else
            txt = new TextSprite(pcpArray[j] + " per thousand");
        }
        
        txt.color = 0xffffff;
        txt.alpha = 0.6;
        txt.x = ox + 14;
        txt.y = oy + j * segmentLength;
        txt.font = "Calibri";
        txt.size = 12;
        textContainer.addChild(txt);
  
      }     
      
    }
    
    public function update():void {
      drawLegend();
    }
    
  }
}