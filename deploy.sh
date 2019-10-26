# Build images
docker build -t jonsom/multi-client:latest -t jonsom/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jonsom/multi-server:latest -t jonsom/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jonsom/multi-worker:latest -t jonsom/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push latest images to docker hub
docker push jonsom/multi-client:latest
docker push jonsom/multi-server:latest
docker push jonsom/multi-worker:latest

# Push SHA-ed images to docker hub
docker push jonsom/multi-client:$SHA
docker push jonsom/multi-server:$SHA
docker push jonsom/multi-worker:$SHA

# Apply kubernetes config
kubectl apply -f k8s

# Imperatively set latest images on each deployment
kubectl set image deployments/server-deployment server=jonsom/multi-server:$SHA
kubectl set image deployments/client-deployment client=jonsom/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jonsom/multi-worker:$SHA