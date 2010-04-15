package com.cartogrammar.shp
{
  import flash.geom.Rectangle;
  
  import org.vanrijkom.shp.ShpPolygon;
  import org.vanrijkom.shp.ShpRecord;
  
  /**
   * A display object for a single polygon feature.
   * @author Andy Woodruff
   * 
   */
  public class PolygonFeature extends ShpFeature
  {
    /**
     * Polygon geometry consists of one or more rings of points.
     * Each ring is an Array and defines a separate polygon.
     * (Consider Hawaii as a polygon feature: it is one feature
     * consisting of several separate shapes, i.e. islands.)
     */
    private var geometry : Array;
    
    public function PolygonFeature(record:ShpRecord)
    {
      super();
      geometry = (record.shape as ShpPolygon).rings;
      /*   If a differen map projection were desired, then here
        we could run each point in geometry through a
        transformation formula. */

      /* call draw from ShpMap explicitly */
      draw();
    }
    
    override public function draw(lineColor:uint = 0x666666, fillColor:uint = 0xcccccc, fillAlpha:Number = 1.0):void
    {
      shape.graphics.clear();
      shape.graphics.lineStyle(1,lineColor,1,false,"none");
      for each ( var ring:Array in geometry ) {
        shape.graphics.moveTo( ring[0].x*scaleFactor, -ring[0].y*scaleFactor );
        shape.graphics.beginFill(fillColor, fillAlpha);
        for ( var i : int = 1; i < ring.length; i ++ ) {
          shape.graphics.lineTo( ring[i].x*scaleFactor, -ring[i].y*scaleFactor );
        }
        shape.graphics.endFill();
      }
      shape.scaleX = shape.scaleY = 1/scaleFactor;  // see comment on scaleFactor in ShpFeature.as
      addChild(shape);
      
      var bounds : Rectangle = shape.getBounds(this);
      shape.x = -bounds.x;
      shape.y = -bounds.y;
      this.x = bounds.x;
      this.y = bounds.y;
      //trace(shape.x + " - " + fillColor.toString());
    }
    
  }
}