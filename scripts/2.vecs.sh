SUBMIT=1
PG=1

TIME=7:00:00
#PARTITION=nodes
PARTITION=himem
EXPDIR=$HOME/projects/wnut-2017-pos-norm
DATA_FOLDER=$EXPDIR/data
BILSTM=tools/bilstm-aux/src/bilty.py
PYTHON=python

## output files
OUTDIRMODEL=$EXPDIR/models
if [ "$PG" -eq "1" ] ; then
    OUTDIRMODEL=/data/p252438/models
fi
OUTDIRPRED=$EXPDIR/predictions/2.vecs
LOG=$EXPDIR/runs

mkdir -p $OUTDIRMODEL
mkdir -p $OUTDIRPRED
mkdir -p $LOG

#SEED=1512141834
SEED=151214183
ITER=10
HLAYER=1
C_IN_DIM=256
SIGMA=0.2
TRAINER=adam
INITIALIZER=constant
#DYNETMEM=25000
DYNETMEM=40000

EMBEDDIR=/home/p270396/coolVecs
if [ "$PG" -eq "1" ] ; then
    EMBEDDIR='/data/p270396/coolVecs'
fi

EMBEDS=('skip.100.w5 sskip.100.w5 skip.100.w1')
#EMBEDS=('skip.100.w1 skip.100.w5 sskip.100.w5 sskip.100.w1 skip.100.w1.small sskip.100.w1.small')
#EMBEDS=('sskip.100.w1')


TRAIN=train_pos.noUserWWW
TEST=(1.dev.raw.noUserWWW 1.dev.normUnk.noUserWWW 1.dev.normAll.noUserWWW 1.dev.gold.noUserWWW)

for RUN in 1 2 3 4 5
do
    for EMBED in ${EMBEDS[@]};
    do
	JOBNAME=vecs.$EMBED.run$RUN
	
	echo "#!/bin/bash"  > $$tmp
	if [ "$PG" -eq "1" ] ; then
	    echo "#SBATCH --ntasks=1 --time=$TIME --job-name=$JOBNAME --partition=$PARTITION --mem=80GB" >> $$tmp
	    echo "#SBATCH --output=runs/${JOBNAME}.out" >> $$tmp
	    echo "#SBATCH --error=runs/${JOBNAME}.out2" >> $$tmp
#	    echo "module load CMake/3.6.1-GCCcore-4.9.3" >> $$tmp
	    echo "module load CMake" >> $$tmp
	    echo "module load Boost/1.60.0-foss-2016a" >> $$tmp
	fi 

	
	echo "$PYTHON $BILSTM --dynet-seed $SEED$RUN --dynet-mem $DYNETMEM --train $DATA_FOLDER/$TRAIN --save $OUTDIRMODEL/$EMBED.run$RUN --pred_layer $HLAYER --iters $ITER --c_in_dim $C_IN_DIM --in_dim 100 --h_layers $HLAYER --sigma $SIGMA --trainer $TRAINER --embeds $EMBEDDIR/$EMBED --initializer $INITIALIZER " >> $$tmp
	for TEST_FILE in ${TEST[@]};
	do
            echo "$PYTHON $BILSTM --dynet-seed $SEED$RUN --dynet-mem $DYNETMEM --model $OUTDIRMODEL/$EMBED.run$RUN.model --test $DATA_FOLDER/$TEST_FILE --pred_layer $HLAYER --initializer $INITIALIZER --output $OUTDIRPRED/$EMBED.$TEST_FILE.run$RUN " >> $$tmp
	done
	echo "" >> $$tmp
	
	
	cat $$tmp
	if [ "$SUBMIT" -eq "1" ] ; then
	    echo "submit"
	    sbatch $$tmp
	fi
	rm $$tmp
    done
done
