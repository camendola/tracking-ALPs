#!/bin/bash
# Usage: bash launch_gridpack.sh 
# (it can be long - use tmux)

BASE=$(pwd)
GENDIR=$BASE/genproductions_scripts/bin/MadGraph5_aMCatNLO
CARDBASE=$BASE/tracking-ALPs/model/genproduction_cards
FRAGBASE=$BASE/sample_factory/data/fragments/VBF_ALP_diphoton_10GeV.py
FRAGDIR=$BASE/sample_factory/data/fragments



MASS=20.0                      
SCRAM_ARCH=el8_amd64_gcc12    
CMSSW_VERSION=CMSSW_14_0_21_patch4  

MASS_TAG=$(echo $MASS | tr '.' 'p')
PROCESS_NAME=VBF_ALP_${MASS_TAG}GeV
MASSDIR=$BASE/gridpacks/mass_${MASS}





mkdir -p $MASSDIR/Cards

cp $CARDBASE/VBF_ALP_run_card.dat    $MASSDIR/Cards/${PROCESS_NAME}_run_card.dat
cp $CARDBASE/VBF_ALP_extramodels.dat $MASSDIR/Cards/${PROCESS_NAME}_extramodels.dat
cp $BASE/ALP-h_UFO.tar.gz            $MASSDIR/Cards/

sed "s/^\\( *36 *\\)[^ ]*/\\1$(printf '%.6e' $MASS)/" \
    $CARDBASE/VBF_ALP_param_card.dat > $MASSDIR/Cards/${PROCESS_NAME}_param_card.dat

sed "s/output VBF_ALP/output ${PROCESS_NAME}/" \
    $CARDBASE/VBF_ALP_proc_card.dat > $MASSDIR/Cards/${PROCESS_NAME}_proc_card.dat

cp $BASE/ALP-h_UFO.tar.gz $GENDIR/

cd $GENDIR
echo $GENDIR
$GENDIR/gridpack_generation.sh ${PROCESS_NAME} $MASSDIR/Cards $MASSDIR local ALL ${SCRAM_ARCH} ${CMSSW_VERSION}

# generate fragment
GRIDPACK=$MASSDIR/${PROCESS_NAME}_${SCRAM_ARCH}_${CMSSW_VERSION}_tarball.tar.xz
sed "s|args = cms.vstring('.*')|args = cms.vstring('${GRIDPACK}')|" \
    $FRAGBASE > $FRAGDIR/${PROCESS_NAME}_fragment.py
echo "Fragment created: $FRAGDIR/${PROCESS_NAME}_fragment.py"
