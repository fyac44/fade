# FADE - Simulation framework for auditory discrimination experiments
This software can be used to model simple acoustical recognition, detection, and discrimination experiments.

Copyright (C) 2014-2018 Marc René Schädler
E-mail: marc.r.schaedler@uni-oldenburg.de

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
MODIFIED BY:
2019 - Franklin Alvarez
E-mail: fyac44@gmail.com

The main purpose of the modifications done to the original FADE, is adding the posibillities to use Cochlear Implant Coding Strategies, and to extract features from ".mat" files, which will contain the electrodogram information of a cochlear implant.

Because the Coding Strategy is not free, and the auditory model to extract features from ".mat" doesn't belong to me, they cannot be found in this repository.

Finally, this repository is part of my Master Thesis work, entitled "A Computational Model for Speech Reception and Spectral Modulation Threshold Performance of Cochlear Implants Users" which is in development, but, hopefully, will be presented this year.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

The scripts provided in this software package can be used to perform the experiments described in [1] and [2], where the approach is explained in more detail.
This reference implementation serves as starting point for those who want to reproduce the results or tinker around with it.
In the current state, FADE is far from fully documented.
We will provide documentation on demand.
If you are intested in a specific piece of code, please ask.
To get started, read this file carefully and look for the tutorials.

Please note that FADE expects recordings to be 32-bit signed-integer wav files that are calibrated such that an RMS of 1 means 130 dB SPL.
The speech material for the German Matrix sentence test is not free.
You can ask HörTech [3] for a license.
If you can't get or afford a license, please ask the author.


## Installation
Get FADE running on your machine


### Linux
FADE was developed and tested in an Ubuntu Linux environment.
Install Ubuntu Linux on the machine that you want to run FADE.
Some additional packages are required which can be installed using the following command in a terminal:

`sudo apt-get install git build-essential octave octave-signal octave-general octave-control liboctave-dev gawk`


### Hidden Markov Toolkit
FADE requires a working installation of the Hidden Markov Toolkit (HTK; http://htk.eng.cam.ac.uk/), where the HTKTools must be in your PATH.
This basically means, if you can run `HVite` from the terminal, it should be fine.


### FADE
To install FADE you can simply clone the FADE repository to "~/fade" using the following command:

`git clone https://github.com/m-r-s/fade ~/fade`

At a later point in time you might want to update to the most recent version.
Enter the "~/fade" directory and use git to pull the changes:

`cd ~/fade && git pull`

For your convenience, you can add the `~/fade` and `~/fade/examples` directories to your PATH.
Therefore, add the following line to your "~/.bashrc":

`export PATH=$PATH:~/fade:~/fade/examples`

In newly started terminals you should now be able to used the `fade` command.


## Examples/Tutorials
See folder `examples` for example scripts and folder `tutorials` for tutorials.


## Usage
`fade <project> <action> [argument1] [argument2] [argument3] ...`

`<project>` needs to be a valid project path and will be created automatically
if it does not exist.

`<action>` defines a set of scripts which will be run inside the project
and perform the desired action.
The action scripts reside in the *fade.d/* subdirectory.

The simplest call to fade, which generates a project and shows some
information about it, is: `fade <project> info`


### Actions
Almost all arguments are optional.
The default values are stored in the corresponding `fade.d/<action>.cfg` file.
The data output and configuration files are stored in the corresponding
`./<action>/` and `./config/<action>/` project subdirectories, respectively.

The configuration files (in `./config/<action>/`) are overwritten
if arguments are provided. Missing configuration files are generated using
the default settings. The corresponding data target directories (`./<action>/`)
are always deleted before the action is performed.

The following actions are available:


#### Set up a corpus with matrix sentences
`fade <project> corpus-matrix [TRAIN_SAMPELS] [TEST_SAMPELS] [SNRS] [SIL] [TRAIN_SEED] [TEST_SEED]`

Sets up a corpus from files in the speech and noise subdirectories.
Copies corpus-specific configuration files.

Some relevant paths:

- `fade.d/corpus-matrix.d/format.cfg` Definition of training an testing conditions
- `source` The folder where the speech and noise recordings go


#### Set up a corpus with psychoacoustic stimuli
`fade <project> corpus-stimulus [TRAIN_SAMPELS] [TEST_SAMPELS] [TRAIN_SEED] [TEST_SEED]`

Sets up a corpus with psychoacoustic stimuli.
Copies corpus-specific configuration files.

Some relevant paths:

- `fade.d/corpus-stimulus.d/matlab/corpus/generate.m` Stimulus generation script
- `fade.d/corpus-stimulus.d/format.cfg` Definition of training an testing conditions


#### Generate the training and test data
`fade <project> corpus-generate`

Generates the training and test data.

Some relevant paths:

- `./config/corpus/generate` Generation script
- `./config/corpus/generate.cfg` Generation config file


#### Process the corpus data (optional)
`fade <project> processing [PROCESSINGNAME] [PROCESSING ARGUMENTS]`

Processes the corpus data, e.g., with a hearing aid algorithm using openMHA.

Some relevant paths:
- `fade.d/processing.d/`    Some default signal processing setups (including openMHA)
- `./config/processing/scripts/batch_process` Script used for batch processing
- `./corpus`                Source directory
- `./processing`            Target directory


#### Set up the experimental conditions (train/test)
`fade <project> corpus-format`

Generates training and test conditions defined in the corpus structure file.

Some relevant paths:

- `./config/corpus/format.cfg` Definition of training an testing conditions


#### Extract features
`fade <project> features [FEATURENAME] [MATLAB ARGUMENTS]`
`fade <project> features [SCRIPTDIR] [MATLAB ARGUMENTS]`

Extracts features from the audio signals.
Additional MATLAB ARGUMENTS will be passed as strings to the matlab feature extraction function.

Some relevant paths:

- `fade.d/features.d/`      Some default features including MFCCs
- `./config/features/matlab/feature_extraction.m` Script used for feature extraction
- `./processing/`           Preferred source directory
- `./corpus/`               Alternative source directory
- `./features/`             Target directory


#### Train models with training data
`fade <project> training [STATES] [SILENCE_STATES] [MIXTURES] [ITERATIONS] [UPDATES] [PRUNINGS] [BINARY]`

Performs the training of the models for the defined conditions.

Some relevant paths:

- `./config/corpus/conditions/`    Training condition definitions
- `./config/training/parameters`   Training parameters
- `./features/train/`              Source directory
- `./training/`                    Target directory


#### Recognize the testing data
`fade <project> recognition [PRUNING] [MAXACTIVE] [BINARY]`

Performs the recognition of the testing data for the defined conditions.

Some relevant paths:

- `./config/corpus/conditions/`    Testing condition definitions
- `./config/training/parameters`   Testing parameters
- `./features/test/`               Source directory
- `./recognition/`                 Target directory


#### Evaluate the results
`fade <project> evaluation`

Runs the evaluation script.

Some relevant paths:

- `./recognition/`                 Source directory
- `./evaluation/`                  Target directory


#### Generate figures
`fade <project> figures`

Runs the Matlab figure script.

Some relevant paths:

- `./config/figures/matlab/figures.m`  Figure generation script
- `./evaluation/`                      Source directory
- `./figures/`                         Target directory
- `./figures/table.txt`                Uniform ascii results table


#### Export a project
`fade <project> export <file> [KEEP] [LINK]`

Exports the whole project to a compressed file.
This may take a while.


#### Import a project
`fade <project> import <file> [OVERWRITE]`

Imports a project from a file to a non-existing or empty project.


#### Fork a project
`fade <project1> fork <project2> [LINK]`

Forks project1 by creating project2, and copying the configuration directory
`./config/` and linking (or copying) the data directories to it.

This feature can be used to generate a corpus in a dedicated project
and then fork it in order to try different feature extraction schemes with the
same data, without storing the corpus data redundantly.

A project can be forked after every action. An action will always remove
the link instead of removing the contents. Scripts run in project2 will never
write to the parent project1.


## Usage
`fade-config <project> <action> [argument1] [argument2] [argument3] ...`

Do the same as `fade` but stop after configuration, and hence only write to the `./config/` directory.


# References
[1] Schädler, M. R., Warzybok, A., Ewert, S. D., and Kollmeier, B., "A simulation framework for auditory discrimination experiments: Revealing the importance of across-frequency processing in speech perception" Journal of the Acoustical Society of America, Volume 139, Issue 5, pp. 2708–2723, https://doi.org/10.1121/1.4948772 (2016)

[2] Schädler, M. R., Warzybok, A., and Kollmeier, B. "Objective Prediction of Hearing Aid Benefit Across Listener Groups Using Machine Learning: Speech Recognition Performance With Binaural Noise-Reduction Algorithms" Trends in Hearing, https://doi.org/10.1177/2331216518768954 (2018)

[3] URL http://www.hoertech.de/en/medical-devices/olsa.html
