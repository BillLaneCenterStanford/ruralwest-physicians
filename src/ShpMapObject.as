package
{
  import flare.widgets.ProgressBar;
  
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Dictionary;

  public class ShpMapObject extends Sprite
  {
    
    private var scalef:Number;
    
    private var BGColor:uint;
    private var mapArray:Array = new Array();
    private var mapBoundArray:Array = new Array(4);
    
    private var _ox:int = 0;
    private var _oy:int = 50;
    
    private var _stage_width:int;
    private var _stage_height:int;    
    private var _current_map:int = 1;
    private var _container:Sprite;
    
    private var loaderArray:Array = new Array();
    private var countLoadedXML:Number = 0;
    //private var loader:URLLoader = new URLLoader();
    
    private var xmlCountyData:XML;
    //private var dictCountyPopArray:Array = new Array();
    //private var dictChangePopArray:Array = new Array();
    
    private var mapLoadedCount:Number = 0;
    private var _bar:ProgressBar;
    
    private var curCounty:String = "";
    private var state:String = "";
    private var population:String = "";
    private var area:String = "";
    private var num_physicians:String = "";
    private var per_capita_physicians:String = "";
    
    
    // "none", "percapita_physicians", "population", "density", "percent"
    public var showMode:String = "population";
	public var years:Array = new Array(1909, 1980, 2000, 2009);
    
    private var border:Boolean;  
    
    public function ShpMapObject(width:int, height:int, mapContainer:Sprite, progressBar:ProgressBar = null)
    {
      BGColor = 0x000000;
      _stage_width = width;
      _stage_height = height;
      _container = mapContainer;
      _bar = progressBar;
      
	  /*
	  TODO: this is original code, to be removed
      var i:int, year:int;
      for (i=0; i<17; i++) {
        year = 1850 + i*10;
        var loader:URLLoader = new URLLoader();
        loader.load(new URLRequest("../dat/census" + year.toString() + ".xml"));
        loader.addEventListener(Event.COMPLETE, xmlLoadComplete);
        loaderArray.push(loader);
      }
	  */


	  //years[0] = 1909;
	  //years[1] = 1980;
	  //years[2] = 2000;
	  //years[3] = 2009;
	  var i:int, year:int;
	  for (i = 0; i < 4; i++) {
		  year = years[i];
		  var loader:URLLoader = new URLLoader();
		  loader.load(new URLRequest("../dat/physician_by_county" + year.toString() + ".xml"));
		  loader.addEventListener(Event.COMPLETE, xmlLoadComplete);
		  loaderArray.push(loader);
	  }
      
      border = true;
    }
    
    private function xmlLoadComplete(event:Event):void {
      countLoadedXML += 1;
	  trace(countLoadedXML);
      if (countLoadedXML == 4) {
        loadShpMaps();
      }
    }
    
    private function loadShpMaps():void {
      trace('$census data loaded$');
      var i:int;
	  
	  for (i=0; i<4 ; i++) {
		  var censusData:Dictionary = new Dictionary();
		  //var dictChangePopulation:Dictionary = new Dictionary();
		  xmlCountyData = new XML(loaderArray[i].data);
		  for each (var county:Object in xmlCountyData.county) {
			  var obj:Object = new Object;
			  
			  /*
			  obj["total"]  = parseInt(county["totPop"]);
			  obj["change"] = county["change"].toString();
			  obj["age17"]  = parseInt(county["age17"]);
			  obj["age20"]  = parseInt(county["age20"]);
			  obj["age44"]  = parseInt(county["age44"]);
			  obj["age65"]  = parseInt(county["age65"]);
			  obj["edu18"]  = parseFloat(county["edu18"]);
			  obj["changeColor"] = 0x000000;
			  obj["changeText"] = "";
			  */

			  obj["fips"] = county["fips"].toString();
			  obj["countyname"] = county["countyname"].toString();
			  obj["numPhys"] = parseInt(county["numPhys"]);
			  obj["numPop"] = parseInt(county["numPop"]);
			  obj["state"] = county["state"].toString();

			  censusData[county["fips"].toString()] = obj;
			  
			  //dictChangePopulation[county["fips"].toString()] = county["change"].toString();
		  }
		  //dictCountyPopArray.push(censusData);
		  
		  //var year:Number = 1850+i*10;
		  var year:Number = this.years[i];
		  var elem:ShpMapElement = new ShpMapElement(year, censusData);
		  elem.addEventListener(Event.CHANGE, countyChangeHandler);
		  
		  elem.visible = false;
		  elem.addEventListener("map loaded",onMapLoaded);
		  elem.addEventListener("attributes loaded",onAttributesLoaded);
		  
		  mapArray.push(elem);
		  mapBoundArray[i] = new Shape();
		  var shp:Shape = mapBoundArray[i];
		  shp.graphics.clear();
		  shp.graphics.beginFill(BGColor);
		  shp.graphics.drawRect(_ox, _oy, _stage_width, _stage_height);
		  shp.graphics.endFill();
		  shp.x = 7;
		  shp.y = -18;
		  
		  elem.mask = shp;
	  }

    }
    
    // THESE ARE FOR TOOL TIPS:
    private function countyChangeHandler(event:Event):void
    {
      curCounty = event.currentTarget.getCounty();
      population = event.currentTarget.getPopulation();
      area = event.currentTarget.getArea();
      state = event.currentTarget.getState();
      num_physicians = event.currentTarget.getNumPhysicians();
      per_capita_physicians = event.currentTarget.getPerCapita();
      
      dispatchEvent(new Event(Event.CHANGE));
    }

    public function getCounty():String{
      return curCounty;
    }
    public function getState():String{
      return state;
    }
    public function getPopulation():String{
      return population;
    }
    public function getArea():String{
      return area;
    }
    public function getNumPhysicians():String{
      return num_physicians;
    }
    public function getPerCapita(){
      return per_capita_physicians;
    }
    
    // THE ABOVE WERE FOR TOOLTIPS
    
    // Need to wait for the map to finish loading/drawing before it can be resized correctly.
    private var onMapLoaded:Function = function(event:Event):void
    {
      trace("$onMapLoaded$");
      
      var map:Object = event.target;
      _container.addChild(Sprite(map));
      //map.scaleX = map.scaleY = map.width > map.height ? _stage_width/map.width : _stage_height/map.height;
      map.scaleX = map.scaleY = 0.3;
      map.x = 60;
      map.y = 50;
      //image_left = 90;
      //  image_top = -70;
      
      // just for fun, add a marker to somewhere around my house!
      ///addMarkerAt( 42.36,-71.11 );
    }
    
    public function getShpScale():Number
    {
      //var elem:ShpMapElement = mapArray[0];
      //scalef = elem.scaleX;
      return scalef;
    }
    
    // To demonstrate retrieving a particular feature and doing something to it. This colors Wisconsin green.
    private var onAttributesLoaded:Function = function(event:Event):void
    {
      trace("$onAttributedsLoaded$")
      mapLoadedCount++;
      trace(mapLoadedCount);
      
      _bar.progress = mapLoadedCount / 4;
      if (mapLoadedCount >= 4) {
        dispatchEvent(new Event("all map loaded",true));
      }
      
      var map:Object = event.target;

    }
    
    public function updateMapColor():void {
      for (var i:int = 0; i<4; i++) {
        mapArray[i].getBorder(border);
        mapArray[i].updateMapColor(showMode);
      }
    }
    
    // Super basic method for adding a green box at a specified lat/long.
    private function addMarkerAt( lat : Number, lon : Number )  : void
    {
      var box : Sprite = new Sprite();
      box.graphics.lineStyle(1,0,1,false,"none");
      box.graphics.beginFill(0x009933);
      box.graphics.drawRect(-.5,-.5,1,1);
      box.graphics.endFill();
      mapArray[_current_map].addMarker(lat,lon,box);
    }
    
    public function SetMapEmbedSrc(sel:int):void
    {
      var obj:Object;
      for each (obj in mapArray){
        obj.visible = false;
      }
      mapArray[sel].visible = true;
      _current_map = sel;
    }
    
    public function SetMapColor(color:uint):void
    {
      BGColor = color;
    }
    
    public function ScaleMap(factor:Number):void
    {
      var obj:Sprite;
      for each(obj in mapArray){
        obj.width *= factor;
        obj.height *= factor;
      }
    }
  
    public function ScaleAndTranslateMap(sc:Number, sx:int, sy:int):void
    {
      var obj:ShpMapElement;
      for each(obj in mapArray){
        obj.scaleX = sc;
        obj.scaleY = sc;
        obj.x = sx;
        obj.y = sy;
      }
    }
    
    public function SetMap(ox:int, oy:int, width:int, height:int):void
    {
      var shp:Shape;
      for each(shp in mapBoundArray){
        shp.graphics.clear();
        shp.graphics.beginFill(BGColor);
        shp.graphics.drawRect(ox, oy, width, height);
        shp.graphics.endFill();
      }
      
      var obj:Sprite;
      var i:int;
      for each (obj in mapArray){
        obj.mask = mapBoundArray[i];
        i++;
      }
    }
    
    public function GetMap():Sprite
    {
      return mapArray[_current_map]; 
    }
    
    public function GetVizAt(i:int):Sprite
    {
      return mapArray[i];
    }
    
    public function getBorder(inbool:Boolean):void{
      border = inbool;
    }
  }
}