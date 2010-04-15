<?php

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

  $handle = fopen("csv/".$table."_new.txt", "r");
  while ($data = fscanf($handle, "%d\t%d\t%s\t%d\t%d\t%d\n")) {
    list($stateId, $countyId, $age20, $age44, $age65) = $data;
    $query = "UPDATE ".$table." SET Age20 = $age20, Age2044 = $age44, Age65 = $age65".
             " WHERE StateId = $stateId AND CountyId = $countyId";
    //echo $query."\r\n";
    $result = mysql_query($query);
  }
?>
