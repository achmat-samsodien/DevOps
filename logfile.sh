if(($#!=1))
then
	# Then, display usage
	echo "Usage: $0 [LOG FILE]"
else
	# Assign the file name to a variable
	LOG_FILE=$1

	# Count the number of lines in the log file
	stale=$(cat $LOG_FILE | wc -l)
	
	while true
	do
		new=$(cat $LOG_FILE | wc -l)
		
		if [[ $new -gt $stale ]]
		then
			while read -r line; do
			
				httpCode=$(echo $line | grep -Eo '"(GET|POST) /[^ ]* HTTP/[012].[0-9]" [1-6][0-9][0-9]' | cut -d' ' -f4)
				
				# Get the HTTP path from the log entry
				path=$(echo $line | grep -Eo '"(GET|POST) /[^ ]* HTTP/[012].[0-9]" [1-6][0-9][0-9]' | cut -d' ' -f2)
				
				# Check if 'httpCode' is 500
				if [[ $httpCode == "500" ]]
				then
					# Then, send a mail using the mail command and display a success message
					mail "alert@project.com" "HTTP 500 on $path" 2>/dev/null
					echo "A mail has been sent to \"alert@project.com\" as \"HTTP 500 on $path\""
				fi
			done < <(cat $LOG_FILE | tail -$((new-stale)))
			
			# Set 'new' to 'stale'
			stale=$new
		fi
	done
fi
