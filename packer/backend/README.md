# Packer build backend ami

1. Build Java project ```mvn clean install```
2. put the confiled file to `/packer/backend/provisioners/ansible/files`, change the file name to ROOT.war

    ```mv src/backend/target/companynews*.war packer/backend/provisioners/ansible/files/ROOT.war```
3. run command ```packer build -machine-readable packer-build.json | tee build_artifact.txt```