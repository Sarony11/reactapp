# using the node:alpine image, I name this stage as builder because I want to use it later.
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json ./
COPY package-lock.json ./
RUN npm install
COPY ./ ./
# This builds the app creating everythig in /app/builder - /app because the workdir and /builder becuase the npm run build command
RUN npm run build

# In this new container, I choose the nginx for serving the webapp
FROM nginx:latest

# And copy the builded app files from the previous container to the new container
# /app/build -> where the previous build was done
# /usr/share/nginx/html -> where I want to put it in the new container
COPY --from=builder /app/build /usr/share/nginx/html