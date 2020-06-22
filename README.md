# This is a simple aws practice

### deploy apache as frontend and tomcat as backend server using autoscaling group in in different AZ
### currently the backend part is ready, and support rolling update using cloudformation

### the code is built manunally and the compiled package is loaded to ami via packer. CI/CD implementation is undergoing, described in the diagram below.

![Alt text](diagram.png?raw=true "Title")