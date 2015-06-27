<!DOCTYPE html>
<html>
<body>
	<?php
		#echo $_ENV['HOSTNAME'];
		#print getenv('HOSTNAME');
		#var_dump($_ENV);
		#system('env');
		system('/bin/bash /data/http/env.sh');
	?>
</body>
</html>
