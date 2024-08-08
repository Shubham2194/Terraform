
**Azure devOps Work-around
 - Target Enviroment : EKS
 - END to END CI/CD
 - Helm Charts**

Step 1: 

Go to Your azure devOps Portal and create a new Project:

   ![image](https://github.com/user-attachments/assets/9c859a3e-e215-427e-8aa3-05dd2c02c20e)


Step 2:
Find the pipelines > Pipelines in the left pannel:

![image](https://github.com/user-attachments/assets/f7986fbf-c707-4554-b041-9971cebb7be3)

Step 3: 
Click on New piepline and choose the Github (as our code is present in Github )

![image](https://github.com/user-attachments/assets/2843cb41-d8b1-4d29-aaa6-85e42b7dd420)


![image](https://github.com/user-attachments/assets/e67546a9-427f-44cd-88c9-3d6ca540aac2)


Step 4: 
Select the Repo for which you want to setup your piepline and select the Stater pipeline  

![image](https://github.com/user-attachments/assets/d3cdd8f6-3b85-425f-be3c-17fb25ecb554)


Step 5:

 ![image](https://github.com/user-attachments/assets/3cccf2be-a093-4a40-899f-c0e2f5999bd1)

 We can see the Hello world piepline , please save and run , this will commit one file in the gihub repo with the name , azure-pipeline.yml


Step 6:


![image](https://github.com/user-attachments/assets/4cf23f87-3b31-414e-af2a-d0e7368e2e08)


Step 7:

Now open the same pipeline in azure devops and add the variables (AWS_ACCESS_KEY_ID , AWS_SECRET_ACCESS_KEY and awsRegion to Configure AWS )

![image](https://github.com/user-attachments/assets/f16b5480-e5e4-414a-82f3-009637ef7d05)


![image](https://github.com/user-attachments/assets/c2a4ea36-9f21-4b97-b6d5-36d823b9f45d)


Step 8:
Start with the Variables and Steps section (use below code)

trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

variables:
  imageRepository: 'AWS_account_id.dkr.ecr.ap-south-1.amazonaws.com/xyz'
  registry: 'xyz' # this should ECR registry name
  imageTag: 'api-$(Build.BuildId)'
  awsRegion: 'ap-south-1'
  eksClusterName: 'my-cluster'  # this is EKS cluster name
  serviceName: 'api'
  awsAccountId: 'account_id'
  namespace: 'backend' # namespace where you want to deploy this helm chart

steps:
- script: |
    echo "Configuring AWS CLI"
    aws configure set aws_access_key_id $(AWS_ACCESS_KEY_ID)
    aws configure set aws_secret_access_key $(AWS_SECRET_ACCESS_KEY)
    aws configure set default.region $(awsRegion)
    aws s3 ls
    echo "AWS CLI is configured. Current version:"
    aws --version
  displayName: 'Install dependencies and configure environment'

*** SAVE it and RUN the Pipeline ***


![image](https://github.com/user-attachments/assets/ef1f875b-d0d9-4fc3-b8e5-0be1da6bb9e8)

![image](https://github.com/user-attachments/assets/5e58077b-6d04-460a-8fcb-628c7e8ce3a4)


Step 9:
Now add the another script to Build , tag and Puch Docker image to ECR

- script: |
    echo "Build and push Docker image"
    docker build -t $(registry) .
    aws ecr get-login-password --region $(awsRegion) | docker login --username AWS --password-stdin $(awsAccountId).dkr.ecr.$(awsRegion).amazonaws.com
    docker tag $(registry):latest $(imageRepository):$(imageTag)
    docker push $(imageRepository):$(imageTag)
  displayName: 'Build and push Docker image'


Step 10:
(prerequisites : Repo should have Chart available)
Now Add the CD step where we Fetch the Kubeconfig and deploy helm chart with the new tag

# CD Steps

- script: |
    aws eks update-kubeconfig --name $(eksClusterName) --region $(awsRegion)
    helm upgrade --install $(serviceName) chart/$(serviceName) --namespace $(namespace) --set image.repository=$(imageRepository) --set image.tag=$(imageTag)
  displayName: 'Deploy to EKS'
  env:
    AWS_ACCESS_KEY_ID: $(AWS_ACCESS_KEY_ID)
    AWS_SECRET_ACCESS_KEY: $(AWS_SECRET_ACCESS_KEY)
    AWS_REGION: $(awsRegion)

Step 11:
So the whole pipeline code look like this - 

azure-pipelines.yml

trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

variables:
  imageRepository: 'AWS_account_id.dkr.ecr.ap-south-1.amazonaws.com/xyz'
  registry: 'xyz' # this should ECR registry name
  imageTag: 'api-$(Build.BuildId)'
  awsRegion: 'ap-south-1'
  eksClusterName: 'my-cluster'  # this is EKS cluster name
  serviceName: 'api'
  awsAccountId: 'account_id'
  namespace: 'backend' # namespace where you want to deploy this helm chart

steps:
- script: |
    echo "Configuring AWS CLI"
    aws configure set aws_access_key_id $(AWS_ACCESS_KEY_ID)
    aws configure set aws_secret_access_key $(AWS_SECRET_ACCESS_KEY)
    aws configure set default.region $(awsRegion)
    aws s3 ls
    echo "AWS CLI is configured. Current version:"
    aws --version
  displayName: 'Install dependencies and configure environment'
  
- script: |
    echo "Build and push Docker image"
    docker build -t $(registry) .
    aws ecr get-login-password --region $(awsRegion) | docker login --username AWS --password-stdin $(awsAccountId).dkr.ecr.$(awsRegion).amazonaws.com
    docker tag $(registry):latest $(imageRepository):$(imageTag)
    docker push $(imageRepository):$(imageTag)
  displayName: 'Build and push Docker image'  

# CD Steps
- script: |
    aws eks update-kubeconfig --name $(eksClusterName) --region $(awsRegion)
    helm upgrade --install $(serviceName) chart/$(serviceName) --namespace $(namespace) --set image.repository=$(imageRepository) --set image.tag=$(imageTag)
  displayName: 'Deploy to EKS'
  env:
    AWS_ACCESS_KEY_ID: $(AWS_ACCESS_KEY_ID)
    AWS_SECRET_ACCESS_KEY: $(AWS_SECRET_ACCESS_KEY)
    AWS_REGION: $(awsRegion)
*** NOW save and RUN ***  
and check the output 


![image](https://github.com/user-attachments/assets/b07627d9-7919-4223-917f-9233beabb9ce)


We have Successfully deployed our HELM chart in the EKS env With azure DevOps !!

