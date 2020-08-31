# Docker Jenkins Task

## Task

1. Previous Job setup of CI from GitHub to Jenkins
2. Jenkins will test code(previous tests) and if succesful trigger build on Docker
3. Jenkins will trigger image to be pushed to dockerhub
4. Notification sent when the image is pushed to dockerhub
	- (email sent to Shahrukh and yourself/group)
	- Uses webhook on Dockerhub to trigger email being sent?

## Plan

- Download Jenkins 
	- Check working by going to website
	- Possible plugins needed
	- Docker
	- Github integration

- Jenkins CI Job going
	- Push from dev branch to master branch with automated tests
	- SSH key access needed?

- Jenkins CD Job
	- Upon completion of previous job run docker build command
	- Push image to dockerhub

- Notification
	- Part of CD job
	- Webhook on dockerhub
	- Emails sent out. 

## Steps

### Jenkins Download

- Download Jenkins and run installer
- https://www.gfi.com/support/products/how-do-i-configure-an-user-account-to-have-logon-as-a-service-permissions
- Download Java#
```https://java.com/en/download/win10.jsp```

### Run Jenkins with war file

```java -jar jenkins.war --httpPort=8080```

- Login with credentials at ```localhost:8080```
- May need to create if logging in for first time
- In case of log in problems see below link

```https://stackoverflow.com/questions/39340322/how-to-reset-the-use-password-of-jenkins-on-windows```

### Download Jenkins Plugins

- Plugin management is from manage jenkins > manage plugins
- As per screenshot, may need to restart after installation

### Create CI Job

- Per configuration
- Install npm and nodejs on OS
- Edit package.json file test line
```node ./node_modules/mocha/bin/_mocha```

- Killing process running. If port 3000 is in use, go into task task manager and end the node.js process

### Create CD Job

- Per configuration
- Execute shell commands per below
```
docker build -t max476/app-wtih-integration:v3 .
#docker run -d -p 3000:3000 max476/app-wtih-integration:v2
docker push max476/app-wtih-integration:v3
```

### Creating CD part 2 Job

- Per configuriaton
- Execute shell commands per below
```
docker pull max476/app-wtih-integration:v3
docker run -d -p 3000:3000 max476/app-wtih-integration:v3
```
- Webhook to auto send email
	- This is done on DockerHub, use a googlescript with the below script
	- Add this to the webhook section on your repositry
```
function doGet(e){
  return HtmlService.createHtmlOutput("request received");
}

function doPost(e) {
    var emailAddress = 'MPalmer@spartaglobal.com'
    var message = 'This is an email to show that Max has pushed a new image to his DockerHub'
    var subject = 'Sending Emails From Google Scripts';
    MailApp.sendEmail(emailAddress, subject, message);
    return HtmlService.createHtmlOutput()("post request received");
  
}
```