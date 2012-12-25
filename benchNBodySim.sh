#!/bin/bash

times=5
iter=10
randBodies=1000
seed=123
echo "Running $times nBodySim with this values :"
echo "./nBodySim -n$iter --rand $randBodies --seed $seed"

media=0
for i in {1..$times}
do
  export valu=`./nBodySim -n$iter --rand $randBodies --seed $seed | grep Total | tail -n1| cut -d ' ' -f4`
  let media+=valu
done

let media/=times
echo "Mean time = $media [ms]"
