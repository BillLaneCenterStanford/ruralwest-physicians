package {
  import flare.display.TextSprite;
  import flare.widgets.ProgressBar;
  
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
    
    // The Map Object for the SVG map and frame
    private var mapObj:Object;
    
    public function ruralwestphysicians()
    {
      
      blackBG = new Sprite();
      blackBG.graphics.beginFill(0xeeeeee);
      blackBG.graphics.drawRect(0, 0, 810, 650);
      blackBG.graphics.endFill();
      addChild(blackBG);
      
      var MainTitle:TextSprite = new TextSprite();
      MainTitle.x = 11;
      MainTitle.y = 1;
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
      sideControlPanelBG.graphics.beginFill(0xBCE4F5, 0.85);
      sideControlPanelBG.graphics.drawRect(650, 32, 154, 611);
      sideControlPanelBG.graphics.endFill();
      addChild(sideControlPanelBG);
      
      var bottomPanelBG:Sprite = new Sprite();
      bottomPanelBG.graphics.beginFill(0xBCE4F5, 0.85);
      bottomPanelBG.graphics.drawRect(7, 533, 643, 110);
      bottomPanelBG.graphics.endFill();
      addChild(bottomPanelBG);
      
      var divider:Sprite = new Sprite();
      divider.graphics.beginFill(0xeeeeee, 1.0);
      divider.graphics.drawRect(650, 32, 4, 611); // left side divider, vertical
      divider.graphics.drawRect(7, 533, 643, 4);  // bottom divider, horizontal
      divider.graphics.drawRect(400, 537, 4, 110);  // bottom divider, vertical
      divider.graphics.endFill();
      addChild(divider);
      
      addChild(ZUI);
      
    }
    
    private function loadMap():void
    {
      
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
      mapObj.showMode = "percapita_physicians";

      mapObj.SetMapColor(0xff0000);
      mapObj.SetMap(0, 0, 767, 611);
      
      mapObj.ScaleAndTranslateMap(ZUI.getScaleFactor(), ZUI.getImageLeft(), ZUI.getImageTop());
      //mapObj.addEventListener(Event.CHANGE, ttHandler);    // handles tooltips events
      
      //initTTGraphics();
      
      addChild(_bar);
    }
    
    private function allMapLoaded(event:Event):void {
      
      try {
        removeChild(_bar);
      } catch (e:ArgumentError) {
        //DO NOTHING
      }
      mapObj.updateMapColor();
      //single_selected = tl_single.getCurSelectedZone();
      mapObj.SetMapEmbedSrc(3);
      
      /*
      if (ExternalInterface.available) {
        try {
          trace("Entered External Interface");
          output.textField.text = "Entered External Interface";
          ExternalInterface.addCallback("getMapParams", getMapParams);
          ExternalInterface.addCallback("setMapParams", setMapParams);
        } catch (error:SecurityError) {
          trace("A SecurityError occurred: " + error.message);
          output.textField.text = "A SecurityError occurred: " + error.message;
        } catch (error:Error) {
          trace("An Error occurred: " + error.message);
          output.textField.text = "An Error occurred: " + error.message;
        }
      } else {
        trace("External interface is not available for this container.");
      }
      */
    }
    
    private function ZUIHandler(event:Event):void
    {
      //RescaleDots();
      //RescaleMap();
      // do rescale functions here
      
      mapObj.ScaleAndTranslateMap(ZUI.getScaleFactor(), ZUI.getImageLeft(), ZUI.getImageTop());
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
