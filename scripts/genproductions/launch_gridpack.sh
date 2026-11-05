#!/bin/bash
# Usage: bash launch_gridpack.sh <BASE>
# (it can be long - use tmux)

BASE=$1
GENDIR=$BASE/genproductions_scripts/bin/MadGraph5_aMCatNLO
CARDBASE=$BASE/tracking-ALPs/model/genproduction_cards

MASS=10.0   

MASS_TAG=$(echo $MASS | tr '.' 'p')
PROCESS_NAME=VBF_ALP_${MASS_TAG}GeV
MASSDIR=$BASE/gridpacks/mass_${MASS}
mkdir -p $MASSDIR/Cards

cp $CARDBASE/VBF_ALP_run_card.dat    $MASSDIR/Cards/${PROCESS_NAME}_run_card.dat
cp $CARDBASE/VBF_ALP_extramodels.dat $MASSDIR/Cards/${PROCESS_NAME}_extramodels.dat
cp $BASE/ALP-h_UFO.tar.gz            $MASSDIR/Cards/

sed "s/^\( *36 *\)[^ ]*/\1${MASS}/" \
    $CARDBASE/VBF_ALP_param_card.dat > $MASSDIR/Cards/${PROCESS_NAME}_param_card.dat

sed "s/output VBF_ALP/output ${PROCESS_NAME}/" \
    $CARDBASE/VBF_ALP_proc_card.dat > $MASSDIR/Cards/${PROCESS_NAME}_proc_card.dat

cd $GENDIR
$GENDIR/gridpack_generation.sh ${PROCESS_NAME} $MASSDIR/Cards 
