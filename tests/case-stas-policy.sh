#!/bin/bash

NAMESPACE=""

die () {
	echo "RUN FAILURE"
	echo $1
	exit $2
}

kubectl_do () {
	cmd=(kubectl)
	if [[ $NAMESPACE ]]; then
		cmd+=(-n $NAMESPACE)
	fi

	cmd+=($@)
	${cmd[@]}
}

test_prestart () {
	kubectl_do get deployment nginx > /dev/null && die "Target deployment already exists" 1
	kubectl_do get svc expose > /dev/null && die "Target service already exists" 1
}

test_init () {
	podip=
	hostip=
	kubectl_do run nginx --image=nginx >/dev/null
	for t in $(seq 1 10); do 
		kuberes=$(kubectl_do get pod -l run=nginx -o json)
		filtered=$(jq -r '.items | length, .[].status.podIP, .[].status.hostIP // empty' <<<$kuberes)
		read -r count podip hostip <<<$filtered
		
		if (( count > 1 )); then
			die "More then one target pod" 1
		fi

		if (( count < 1 )); then
			sleep 1
			continue
		fi

		if ! [[ $podip ]]; then
			sleep 1
			continue
		fi

		if [[ $podip == "null" ]]; then
			sleep 1
			continue
		fi	

		break
	done

	if ! [[ $podip ]]; then
		cleanup
		die "Failed to start target pod" 1
	fi

	serviceip=
	kubectl_do expose deployment nginx --port=80 >/dev/null
	for t in $(seq 1 10); do 
		kuberes=$(kubectl get svc nginx -o json)
		serviceip=$(jq -r '.spec.clusterIP // empty' <<<$kuberes)

		if ! [[ $serviceip ]]; then
			sleep 1
			continue
		fi

		break
	done

	if ! [[ $serviceip ]]; then
		cleanup
		die "Failed to create service"
	fi

	echo $podip $hostip $serviceip
}

cleanup () {
	kubectl_do delete deployment nginx > /dev/null
	kubectl_do delete service nginx > /dev/null
	sleep 5
}
		
do_test () {
	podip=$1
	hostip=$2
	serviceip=$3
	echo "TEST host to pod $hostip -> $podip"
	curl -s $podip --connect-timeout 5
	if (( $? != 0 )); then
		cleanup
		die "TEST FAIL: host to pod" 1
	fi


	echo "TEST host to service $hostip -> $serviceip"
	curl -s $serviceip --connect-timeout 5
	if (( $? != 0 )); then
		cleanup
		die "TEST FAIL: host to service" 1
	fi

	echo "TEST pod to pod -> $podip"
	(kubectl_do run -i -t busybox --image=busybox --restart=Never --rm -- ping -q -c 3 $podip >/dev/null) 2> /dev/null
	if (( $? != 0 )); then
		cleanup
		die "TEST FAIL: pod to pod" 1
	fi

}

test_prestart 2> /dev/null
read -r podip hostip serviceip <<<$(test_init)
echo "TEST RUN: IP=$podip, node=$hostip, service=$serviceip"

do_test $podip $hostip $serviceip
cleanup
echo "TEST RUN SUCCESS"
