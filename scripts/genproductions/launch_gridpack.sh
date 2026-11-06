#!/bin/bash
# Usage: bash launch_gridpack.sh 
# (it can be long - use tmux)

BASE=$(pwd)
GENDIR=$BASE/genproductions_scripts/bin/MadGraph5_aMCatNLO
CARDBASE=$BASE/tracking-ALPs/model/genproduction_cards
FRAGBASE=$BASE/sample_factory/data/fragments/VBF_ALP_diphoton_10GeV.py
FRAGDIR=$BASE/sample_factory/data/fragments


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

echo "CARDDIR=$MASSDIR/Cards"
echo "PROCESS=$PROCESS_NAME"
cd $GENDIR
$GENDIR/gridpack_generation.sh ${PROCESS_NAME} $MASSDIR/Cards 

mv $GENDIR/${PROCESS_NAME}_el9_amd64_gcc11_CMSSW_13_2_9_tarball.tar.xz $MASSDIR/
GRIDPACK=$MASSDIR/${PROCESS_NAME}_el9_amd64_gcc11_CMSSW_13_2_9_tarball.tar.xz

sed "s|args = cms.vstring('.*')|args = cms.vstring('${GRIDPACK}')|" \
    $FRAGBASE > $FRAGDIR/${PROCESS_NAME}_fragment.py
echo "Fragment created: $FRAGDIR/${PROCESS_NAME}_fragment.py"

