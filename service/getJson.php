<?php
$json = file_get_contents('https://spreadsheets.google.com/feeds/list/1-dOIRDMbA7D-XKTw0ZLqlX9Ls-by7SLs5YBjmUpgq8s/1/public/full?alt=json');

$raw = json_decode($json);
$obj = $raw->feed->entry;

$data = array(); 
//var_dump($obj->feed->entry);
for ($i = 0; $i < count($obj); $i++) {
    $arr = array('sku' => $obj[$i]->{'gsx$sku'}->{'$t'}, 
    	'descripcion' => $obj[$i]->{'gsx$descripcion'}->{'$t'}, 
    	'cantidad' => $obj[$i]->{'gsx$cantidad'}->{'$t'},
    	'ivaPorcentaje' => $obj[$i]->{'gsx$iva'}->{'$t'},
    	'precioUnitario' => $obj[$i]->{'gsx$preciodeventaunitario'}->{'$t'},
    	'ivaUSD' => $obj[$i]->{'gsx$ivadebitoventa'}->{'$t'},
    	'precioCantidad' => $obj[$i]->{'gsx$preciodeventa'}->{'$t'}
    );
    
    array_push($data, $arr);
}

echo json_encode($data);
?>