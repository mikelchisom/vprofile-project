# This assumes you already ran `mvn package` and generated `target/vprofile-*.war`
COPY target/vprofile-*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
