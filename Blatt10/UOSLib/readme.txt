Unified Online-learning Systems LIBrary - UOSLIB
by Andreas Buschermöhle, Jens Hülsmann, Werner Brockmann
University of Osnabrück
Contact Andreas.Buschermoehle@Uni-Osnabrueck.de

UOS Lib (Unified Online-learning Systems LIBrary) is an open source 
libraray for online learning for Matlab®. It is focused on the two tasks of 
classification and regression and consists of several state-of-the-art 
learning algorithms. Those can be applied to a number of automatically 
generated learning poblems included in the library and are automatically 
evaluated. Furthermore, a simple interface to read datasets from files is 
included, so well known benchmarks can be run as well. The intention of 
this library is twofold. On the one hand, it is possible to compare 
different approaches to online-learning within a common framework, e.g. to 
see how new approaches rank in comparison to the state-of-the-art. On the 
other hand, a task at hand can be solved with different learning algorithms 
to find the most suitable approach.

---------------------------------------------------------------------------
License:
This libraray is under the GNU GENERAL PUBLIC LICENSE Version 3.
See license.txt for details.

---------------------------------------------------------------------------
Files in this library:
    icl_base - This is the main file from where a single execution can be
               run as a script or it can be called as a function to do
               automatic evaluation.
    icl_genGLT - This function is used to generate a grid based lookup
                 table as the approximation sturcture.
    icl_genGLTarb - This function is used to generate an arbitrary grid based
					lookup table as the approximation sturcture.
    icl_genPoly - This function is used to generate a polynomial
                  approximation sturcture.
    icl_initILS - This file is blank version of the algorithm specific
                  initializations. See files of specific algorithms as an
                  example.
    icl_learn - This file is blank version of the algorithm specific
                incremental learning. See files of specific algorithms as
                an example.
    icl_loadDS - With this function either synthetic datasets or benchmarks
                 from files can be read.
    icl_predict - This function is used to predict a label for a new input.
    icl_predictTrust - This function is used to predict the trustworthiness of a
					   label for a new input.
    icl_showResult - With this function a visualization of the resulting
                     approximation after learning in comparison to the data
                     is made. (works only for 1D and 2D)
    icl_transform - This function transforms an input from input space to
                    parameter space.
    icl_updateILS - This function updates the incremental learning structure
					with a new parameter vector and adjusts the meta-information
					for uncertainty tracking.
    icl_initILS_XXX and icl_learn_XXX in the subfolder algorithms are
    specific files for the learning algorithms with XXX beeing the name of
    the algorithm.

---------------------------------------------------------------------------
A short how to:
    The top of icl_base contains all setups necessary to get startet,
    to run a single learning task:
        mode - Choose CLA for Classification or REG for regression
        learnMethod - String to choose the learning method (e.g. 'RLS')
        algSetup - parameters that are passed to the learning algorithm
        model - model structure used for approximation
        start - initial parameter vector
        targetFunc.target - Target function, to be approximated (e.g. 'sine')
        targetFunc.ND - number of training data
        targetFunc.NG - number of ground truth data for comparison
        targetFunc.noise - amount of noise on the training data
        targetFunc.minPath - dependend or independend training data
        livePlot - Live visualization after every learning step
        fastmode - Enable to skip generation of data loss and ground truth loss
        quiet - Enable to suppress all messages and plots
        rSeed - Seed for the random number generator to get reproducable results.
    
    Optional setup currently not available as function parameters
    (for specific inverstigations/methods)
    - implement different losses (see variable loss)