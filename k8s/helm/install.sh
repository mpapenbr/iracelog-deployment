kubectl create namespace iracelog
helm dependency build ./iracelog-app 
helm install iracelogapp ./iracelog-app --namespace iracelog