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
  //echo $table;

  //connect to the database
  $mysql = mysql_connect($DATABASE_SERVER, $DATABASE_USERNAME, $DATABASE_PASSWORD);
  if (!$mysql) {
    die('could not connect to database');
  }
  mysql_select_db( $DATABASE_NAME );
  $query = "SELECT * FROM `$table`";
  $result = mysql_query($query);
  $return = "<records>\n";

  while ($county = mysql_fetch_object($result)) {
    //print_r($county);
    if (floatval($county->FIPS)) {
      $return .= "<county>\n".
                    "\t<totPop>".$county->TotPop."</totPop>\n".
                    "\t<fips>".floatval($county->FIPS)."</fips>\n".
                 "</county>\n";
    }
  }
  $return .= "</records>";

  mysql_free_result($result);
  echo $return;

?>
