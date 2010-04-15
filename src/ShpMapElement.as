package
{
  import com.cartogrammar.shp.ShpMap;
  
  import flash.utils.Dictionary;
    
  public class ShpMapElement extends ShpMap
  {
    //public var data:Object; //XML, CSV or JSON
    public var year:Number;
  
    public function ShpMapElement(year:Number, censusData:Dictionary = null) {
      this.year = year;
      
      // if using shp files on server //
      /*
      super("http://ruralwest.stanford.edu/GIS/us"+year.toString()+".shp",
            "http://ruralwest.stanford.edu/GIS/US"+year.toString()+".DBF",
            censusData);
      */      

      // if using shp files on local //
      
      super("../shp/us"+year.toString()+".shp",
            "../shp/US"+year.toString()+".DBF",
            censusData);
           
    }
  }
}