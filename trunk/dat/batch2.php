<?php

exec("rm -rf *.xml");

for ($i=1850; $i<=2010; $i+=10) {
  if ($i==1850) {
    $j = $i;
  } else {
    $j = $i - 10;
  }

  exec("php census2.php ".$i." ".$j." > census".$i.".xml");
}
