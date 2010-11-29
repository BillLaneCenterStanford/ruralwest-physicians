package
{
  import flare.widgets.ProgressBar;
  
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Dictionary;

  public class ShpMapObjectCT extends Sprite
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
    private var countLoadedCSV:Number = 0;
    //private var loader:URLLoader = new URLLoader();
   
    //private var dictCountyPopArray:Array = new Array();
    //private var dictChangePopArray:Array = new Array();
    
    private var mapLoadedCount:Number = 0;
    private var _bar:ProgressBar;
    private var num_maps:int = 2;
    
    private var ct_number:String = "";
    private var population:String = "";
    private var primary_phys:String = "";
    private var other_phys:String = "";
    private var all_phys:String = "";
    
    
    // "none", "percapita_physicians", "population", "density", "percent"
    public var showMode:String = "primary";
	  public var years:Array = new Array(2000, 2009);
    
    private var border:Boolean = false;  
    private var western:Boolean = false;
    
    public function ShpMapObjectCT(width:int, height:int, mapContainer:Sprite, progressBar:ProgressBar = null)
    {
      BGColor = 0x000000;
      _stage_width = width;
      _stage_height = height;
      _container = mapContainer;
      _bar = progressBar;

	  var i:int, year:int;
	  for (i = 0; i < num_maps; i++) {
		  year = years[i];
		  var loader:URLLoader = new URLLoader();
		  loader.load(new URLRequest("../dat/census_tract/censustract_physicians_" + year.toString() + ".csv"));
		  loader.addEventListener(Event.COMPLETE, csvLoadComplete);
		  loaderArray.push(loader);
	  }
      
      border = false;
    }
    
    private function csvLoadComplete(event:Event):void {
      countLoadedCSV += 1;
	  trace(countLoadedCSV);
      if (countLoadedCSV == num_maps) {
        loadShpMaps();
      }
    }
    
    private function loadShpMaps():void {
      trace('$census data loaded$');
      var i:int;
  	  
  	  for (i=0; i<num_maps ; i++) {
  		  var ctData:Dictionary = new Dictionary();
  		  
  		  var dataStream:String = loaderArray[i].data;
  		  
  		  var allCTArray:Array = dataStream.split("\n");
  
        for(var j:int = 0; j < allCTArray.length; j++){
    
          // grab one line of data
          var thisData:String = allCTArray[j];
          if(thisData.charAt(0) == '#')
            continue;
          // make sure we don't have garbage data
          if(thisData.length < 10)
            continue;
          var thisDataArray:Array = thisData.split(",");
          
          var ct_num:int = parseInt(thisDataArray[0]);
          var primary_phys:int = parseInt(thisDataArray[1]);
          var other_phys:int = parseInt(thisDataArray[2]);
          var all_phys:int = parseInt(thisDataArray[3]);
          
          var obj:Object = new Object;
          obj["ct_num"] = ct_num;
          obj["primary_phys"] = primary_phys;
          obj["other_phys"] = other_phys;
          obj["all_phys"] = all_phys;
          
          ctData[ct_num] = obj;
   
        }
  	
  		  //dictCountyPopArray.push(censusData);
  		  
  		  //var year:Number = 1850+i*10;
  		  var year:Number = this.years[i];
  		  var elem:ShpMapElementCT = new ShpMapElementCT(year, ctData);
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
    {/*
      curCounty = event.currentTarget.getCounty();
      population = event.currentTarget.getPopulation();
      area = event.currentTarget.getArea();
      state = event.currentTarget.getState();
      num_physicians = event.currentTarget.getNumPhysicians();
      per_capita_physicians = event.currentTarget.getPerCapita();
      
      dispatchEvent(new Event(Event.CHANGE));
     */
    }

    public function getCTNumber():String{
      return ct_number;
    }
    public function getPopulation():String{
      return population;
    }
    public function getPrimaryPhys():String{
      return primary_phys;
    }
    public function getOtherPhys():String{
      return other_phys;
    }
    public function getAllPhys():String{
      return all_phys;
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
      
      _bar.progress = mapLoadedCount / num_maps;
      if (mapLoadedCount >= num_maps) {
        dispatchEvent(new Event("all map loaded",true));
      }
      
      var map:Object = event.target;

    }
    
    public function updateMapColor():void {
      for (var i:int = 0; i<num_maps; i++) {
        mapArray[i].getBorder(border);
        mapArray[i].getWestern(western);
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
      var obj:ShpMapElementCT;
      for each(obj in mapArray){
        obj.scaleX = sc * 30;
        obj.scaleY = sc * 36;
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
    
    public function getWestern(inbool:Boolean):void{
      western = inbool;
    }
  }
}