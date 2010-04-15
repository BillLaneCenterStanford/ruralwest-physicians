<?php
  //Define("DATABASE_SERVER", "mysql-user.stanford.edu");
  //Define("DATABASE_USERNAME", "gruralwestcensu");
  //Define("DATABASE_PASSWORD", "yooduloc");
  //Define("DATABASE_NAME","g_ruralwest_census");

  $DATABASE_SERVER = "mysql-user.stanford.edu";
  $DATABASE_USERNAME = "gruralwestcensu";
  $DATABASE_PASSWORD = "geyuank";
  $DATABASE_NAME = "g_ruralwest_census";

  $table = "census" . $argv[1];
  $table_prev = "census" . $argv[2];
  $mysql = mysql_connect($DATABASE_SERVER, $DATABASE_USERNAME, $DATABASE_PASSWORD);
  if (!$mysql) {
    die('could not connect to database');
  }
  mysql_select_db( $DATABASE_NAME );
  $query = "SELECT now.TotPop as TotPop,
                   now.FIPS as FIPS,
                   prev.TotPop as PrevTotPop,
                   now.Age17,
                   now.Age20,
                   now.Age65,
                   now.Age2044,
                   now.Edu1820
                   FROM `$table` as now
                   LEFT JOIN `$table_prev` as prev
                   ON now.FIPS = prev.FIPS
                   ";
  $result = mysql_query($query);
  $return = "<records>\n";

  while ($county = mysql_fetch_object($result)) {
    //print_r($county);
    if (intval($county->FIPS)) {
      $popNow = $county->TotPop;
      $popPrev= $county->PrevTotPop;

      if ($popNow && $popPrev) {
        $change = floatval($popNow) / floatval($popPrev) - 1.0;
        $change = round($change, 3);
      } else {
        $change = "N/A";
      }

      $return .= "<county>\n".
                    "\t<fips>".floatval($county->FIPS)."</fips>\n".
                    "\t<totPop>".$county->TotPop."</totPop>\n".
                    //"\t<totPop>".$county->PrevTotPop."</totPop>\n".
                    "\t<change>".$change."</change>\n".
                    "\t<age17>".$county->Age17."</age17>\n".
                    "\t<age20>".$county->Age20."</age20>\n".
                    "\t<age65>".$county->Age65."</age65>\n".
                    "\t<age44>".$county->Age2044."</age44>\n".
                    "\t<edu18>".$county->Edu1820."</edu18>\n".
                 "</county>\n";
    }
  }
  $return .= "</records>";

  mysql_free_result($result);
  echo $return;

?>
