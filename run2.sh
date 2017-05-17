SNAPSHOT='-SNAPSHOT'

# The version to be released
releaseVersion=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[' | awk 'BEGIN { FS="." } { } { printf "%d.%d.%d\n", $1, $2, $3 }')

# The next development version
developmentVersion=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v '\[' | awk 'BEGIN { FS="." } { $3++; } { printf "%d.%d.%d\n", $1, $2, $3 }')$SNAPSHOT


echo $developmentVersion
echo $releaseVersion
echo $releaseVersion~1