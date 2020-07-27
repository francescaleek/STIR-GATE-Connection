## #! /bin/sh

## AUTHOR: Robert Twyman
## AUTHOR: Kris Thielemans
## Copyright (C) 2020 University College London
## Licensed under the Apache License, Version 2.0

## This script estimates the background randoms from the unlisted (Trues+Randoms+Scattered) coincidences and the measured Delayed coincidences.

## PARAMETERS

if [ $# != 3 ]; then
	echo "Usage: EstimateGATESTIRNorm.sh OutputFilename MeasuredData (Coincidences) DelayedData"
	exit 1
fi 

OutputFilename=$1 
MeasuredData=$2  ## Trues+Randoms+Scattered Coincidences Sinogram
DelayedData=$3 ## Delayed Coincidences Sinogram

factors=randoms_factors

## ML Normfactors loop numbers (Hardcoded for now)
outer_iters=5
eff_iters=6

## find ML normfactors
echo "find_ML_normfactors3D"
find_ML_normfactors3D $factors $MeasuredData $DelayedData $outer_iters $eff_iters


## create ones sino
echo "stir_math"
stir_math -s --including-first --times-scalar 0 --add-scalar 1 ones.hs $DelayedData


## mutiply ones with the norm factors to get a sino
echo "apply_normfactors3D"
apply_normfactors3D ${OutputFilename} $factors $DelayedData 1 $outer_iters $eff_iters

