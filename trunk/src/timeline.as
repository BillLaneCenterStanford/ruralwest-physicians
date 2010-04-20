// ActionScript file
// ActionScript file
package {
	import flare.display.TextSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class timeline extends Sprite
	{
	  private var _width:int;
	  private var _ox:int;
	  private var _oy:int;
	  private var _start_year:int;
	  private var _end_year:int;
	  private var _selected_year:int;
	  
		private var year_bar:Sprite;  // the bottom gray bar for the scrolling
		private var selector_circles:Sprite;  // circles to click on
		private var year_sprites:Sprite;
		private var selected:Sprite;
		private var year_label:TextSprite;
		private var YearArray:Array;  // stores all the years on this timeline
		private var IntervalArray:Array;  // stores the intervals at which sprites appear
		
		public function timeline(x:int, y:int, width:int, start_year:int, end_year:int)
		{
		  YearArray = new Array();
		  IntervalArray = new Array();
		  _width = width;
		  _ox = x;
		  _oy = y;
		  _start_year = start_year;
		  _end_year = end_year;
		  
		  year_bar = new Sprite();
		  addChild(year_bar);
		  
		  year_sprites = new Sprite();
		  addChild(year_sprites);
		  
		  selector_circles = new Sprite();
		  addChild(selector_circles);
		  
		  selected = new Sprite();
		  addChild(selected);
		  
		  year_label = new TextSprite();
		  year_label.font = "Times New Roman";
		  year_label.size = 18;
		  year_label.alpha = 1.0;
		  year_label.color = 0xffffff;
		  year_label.bold = true;
		  addChild(year_label);
		  
		  renderTimeline();
		}
		
		public function renderTimeline():void
		{
		  /*
		  year_bar.graphics.beginFill(0xE3FDFF, 0.4);
		  year_bar.graphics.drawRect(_ox, _oy + 22, _width, 8);
		  year_bar.graphics.endFill();
		  */
		}
		
		public function setYearsInts(yrArr:Array, intArr:Array):void
		{
		  YearArray = yrArr;
		  trace(YearArray.length);
		  IntervalArray = intArr;
		  
		  _selected_year = YearArray[int(YearArray.length/2) + 1];
		  trace(_selected_year);
		}
		
		public function initializeSelected():void
		{
		  selected.graphics.clear();

		  selected.graphics.beginFill(0xE3FDFF, 0.9);
		  selected.graphics.drawCircle(-15, -4, 12);
		  selected.graphics.endFill();
		}
		
		public function getSelectedYear():int
		{
		  return _selected_year;
		}
		
		public function getSelectedZone():int
		{
		  var i:int = 0;
		  for (i = 0; i < YearArray.length; i++){
		    if(_selected_year == YearArray[i])
		      return i;
		  }
		  
		  return -1;
		}
		
		public function DrawTimeline():void
		{
		  var i:int;
		  for(i = 0; i < YearArray.length; i++){
		    var newCircle:Sprite = new Sprite();
		    newCircle.x = _ox + 22 + IntervalArray[i]/100 * _width * 0.92;
		    newCircle.y = _oy + 29;
		    newCircle.buttonMode = true;
		    newCircle.name = YearArray[i].toString();
		    newCircle.addEventListener(MouseEvent.CLICK, 
		      function( evt:MouseEvent ):void 
		      {
		        var target:Sprite = evt.target as Sprite;
		        
		        _selected_year = int(target.name); 
		        
		        selected.x = target.x;
		        selected.y = target.y;

		        year_label.text = _selected_year.toString();
      		  year_label.x = target.x - 10;
      		  year_label.y = target.y + 10;
      		  
      		  dispatchEvent(new Event(Event.CHANGE));
		      });
		    
		    newCircle.graphics.beginFill(0xE3FDFF, 1.0);
		    newCircle.graphics.drawCircle(-15, -4, 20);
		    newCircle.graphics.drawCircle(-15, -4, 15);
		    newCircle.graphics.endFill();
		    
		    newCircle.graphics.beginFill(0xE3FDFF, 0.3);
		    newCircle.graphics.drawCircle(-15, -4, 12);
		    newCircle.graphics.endFill();
		    
		    // draw the bar to the right, but not for the last one
		    if(i != YearArray.length - 1){
  		    newCircle.graphics.beginFill(0xE3FDFF, 0.8);
  		    newCircle.graphics.drawRect(0, -8, 69, 8);
  		    newCircle.graphics.endFill();
		    }

		    /*
		    newCircle.graphics.beginFill(0xffffff, 0.0);
		    newCircle.graphics.drawRect(-15, -29, 24, 25);
		    newCircle.graphics.endFill();
		    */
		    
		    if(_selected_year == YearArray[i]){
		      selected.x = newCircle.x;
		      selected.y = newCircle.y;
		      
		      year_label.text = _selected_year.toString();
		      year_label.x = selected.x - 10;
		      year_label.y = selected.y + 10;
		    }
		    
		    var newYear:TextSprite = new TextSprite();
		    newYear.text = YearArray[i].toString();
		    newYear.x = newCircle.x - 10;
		    newYear.y = newCircle.y + 10;
		    newYear.font = "Times New Roman";
		    newYear.size = 18;
		    newYear.color = 0xffffff;
		    newYear.alpha = 0.6;
		    newYear.bold = true;
		    
		    year_sprites.addChild(newYear);
		    
		    selector_circles.addChild(newCircle);
		  }
		  
		  initializeSelected(); // draw the selection dot
		}
		
	}
}
