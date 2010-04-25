package {
  import fl.controls.CheckBox;
  
  import flare.display.TextSprite;
  import flare.widgets.ProgressBar;
  
  import flash.display.Bitmap;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.*;
  import flash.filters.DropShadowFilter;
  
  [SWF(width="810", height="650", backgroundColor="#EBD6A5", frameRate="30")]

  public class ruralwestphysicians extends Sprite
  {
    private var blackBG:Sprite;
    private var mapContainer:Sprite;
    private var sideControlPanelBG:Sprite;
    
    private var ZUI:ZoomUI;
    private var _bar:ProgressBar;
    
    private var tl:timeline;
    private var this_year:int;
    private var year_display:TextSprite;
    
    // tooltip text sprites
    private var tt_county_state:TextSprite;
    private var tt_population:TextSprite;
    private var tt_num_physicians:TextSprite;
    private var tt_per_capita_physicians:TextSprite;
    private var tt_area:TextSprite;
    
    // The Map Object for the SVG map and frame
    private var mapObj:Object;
    
    private var borderCB:CheckBox;
    private var overlayCB:CheckBox;
    
    [Embed(source="../img/lightBW.png")]
    private var lightMap:Class;
    private var instLightMap:Bitmap;
    
    public function ruralwestphysicians()
    {
      
      
      
      blackBG = new Sprite();
      blackBG.graphics.beginFill(0xeeeeee);
      blackBG.graphics.drawRect(0, 0, 810, 650);
      blackBG.graphics.endFill();
      addChild(blackBG);
      
      var MedicalSign:Sprite = new Sprite();
      MedicalSign.x = 22;
      MedicalSign.y = 16;
      MedicalSign.graphics.beginFill(0xffffff, 1.0);
      MedicalSign.graphics.drawCircle(0, 0, 12);
      MedicalSign.graphics.endFill();
      MedicalSign.graphics.beginFill(0xff0000, 1.0);
      MedicalSign.graphics.drawRect(-7, -2, 14, 4);
      MedicalSign.graphics.endFill();
      MedicalSign.graphics.beginFill(0xff0000, 1.0);
      MedicalSign.graphics.drawRect(-2, -7, 4, 14);
      addChild(MedicalSign);
      
      var MainTitle:TextSprite = new TextSprite();
      MainTitle.x = 11 + 30;
      MainTitle.y = 0;
      MainTitle.font = "Calibri";
      MainTitle.size = 24;
      MainTitle.color = 0x003A52;
      MainTitle.text = "Per Capita Physicians in the Western US";
      addChild(MainTitle);
      
      ZUI = new ZoomUI(0.3, 0.1, 10.0);
      this.addEventListener( MouseEvent.MOUSE_DOWN, onDrag);
      ZUI.addEventListener(Event.CHANGE, ZUIHandler);
      ZUI.addMapControl();

      loadMap();
      
      sideControlPanelBG = new Sprite();
      sideControlPanelBG.graphics.beginFill(0x288AB5, 0.85);
      sideControlPanelBG.graphics.drawRect(650, 32, 154, 611);
      sideControlPanelBG.graphics.endFill();
      addChild(sideControlPanelBG);
      
      var bottomPanelBG:Sprite = new Sprite();
      bottomPanelBG.graphics.beginFill(0x288AB5, 0.85);
      bottomPanelBG.graphics.drawRect(7, 533, 643, 110);
      bottomPanelBG.graphics.endFill();
      addChild(bottomPanelBG);
      
      var divider:Sprite = new Sprite();
      divider.graphics.beginFill(0xdddddd, 1.0);
      divider.graphics.drawRect(650, 32, 4, 611); // left side divider, vertical
      divider.graphics.drawRect(7, 533, 643, 4);  // bottom divider, horizontal
      divider.graphics.drawRect(400, 537, 4, 110);  // bottom divider, vertical
      divider.graphics.endFill();
      addChild(divider);
      
      addChild(ZUI);
      
      tl = new timeline(33, 560, 330, 1909, 2009);
      var yrArray:Array = new Array(1909, 1980, 2000, 2009);
      var intArray:Array = new Array(0, 33, 66, 100);
      tl.setYearsInts(yrArray, intArray);
      tl.DrawTimeline();
      tl.addEventListener(Event.CHANGE, tlHandler);
      addChild(tl);
      
      year_display = new TextSprite();
      year_display.x = 415 + 30;
      year_display.y = 0;
      year_display.color = 0x0D658A;
      year_display.font = "Calibri";
      year_display.text = "Year " + tl.getSelectedYear().toString();
      year_display.size = 24;
      addChild(year_display);
      
      var tt_text_size:int = 16;
      var tt_vert_spacing:int = 18;
      var tt_ox:int = 420;
      var tt_oy:int = 540;
      
      tt_county_state = new TextSprite();
      tt_county_state.color = 0xffffff;
      tt_county_state.size = tt_text_size;
      tt_county_state.font = "Calibri";
      tt_county_state.x = tt_ox;
      tt_county_state.y = tt_oy;
      tt_county_state.text = "TOOLTIP";
      tt_county_state.visible = true;
      addChild(tt_county_state);
      
      tt_population = new TextSprite();
      tt_population.color = 0xffffff;
      tt_population.size = tt_text_size;
      tt_population.font = "Calibri";
      tt_population.x = tt_ox;
      tt_population.y = tt_oy + tt_vert_spacing*1;
      tt_population.text = "Mouse over a county for";
      tt_population.visible = true;
      addChild(tt_population);
      
      tt_num_physicians = new TextSprite();
      tt_num_physicians.color = 0xffffff;
      tt_num_physicians.size = tt_text_size;
      tt_num_physicians.font = "Calibri";
      tt_num_physicians.x = tt_ox;
      tt_num_physicians.y = tt_oy + tt_vert_spacing*2;
      tt_num_physicians.text = "more information.";
      tt_num_physicians.visible = true;
      addChild(tt_num_physicians);
      
      tt_per_capita_physicians = new TextSprite();
      tt_per_capita_physicians.color = 0xffffff;
      tt_per_capita_physicians.size = tt_text_size;
      tt_per_capita_physicians.font = "Calibri";
      tt_per_capita_physicians.x = tt_ox;
      tt_per_capita_physicians.y = tt_oy + tt_vert_spacing*3;
      tt_per_capita_physicians.visible = true;
      addChild(tt_per_capita_physicians);
      
      tt_area = new TextSprite();
      tt_area.color = 0xffffff;
      tt_area.size = tt_text_size;
      tt_area.font = "Calibri";
      tt_area.x = tt_ox;
      tt_area.y = tt_oy + tt_vert_spacing*4;
      tt_area.visible = true;
      addChild(tt_area);
      
      borderCB = new CheckBox();
      borderCB.x = 660;
      borderCB.y = 390;
      borderCB.selected = true;
      borderCB.label = "";
      addChild(borderCB);
      
      borderCB.addEventListener(Event.CHANGE, CBBorderHandler);
      
      var border_label:TextSprite = new TextSprite();
      border_label.font = "Calibri";
      border_label.size = 16;
      border_label.color = 0xffffff;
      border_label.x = 683;
      border_label.y = 385;
      border_label.text = "display county \r borders";
      addChild(border_label);
      
      overlayCB = new CheckBox();
      overlayCB.x = 660;
      overlayCB.y = 490;
      overlayCB.selected = false;
      overlayCB.label = "";
      addChild(overlayCB);
      
      overlayCB.addEventListener(Event.CHANGE, CBOverlayHandler);
      
      var overlay_label:TextSprite = new TextSprite();
      overlay_label.font = "Calibri";
      overlay_label.size = 16;
      overlay_label.color = 0xffffff;
      overlay_label.x = 683;
      overlay_label.y = 485;
      overlay_label.text = "display rural \r overlay";
      addChild(overlay_label);
      
    }
    
    private function CBBorderHandler(event:Event):void{
        mapObj.getBorder(borderCB.selected);
        mapObj.updateMapColor();
    }
    
    private function loadMap():void
    {
      
      instLightMap = new lightMap as Bitmap;
      
      mapContainer = new Sprite();
      mapContainer.graphics.beginFill(0x006BAF);
      mapContainer.x = 7;
      mapContainer.y = 32;
      mapContainer.graphics.drawRect(0,0,797,611);
      mapContainer.graphics.endFill();
      addChild(mapContainer);

      _bar = new ProgressBar();
      _bar.bar.filters = [new DropShadowFilter(1)];
      _bar.x = 250;
      _bar.y = 300;
      _bar.progress = 0.0;    

      // *********** Below code loads shp object ************ //
      mapObj = new ShpMapObject(797, 611, mapContainer, _bar);
      mapObj.addEventListener("all map loaded", allMapLoaded);
      mapObj.addEventListener(Event.CHANGE, ttHandler);    // handles tooltips events
      mapObj.showMode = "percapita_physicians";

      mapObj.SetMapColor(0xff0000);
      mapObj.SetMap(0, 0, 767, 611);
      
      mapObj.ScaleAndTranslateMap(ZUI.getScaleFactor(), ZUI.getImageLeft(), ZUI.getImageTop());
      //mapObj.addEventListener(Event.CHANGE, ttHandler);    // handles tooltips events
      
      //initTTGraphics();
      
      addChild(_bar);
      
      var boundLightMap:Shape = new Shape();
      boundLightMap.graphics.clear();
      boundLightMap.graphics.beginFill(0x000000);
      boundLightMap.graphics.drawRect(0, 50, 810, 560);
      boundLightMap.graphics.endFill();
      instLightMap.mask = boundLightMap;
      
      instLightMap.scaleX = ZUI.getScaleFactor()*0.9;
      instLightMap.scaleY = ZUI.getScaleFactor()*0.9;
      instLightMap.x = ZUI.getImageLeft2();
      instLightMap.y = ZUI.getImageTop2();
    }
    
    private function allMapLoaded(event:Event):void {
      
      instLightMap.visible = false;
      mapContainer.addChild(instLightMap);
      
      try {
        removeChild(_bar);
      } catch (e:ArgumentError) {
        //DO NOTHING
      }
      mapObj.updateMapColor();
      //single_selected = tl_single.getCurSelectedZone();
      mapObj.SetMapEmbedSrc(3);

    }
    
    private function ttHandler(event:Event):void
    {
      /*
      tt_county_state
      tt_population
      tt_per_capita_physicians
      tt_num_physicians
      tt_area
      */
      //tt_county.text = trim((0, 15, mapObj.getCountyName()).substr(0, 12));
      
      var cnty:String = mapObj.getCounty();
      if(cnty.length > 0){
        tt_county_state.text = mapObj.getCounty() + ", " + mapObj.getState();
        tt_population.text = "Population: " + mapObj.getPopulation();
        tt_num_physicians.text = "Num Physicians: " + mapObj.getNumPhysicians();
        tt_per_capita_physicians.text = "Physicians Per Capita: " + mapObj.getPerCapita();
        var ar:String = mapObj.getArea();
        if(ar.length > 0)
          tt_area.text = "Area: " + mapObj.getArea() + " sq. miles";
        else
          tt_area.text = "";
      }
      else{
        tt_county_state.text = "TOOLTIP";
        tt_population.text = "Mouse over a county for";
        tt_num_physicians.text = "more information.";
        tt_per_capita_physicians.text = "";
        tt_area.text = "";
      }
      
    }
    
    private function ZUIHandler(event:Event):void
    {
      //RescaleDots();
      //RescaleMap();
      // do rescale functions here
      
      instLightMap.scaleX = ZUI.getScaleFactor()*0.9;
      instLightMap.scaleY = ZUI.getScaleFactor()*0.9;
      instLightMap.x = ZUI.getImageLeft2();
      instLightMap.y = ZUI.getImageTop2();
      
      mapObj.ScaleAndTranslateMap(ZUI.getScaleFactor(), ZUI.getImageLeft(), ZUI.getImageTop());
    }
    
    private function CBOverlayHandler(event:Event):void{
        instLightMap.visible = overlayCB.selected;
    }
    
    private function tlHandler(evt:Event):void
    {
      this_year = tl.getSelectedYear();
      year_display.text = "Year " + this_year.toString();
      mapObj.SetMapEmbedSrc(tl.getSelectedZone());
    }
    
    private var orgX:int;
    private var orgY:int;
    private var orgLeft:int;
    private var orgTop:int;
    private var orgLeft2:int;
    private var orgTop2:int;
    
    private function onDrag(event:MouseEvent):void
    {
      trace(event.stageX + ":" + event.stageY + " -- " + ZUI.getImageLeft() + ":" + ZUI.getImageTop() + ":" + ZUI.getScaleFactor());
      
      if (event.stageX > 0 && event.stageX < ZUI.getFrameWidth() &&
        event.stageY > 0 && event.stageY < ZUI.getFrameHeight() - 40 )
      {

        orgX = event.stageX;
        orgY = event.stageY;
        orgLeft = ZUI.getImageLeft();
        orgTop = ZUI.getImageTop();
        orgLeft2 = ZUI.getImageLeft2();
        orgTop2 = ZUI.getImageTop2();
        this.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        this.addEventListener(MouseEvent.MOUSE_UP, onDrop);
      }
    }

    private function onMove(event:MouseEvent):void
    {
      if (event.stageX > 0 && event.stageX < ZUI.getFrameWidth() &&
        event.stageY > 0 && event.stageY < 10 + ZUI.getFrameHeight() )
      {
        ZUI.setImageLeft(orgLeft + (event.stageX - orgX), orgLeft2 + (event.stageX - orgX));
        ZUI.setImageTop(orgTop  + (event.stageY - orgY), orgTop2 + (event.stageY - orgY));

        mapObj.ScaleAndTranslateMap(ZUI.getScaleFactor(), ZUI.getImageLeft(), ZUI.getImageTop());
      }
    }
    
    private function onDrop(event:MouseEvent):void
    {
      this.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
      this.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
    }
    
  }
}
