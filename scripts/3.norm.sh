SUBMIT=1
PG=1

TIME=05:00:00
PARTITION=himem
EXPDIR=$HOME/projects/wnut-2017-pos-norm
DATA_FOLDER=$EXPDIR/data
BILSTM=tools/bilstm-aux/src/bilty.py
PYTHON=python

## output files
OUTDIRMODEL=$EXPDIR/models
OUTDIRPRED=$EXPDIR/predictions/3.norm
LOG=$EXPDIR/runs

mkdir -p $OUTDIRMODEL
mkdir -p $OUTDIRPRED
mkdir -p $LOG

#SEED=1512141834
SEED=151214183
ITER=10
HLAYER=1
IN_DIM=100
C_IN_DIM=256
SIGMA=0.2
TRAINER=adam
INITIALIZER=constant
DYNETMEM=5000


TRAIN=(train_pos.noUserWWW train_pos.norm.noUserWWW train_pos.norm.comb.noUserWWW)
TEST=(1.dev.raw.noUserWWW 1.dev.normUnk.noUserWWW 1.dev.normAll.noUserWWW 1.dev.gold.noUserWWW 1.dev.normGoldErr.noUserWWW)

for RUN in 1 2 3 4 5
do

    JOBNAME=norm.run$RUN

    echo "#!/bin/bash"  > $$tmp
    if [ "$PG" -eq "1" ] ; then
	echo "#SBATCH --ntasks=1 --time=$TIME --job-name=$JOBNAME --partition=$PARTITION --mem=12GB" >> $$tmp
	echo "#SBATCH --output=runs/${JOBNAME}.out" >> $$tmp
	echo "#SBATCH --error=runs/${JOBNAME}.out2" >> $$tmp
	echo "module load CMake/3.6.1-GCCcore-4.9.3" >> $$tmp
	echo "module load Boost/1.60.0-foss-2016a" >> $$tmp
    fi 



    for TRAIN_FILE in ${TRAIN[@]};
    do
	echo "$PYTHON $BILSTM --dynet-seed $SEED$RUN --dynet-mem $DYNETMEM --train $DATA_FOLDER/$TRAIN_FILE --save $OUTDIRMODEL/$TRAIN_FILE.run$RUN --pred_layer $HLAYER --iters $ITER --in_dim $IN_DIM --c_in_dim $C_IN_DIM --h_layers $HLAYER --sigma $SIGMA --trainer $TRAINER " >> $$tmp
	for TEST_FILE in ${TEST[@]};
	do
            echo "$PYTHON $BILSTM --dynet-seed $SEED --dynet-mem $DYNETMEM --model $OUTDIRMODEL/$TRAIN_FILE.run$RUN.model --test $DATA_FOLDER/$TEST_FILE --pred_layer $HLAYER --output $OUTDIRPRED/$TRAIN_FILE.$TEST_FILE.run$RUN " >> $$tmp
	done
	echo "" >> $$tmp
    done

    cat $$tmp
    if [ "$SUBMIT" -eq "1" ] ; then
	echo "submit"
	sbatch $$tmp
    fi
    rm $$tmp

done
