<?php
function validBuildDir($dir)
{
  return ($dir != '.' && $dir != '..');    
}


$dirs = scandir('archive');
$dirs = array_filter($dirs, "validBuildDir");
rsort( $dirs);

$latest = $dirs[0];

?>
<!DOCTYPE html>
<html>
<head>
  <title>Hesperian Mobile Application Development Site</title>
</head>
<body>
<p>
The Latest Build (<?php print $latest ?>):
<ul>
<li><a href="latest/whatsnew.html">What's New</a></li>
<li><a href="latest/app/index.html">View in a browser</a></li>
<li><a href="latest/Safe-Pregnancy-and-Birth.ipa">Non-testflight iOS 3 iPhone App download</a></li>
</ul>
</p>

<p>
All Builds:
<ul>
<?php
foreach ($dirs as $build)
print "<li><a href=\"archive/$build/\">Build $build</a></li>"
?>
</ul>
</p>
<body>
</html>
