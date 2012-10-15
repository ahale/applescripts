set username to "X-Auth-User: CLOUD_USER"
set authpass to "X-Auth-Key: CLOUD_KEY"
set authurl to "https://lon.auth.api.rackspacecloud.com/v1.0"
set container to "dropbox"
set datestamp to do shell script "date +%s"
set tmpfile to do shell script "echo '/tmp/'$(date +%s)"
set filename to do shell script "basename " & tmpfile
do shell script "screencapture -tjpg -s " & tmpfile
set authfile to do shell script "mktemp /tmp/authXXXXXXXX"
do shell script "curl -D " & authfile & " -H '" & username & "' -H '" & authpass & "' " & authurl
set token to do shell script "grep ^X-Auth-Token " & authfile
set storageapi to do shell script "awk '/^X-Storage-Url/{print $2}' " & authfile
set cdnapi to do shell script "awk '/^X-CDN-Management-Url/{print $2}' " & authfile
# uncomment this to use long default urls or set a cname alias
# set cdnurl to do shell script "curl -sD - -X HEAD -H '" & token & "' " & cdnapi & "/" & container & " | awk '/^X-Cdn-Uri/{print $2}'"
set cdnurl to "http://alias.domain.com"
do shell script "curl -s -XPUT -H '" & token & "' -H 'Content-Type: image/jpeg' -T '" & tmpfile & "' " & storageapi & "/" & container & "/" & filename & ".jpg"
tell application "Finder" to set the clipboard to cdnurl & "/" & filename & ".jpg"
do shell script "rm -f " & tmpfile
do shell script "rm -f " & authfile