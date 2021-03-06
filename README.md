# Docker Jenkins Task

## Dependencies

- Docker installed
	- For more instructions see my previous repositry

```https://github.com/Lycurgus1/Docker```

- Git bash installed

```https://gitforwindows.org/```

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

![Jenkins_Plugin_Setup](images/Jenkins_Plugin.PNG)

- You will need plugins for GitHub and Docker.
	- There is multiple plugins for these

![Jenkins_Plugins](images/jenkins_plugins.PNG)

### Create CI Job

**To trigger upon push**

	- Make sure the Github Plugin is installed

**Configuration**

- General per below

![image](images/CI_General.PNG)

- Source Code Management and Build Triggers per below

![image](images/CI_SCM.PNG)

- Build settings per below

![image](images/CI_Build.PNG)

- Post Build Actions per below

![image](images/CI_PostBuild.PNG)

**Other Steps**

- Install npm and nodejs on OS
- Edit package.json file test line

```node ./node_modules/mocha/bin/_mocha```

- Killing process running. If port 3000 is in use, go into task task manager and end the node.js process

### Create CD Job

**Configuration**

- General per below

![image](images/CD_General.PNG)

- Source Code Management and Build Triggers per below

![image](images/CD_SCM.PNG)

- Build Settings per below

![image](images/CD_Build.PNG)

- Shell commands
```
docker build -t max476/app-wtih-integration:v3 .
#docker run -d -p 3000:3000 max476/app-wtih-integration:v2
docker push max476/app-wtih-integration:v3
```

### Creating CD part 2 Job

**Configuration**

- General per below

![image](images/CD2_General.PNG)

- Source Code Management and Build Triggers per below

![image](images/CD2_SCM.PNG)

- Build Settings per below

![image](images/CD2_Build.PNG)

- Shell Commands
```
docker pull max476/app-wtih-integration:v3
docker run -d -p 3000:3000 max476/app-wtih-integration:v3
```
**Other Steps**

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

## Task

1. Previous Job setup of CI from GitHub to Jenkins
2. Jenkins will test code(previous tests) and if succesful trigger build on Docker
3. Jenkins will trigger image to be pushed to dockerhub
4. Notification sent when the image is pushed to dockerhub
	- (email sent to Shahrukh and yourself/group)
	- Uses webhook on Dockerhub to trigger email being sent?
