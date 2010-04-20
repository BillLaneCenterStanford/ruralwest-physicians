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
	  
		private var black_bar:Sprite; // the top black bar with the numbers
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
		  
		  black_bar = new Sprite();
		  addChild(black_bar);
		  
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
		  year_label.size = 15;
		  year_label.alpha = 0.8;
		  year_label.color = 0xffffff;
		  year_label.bold = true;
		  addChild(year_label);
		  
		  renderTimeline();
		}
		
		public function renderTimeline():void
		{
		  black_bar.graphics.beginFill(0x000000, 0.8);
		  black_bar.graphics.drawRect(_ox, _oy, _width, 22);
		  black_bar.graphics.endFill();
		  
		  year_bar.graphics.beginFill(0x555555, 0.4);
		  year_bar.graphics.drawRect(_ox, _oy + 25, _width, 8);
		  year_bar.graphics.endFill();
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

		  selected.graphics.beginFill(0xffffff, 0.6);
		  selected.graphics.drawRect(-15, -4, 24, 8);
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
		        
		        if(_selected_year == 2010)
		          year_label.text = "????";
		        else
		          year_label.text = _selected_year.toString();
      		  year_label.x = target.x - 20;
      		  year_label.y = target.y - 28;
      		  
      		  dispatchEvent(new Event(Event.CHANGE));
		      });
		    
		    newCircle.graphics.beginFill(0x999999, 0.2);
		    newCircle.graphics.drawRect(-15, -4, 24, 8);
		    newCircle.graphics.endFill();
		    newCircle.graphics.beginFill(0xffffff, 0.0);
		    newCircle.graphics.drawRect(-15, -29, 24, 25);
		    newCircle.graphics.endFill();
		    
		    if(_selected_year == YearArray[i]){
		      selected.x = newCircle.x;
		      selected.y = newCircle.y;
		      
		      year_label.text = _selected_year.toString();
		      year_label.x = selected.x - 20;
		      year_label.y = selected.y - 28;
		    }
		    
		    var newYear:TextSprite = new TextSprite();
		    if(i == YearArray.length - 1)
		      newYear.text = "????";
		    else
		      newYear.text = YearArray[i].toString();
		    newYear.x = newCircle.x - 20;
		    newYear.y = newCircle.y - 28;
		    newYear.font = "Times New Roman";
		    newYear.size = 15;
		    newYear.color = 0xffffff;
		    newYear.alpha = 0.3;
		    newYear.bold = true;
		    
		    year_sprites.addChild(newYear);
		    
		    selector_circles.addChild(newCircle);
		  }
		  
		  initializeSelected(); // draw the selection dot
		}
		
	}
}
