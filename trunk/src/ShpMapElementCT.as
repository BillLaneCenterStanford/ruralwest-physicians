package
{
  import com.cartogrammar.shp.ShpMapCT;
  
  import flash.utils.Dictionary;
    
  public class ShpMapElementCT extends ShpMapCT
  {
    //public var data:Object; //XML, CSV or JSON
    public var year:Number;
  
    public function ShpMapElementCT(year:Number, censusData:Dictionary = null) {
      this.year = year;
      
      // if using shp files on server //
      /*
      super("http://ruralwest.stanford.edu/GIS/us"+year.toString()+".shp",
            "http://ruralwest.stanford.edu/GIS/US"+year.toString()+".DBF",
            censusData);
      */      

      // if using shp files on local //
      
      super("../shp/test.shp",
            "../shp/test.dbf",
            censusData);
            /*
      super("../shp/ct_western.shp",
            "../shp/ct_western.dbf",
            censusData);
           */
    }
  }
}