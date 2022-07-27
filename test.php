<?php
$keys = array('hi',); 
$sub = $_GET["key"];

if (in_array($sub,$keys,TRUE)){
    print('true');
} 
else 
{
    print('fok yoy');
}
?>
