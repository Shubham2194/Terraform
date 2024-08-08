
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

Now open the same pipeline in azure devops and add the variables and 
