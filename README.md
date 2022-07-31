# Simple node js app 
For testing ci/cd pipeline 

### Infrastructure [Repo ](https://github.com/mohamedanwer006/jenkins-gke-ci-cd)

---

## Testing app local

#### Build image
```
docker build -t simple-node-app:latest .
```

#### Run image
```
docker run  -d -p 3000:3000 simple-node-app
```

>Access the app at http://localhost:3000

### Response:

![test](assets/test.png)