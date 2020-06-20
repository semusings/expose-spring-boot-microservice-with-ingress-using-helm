DIR="$(pwd)"/.cache
mkdir -p "$DIR"

FILE=$DIR/linux-amd64/helm

if test -f "$FILE"; then
  echo "$FILE exist"
else
  echo "$FILE does not exist"
  curl -fsSL -o "$DIR"/helm.tar.gz https://get.helm.sh/helm-v3.2.3-linux-amd64.tar.gz
  cd "$DIR" && tar -xzvf helm.tar.gz && rm -rf helm.tar.gz && cd ..
fi

# shellcheck disable=SC2139
alias helm="$DIR/linux-amd64/helm"

printf '\n'
helm version
printf '\n'

DEPLOYMENT="example-deployment"

CHART_DIR="src/microservice"

option="${1}"
case ${option} in
   --deploy)
        helm upgrade \
        --install -f $CHART_DIR/values.yaml \
        --set ingress.enabled=true \
        $DEPLOYMENT $CHART_DIR --force
      ;;
   --addons)
      minikube addons enable ingress
      minikube addons enable ingress-dns
      ;;
   --delete)
      helm delete $DEPLOYMENT
      ;;
    --resolvconf)
      minikube ip
      sudo apt install resolvconf
      sudo gedit /etc/resolvconf/resolv.conf.d/head
      nameserver 172.17.0.2
      sudo resolvconf -u
      # Each restart you need to add nameserver
      ;;
    --host)
      minikube ip
      sudo gedit /etc/hosts
      # Each restart you need to add nameserver
      ;;
   *)
      echo "`basename ${0}`:usage: [--deploy] | [--addons] | [--delete]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
