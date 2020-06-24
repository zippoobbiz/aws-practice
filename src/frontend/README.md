# company news simple fronted page
supported operations:
1. Create news with title
2. Update news title
3. View news id
4. Delete news

## Dev

### Build
```bash
docker build -t sample:dev .
```

## Run

### run with hot reload
```bash
docker run \
    -it \
    --rm \
    -v ${PWD}:/app \
    -v /app/node_modules \
    -p 3001:3000 \
    -e REACT_APP_BACKEND_URL=foo \
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
    --env REACT_APP_BACKEND_URL=foo
    -e CHOKIDAR_USEPOLLING=true \
    sample:dev
```
## Prod

### Build
```bash
docker build --build-arg REACT_APP_BACKEND_URL=foo -f Dockerfile.prod -t sample:prod .
```

### Run
```bash
docker run -it --rm -p 1337:80 sample:prod
```

## AWS ECR push

### Login
```bash
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

### Tag
```bash
docker tag sample:prod $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/frontend
```

### Push
```bash
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/frontend
```