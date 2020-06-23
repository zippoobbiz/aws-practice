# company news simple fronted page
supported operations:
1. Create news with title
2. Update news title
3. View news id
4. Delete news


## Docker build

### Dev build
```bash
docker build -t sample:dev .
```

### Prod build
```bash
docker build -f Dockerfile.prod -t sample:prod .
```

## Docker run

### dev run with hot reload
```bash
docker run \
    -it \
    --rm \
    -v ${PWD}:/app \
    -v /app/node_modules \
    -p 3001:3000 \
    -e CHOKIDAR_USEPOLLING=true \
    sample:dev
```

### run in background
```bash
docker run \
    -itd \
    --rm \
    -v ${PWD}:/app \
    -v /app/node_modules \
    -p 3001:3000 \
    -e CHOKIDAR_USEPOLLING=true \
    sample:dev
```

### Prod run
```bash
docker run -it --rm -p 1337:80 sample:prod
```

## AWS ECR push

### Docker login
```bash
aws ecr get-login-password --region "ap-southeast-2" | docker login --username AWS --password-stdin <account_id>.dkr.ecr.ap-southeast-2.amazonaws.com
```

### tag
```bash
docker tag <image> <account_id>.dkr.ecr.ap-southeast-2.amazonaws.com/frontend
```

### push
```bash
docker push <account_id>.dkr.ecr.ap-southeast-2.amazonaws.com/frontend
```