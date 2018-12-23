# wnut-2017-pos-norm

Repository for the experiments of the paper: *To Normalize, or Not to
Normalize: The Impact of Normalization on Part-of-Speech Tagging*,
WNUT 2017, EMNLP 2017 workshop.


### Reference

If you make use of the contents of this repository, we appreciate citing the following paper:

    @InProceedings{vandergoot:ea:2017:WNUT,
      author    = {van der Goot, Rob and Plank, Barbara and Nissim, Malvina},
      title     = {{To Normalize, or Not to Normalize: The Impact of Normalization on Part-of-Speech Tagging}},
      booktitle = {Proceedings of WNUT 2017},
      month     = {September},
      year      = {2017},
      address   = {Copenhagen, Denmark},
      publisher = {Association for Computational Linguistics},
    }


### Setup Details

`
DyNet (54bf3fa04f55f0730a9a21b5708e94dc153394da)
Boost/1.60.0-foss-2016a
python --version
Python 3.5.2 :: Anaconda 2.5.0 (64-bit)
`

### Data adaptations
We reversed some of the data pre-processing from the data as released by Chen Li (http://www.hlt.utdallas.edu/~chenli/normalization_pos/)

diffs in owoputi Testset1: 
* first removed empty words with G tag (grep JUNKIE to find the sentence)
* reconstructed question marks using filter.py

diffs in lexnorm Testset2"
* dots are replaced with 0s in the lexnorm data?
* 1 vs 1.2 vs chenli version 

### Reproducability
It is rather difficult to reproduce our results with this repository, an updated version is available at <https://bitbucket.org/robvanderg/chapter6>

