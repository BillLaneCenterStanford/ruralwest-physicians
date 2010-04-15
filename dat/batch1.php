<?php

exec("rm -rf *.xml");

for ($i=1850; $i<=2000; $i+=10) {
  exec("php census1.php ".$i." > census".$i.".xml");
}
