## Copyright (C) 2024 Pallav Purbia <pallavpurbia@gmail.com>
##
## This file is part of the statistics package for GNU Octave.
##
## This program is free software; you can redistribute it and/or modify it under
## the terms of the GNU General Public License as published by the Free Software
## Foundation; either version 3 of the License, or (at your option) any later
## version.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License along with
## this program; if not, see <http://www.gnu.org/licenses/>.

classdef ClassificationNeuralNetwork
## -*- texinfo -*-
## @deftypefn  {statistics} {@var{obj} =} ClassificationNeuralNetwork (@var{X}, @var{Y})
## @deftypefnx {statistics} {@var{obj} =} ClassificationNeuralNetwork (@dots{}, @var{name}, @var{value})
##
## Create a @qcode{ClassificationNeuralNetwork} class object containing a Neural
## Network classification model.
##
## @code{@var{obj} = ClassificationNeuralNetwork (@var{X}, @var{Y})} returns a
## ClassificationNeuralNetwork object, with @var{X} as the predictor data and
## @var{Y} containing the class labels of observations in @var{X}.
##
## @itemize
## @item
## @code{X} must be a @math{NxP} numeric matrix of input data where rows
## correspond to observations and columns correspond to features or variables.
## @var{X} will be used to train the model.
## @item
## @code{Y} is @math{Nx1} matrix or cell matrix containing the class labels of
## corresponding predictor data in @var{X}. @var{Y} can contain any type of
## categorical data. @var{Y} must have same numbers of rows as @var{X}.
## @end itemize
##
## @code{@var{obj} = ClassificationNeuralNetwork (@dots{}, @var{name},
## @var{value})} returns a ClassificationNeuralNetwork object with parameters
## specified by @qcode{Name-Value} pair arguments. Type @code{help fitcnet}
## for more info.
##
## A @qcode{ClassificationNeuralNetwork} object, @var{obj}, stores the labelled
## training data and various parameters for the Neural Network classification
## model, which can be accessed in the following fields:
##
## @multitable @columnfractions 0.28 0.02 0.7
## @headitem @var{Field} @tab @tab @var{Description}
##
## @item @qcode{"obj.X"} @tab @tab Unstandardized predictor data, specified as a
## numeric matrix.  Each column of @var{X} represents one predictor (variable),
## and each row represents one observation.
##
## @item @qcode{"obj.Y"} @tab @tab Class labels, specified as a logical or
## numeric vector, or cell array of character vectors.  Each value in @var{Y} is
## the observed class label for the corresponding row in @var{X}.
##
## @item @qcode{"obj.NumObservations"} @tab @tab Number of observations used in
## training the model, specified as a positive integer scalar. This number can
## be less than the number of rows in the training data because rows containing
## @qcode{NaN} values are not part of the fit.
##
## @item @qcode{obj.RowsUsed} @tab @tab Rows of the original training data
## used in fitting the ClassificationNeuralNetwork model, specified as a
## numerical vector. If you want to use this vector for indexing the training
## data in @var{X}, you have to convert it to a logical vector, i.e
## @qcode{X = obj.X(logical (obj.RowsUsed), :);}
##
## @item @qcode{obj.Standardize} @tab @tab A boolean flag indicating whether
## the data in @var{X} have been standardized prior to training.
##
## @item @qcode{obj.Sigma} @tab @tab Predictor standard deviations, specified
## as a numeric vector of the same length as the columns in @var{X}.  If the
## predictor variables have not been standardized, then @qcode{"obj.Sigma"} is
## empty.
##
## @item @qcode{obj.Mu} @tab @tab Predictor means, specified as a numeric
## vector of the same length as the columns in @var{X}.  If the predictor
## variables have not been standardized, then @qcode{"obj.Mu"} is empty.
##
## @item @qcode{obj.NumPredictors} @tab @tab The number of predictors
## (variables) in @var{X}.
##
## @item @qcode{obj.PredictorNames} @tab @tab Predictor variable names,
## specified as a cell array of character vectors.  The variable names are in
## the same order in which they appear in the training data @var{X}.
##
## @item @qcode{obj.ResponseName} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{obj.ClassNames} @tab @tab Names of the classes in the class
## labels, @var{Y}, used for fitting the ClassificationNeuralNetwork model.
## @qcode{ClassNames} are of the same type as the class labels in @var{Y}.
##





## @item @qcode{"obj.LayerSizes"} @tab @tab Sizes of the fully connected layers
## in the neural network model, returned as a positive integer vector. The ith
## element of LayerSizes is the number of outputs in the ith fully connected
## layer of the neural network model. LayerSizes does not include the size of
## the final fully connected layer. This layer always has K outputs, where K
## is the number of classes in Y.







##
## @item @qcode{"obj.LayerWeights"} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{"obj.LayerBiases"} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{"obj.Activations"} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{"obj.OutputLayerActivation"} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{"obj.ModelParameters"} @tab @tab A structure containing the
## parameters used to train the Neural Network classifier model with the
## following fields: @code{SVMtype}, @code{BoxConstraint}, @code{CacheSize}, @code{KernelScale},
## @code{KernelOffset}, @code{KernelFunction}, @code{PolynomialOrder},
## @code{Nu}, @code{Tolerance}, and @code{Shrinking}.
##
## @item @qcode{"obj.ConvergenceInfo"} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{"obj.TrainingHistory"} @tab @tab Response variable name, specified
## as a character vector.
##
## @item @qcode{"obj.Solver"} @tab @tab Response variable name, specified
## as a character vector.
##
## @end multitable
##
## @seealso{fitcnet}
## @end deftypefn

  properties (Access = public)

    X                     = [];  # Predictor data
    Y                     = [];  # Class labels

    NumObservations       = [];  # Number of observations in training dataset
    RowsUsed              = [];  # Rows used in fitting
    Standardize           = [];  # Flag to standardize predictors
    Sigma                 = [];  # Predictor standard deviations
    Mu                    = [];  # Predictor means

    NumPredictors         = [];  # Number of predictors
    PredictorNames        = [];  # Predictor variables names
    ResponseName          = [];  # Response variable name
    ClassNames            = [];  # Names of classes in Y
    Prior                 = [];  # Prior probability for each class
    Cost                  = [];  # Cost of misclassification

    LayerSizes            = [];  # Size of fully connected layers
    LayerWeights          = [];  # Learned layer weights
    LayerBiases           = [];  # Learned layer biases
    Activations           = [];  # Activation function for fully connected layer
    OutputLayerActivation = [];  # Activation function for final connected layer

    ModelParameters       = [];  # Model parameters          .........................have to assign
    ConvergenceInfo       = [];  # Convergence Information   .........................have to assign
    TrainingHistory       = [];  # Training history          .........................have to assign
    Solver                = [];  # Solver used

  endproperties

    properties (Access = private)

    gY                    = [];
    gnY                   = [];
    glY                   = [];
    parameter_vector      = []; ## may or may not be used

  endproperties

  methods (Access = public)

    ## Class object constructor
    function this = ClassificationNeuralNetwork (X, Y, varargin)
      ## Check for sufficient number of input arguments
      if (nargin < 2)
        error ("ClassificationNeuralNetwork: too few input arguments.");
      endif

      ## Check X and Y have the same number of observations
      if (rows (X) != rows (Y))
        error (strcat (["ClassificationNeuralNetwork: number of rows in X"], ...
                       [" and Y must be equal."]));
      endif

      ## Assign original X and Y data to the ClassificationNeuralNetwork object
      this.X = X;
      this.Y = Y;

      ## Get groups in Y
      [gY, gnY, glY] = grp2idx (Y);

      ## Set default values before parsing optional parameters
      Standardize             = false;
      ResponseName            = [];
      PredictorNames          = [];
      ClassNames              = [];
      Prior                   = [];
      Cost                    = [];
      LayerSizes              = 10;
      Activations             = 'relu';
      LayerWeightsInitializer = 'glorot';
      LayerBiasesInitializer  = 'zeros';
      InitialStepSize         = [];
      IterationLimit          = 1e3;
      GradientTolerance       = 1e-6;
      LossTolerance           = 1e-6;
      StepTolerance           = 1e-6;

      ## Parse extra parameters
      while (numel (varargin) > 0)
        switch (tolower (varargin {1}))

          case "standardize"
            Standardize = varargin{2};
            if (! (Standardize == true || Standardize == false))
              error (strcat (["ClassificationNeuralNetwork: 'Standardize'"], ...
                             [" must be either true or false."]));
            endif

          case "predictornames"
            PredictorNames = varargin{2};
            if (! iscellstr (PredictorNames))
              error (strcat (["ClassificationNeuralNetwork: 'PredictorNames'"], ...
                             [" must be supplied as a cellstring array."]));
            elseif (columns (PredictorNames) != columns (X))
              error (strcat (["ClassificationNeuralNetwork: 'PredictorNames'"], ...
                             [" must have the same number of columns as X."]));
            endif

          case "responsename"
            ResponseName = varargin{2};
            if (! ischar (ResponseName))
              error (strcat (["ClassificationNeuralNetwork: 'ResponseName'"], ...
                             [" must be a character vector."]));
            endif

          case "classnames"
            ClassNames = varargin{2};
            if (! (iscellstr (ClassNames) || isnumeric (ClassNames)
                                          || islogical (ClassNames)))
              error (strcat (["ClassificationNeuralNetwork: 'ClassNames' must"], ...
                             [" be a cellstring, logical or numeric vector."]));
            endif
            ## Check that all class names are available in gnY
            if (iscellstr (ClassNames))
              if (! all (cell2mat (cellfun (@(x) any (strcmp (x, gnY)),
                                   ClassNames, "UniformOutput", false))))
                error (strcat (["ClassificationNeuralNetwork: not all"], ...
                               [" 'ClassNames' are present in Y."]));
              endif
            else
              if (! all (cell2mat (arrayfun (@(x) any (x == glY),
                                   ClassNames, "UniformOutput", false))))
                error (strcat (["ClassificationNeuralNetwork: not all"], ...
                               [" 'ClassNames' are present in Y."]));
              endif
            endif

          case "prior"
            Prior = varargin{2};
            if (! ((isnumeric (Prior) && isvector (Prior)) ||
                  (strcmpi (Prior, "empirical") || strcmpi (Prior, "uniform"))))
              error (strcat (["ClassificationNeuralNetwork: 'Prior' must"], ...
                             [" be either a numeric vector or a character"], ...
                             [" vector."]));
            endif

          case "cost"
            Cost = varargin{2};
            if (! (isnumeric (Cost) && issquare (Cost)))
              error (strcat (["ClassificationNeuralNetwork: 'Cost' must be"], ...
                             [" a numeric square matrix."]));
            endif

          case 'layersizes'
            LayerSizes = varargin{2};
            if (! (isnumeric(LayerSizes) && isvector(LayerSizes)
              && all(LayerSizes > 0) && all(mod(LayerSizes, 1) == 0)))
              error (strcat (["ClassificationNeuralNetwork: LayerSizes"], ...
                             [" must be a positive integer vector."]));
            endif

          case 'activations'
            Activations = varargin{2};
            if (!(ischar(Activations)))
              error (strcat (["ClassificationNeuralNetwork: Activations"], ...
                             [" must be a string."]));
            endif
            if (ischar(Activations))
              if (! any (strcmpi (tolower(Activations), {"relu", "tanh", ...
                "sigmoid", "none"})))
              error (strcat (["ClassificationNeuralNetwork: unsupported"], ...
                             [" Activation function."]));
              endif
            endif
            Activations = tolower(Activations);

          case 'layerweightsinitializer'
            LayerWeightsInitializer = varargin{2};
            if (!(ischar(LayerWeightsInitializer)))
              error (strcat (["ClassificationNeuralNetwork:"], ...
                             [" LayerWeightsInitializer must be a string."]));
            endif
            if (ischar(LayerWeightsInitializer))
              if (! any (strcmpi (tolower(LayerWeightsInitializer), ...
                                 {"glorot", "he"})))
              error (strcat (["ClassificationNeuralNetwork: unsupported"], ...
                             [" LayerWeightsInitializer function."]));
              endif
            endif

          case 'layerbiasesinitializer'
            LayerBiasesInitializer = varargin{2};
            if (!(ischar(LayerBiasesInitializer)))
              error (strcat (["ClassificationNeuralNetwork:"], ...
                             [" LayerBiasesInitializer must be a string."]));
            endif
            if (ischar(LayerBiasesInitializer))
              if (! any (strcmpi (tolower(LayerBiasesInitializer), {"zeros", ...
                    "ones"})))
              error (strcat (["ClassificationNeuralNetwork: unsupported"], ...
                             [" LayerBiasesInitializer function."]));
              endif
            endif

          case 'initialstepsize'
            InitialStepSize = varargin{2};
            if ( !(isscalar(InitialStepSize) && (InitialStepSize > 0)))
              error (strcat (["ClassificationNeuralNetwork:"], ...
                             [" InitialStepSize must be a positive scalar."]));
            endif

          case 'iterationlimit'
            IterationLimit = varargin{2};
            if (! (isnumeric(IterationLimit) && isscalar(IterationLimit)
              && (IterationLimit > 0) && mod(IterationLimit, 1) == 0))
              error (strcat (["ClassificationNeuralNetwork: IterationLimit"], ...
                             [" must be a positive integer."]));
            endif

          case 'gradienttolerance'
            GradientTolerance = varargin{2};
            if (! (isnumeric(GradientTolerance) && isscalar(GradientTolerance)
              && (GradientTolerance >= 0)))
              error (strcat (["ClassificationNeuralNetwork: GradientTolerance"], ...
                             [" must be a non-negative scalar."]));
            endif

          case 'losstolerance'
            LossTolerance = varargin{2};
            if (! (isnumeric(LossTolerance) && isscalar(LossTolerance)
              && (LossTolerance >= 0)))
              error (strcat (["ClassificationNeuralNetwork: LossTolerance"], ...
                             [" must be a non-negative scalar."]));
            endif

          case 'steptolerance'
            StepTolerance = varargin{2};
            if (! (isnumeric(StepTolerance) && isscalar(StepTolerance)
              && (StepTolerance >= 0)))
              error (strcat (["ClassificationNeuralNetwork: StepTolerance"], ...
                             [" must be a non-negative scalar."]));
            endif

          otherwise
            error (strcat (["ClassificationNeuralNetwork: invalid"],...
                           [" parameter name in optional pair arguments."]));

        endswitch
        varargin (1:2) = [];
      endwhile

      ## Get number of variables in training data
      ndims_X = columns (X);

      ## Assign the number of predictors to the object
      this.NumPredictors = ndims_X;

      ## Handle class names
      if (! isempty (ClassNames))
        if (iscellstr (ClassNames))
          ru = find (! ismember (gnY, ClassNames));
        else
          ru = find (! ismember (glY, ClassNames));
        endif
        for i = 1:numel (ru)
          gY(gY == ru(i)) = NaN;
        endfor
      endif

      ## Remove missing values from X and Y
      RowsUsed  = ! logical (sum (isnan ([X, gY]), 2));
      Y         = Y (RowsUsed);
      X         = X (RowsUsed, :);

      ## Renew groups in Y
      [gY, gnY, glY] = grp2idx (Y);
      this.ClassNames = gnY;  # Keep the same type as Y

      this.gY = gY;
      this.gnY = gnY;
      this.glY = glY;

##      printf("gY: ");
##      disp(gY);
##      printf("gnY: ");
##      disp(gnY);
##      printf("glY: ");
##      disp(glY);

      ## Force Y into numeric
      if (! isnumeric (Y))
        Y = gY;
      endif

      ## Check X contains valid data
      if (! (isnumeric (X) && isfinite (X)))
        error ("ClassificationNeuralNetwork: invalid values in X.");
      endif

      ## Assign the number of observations and their correspoding indices
      ## on the original data, which will be used for training the model,
      ## to the ClassificationNeuralNetwork object
      this.NumObservations = rows (X);
      this.RowsUsed = cast (RowsUsed, "double");

      ## Handle Standardize flag
      if (Standardize)
        this.Standardize = true;
        this.Sigma = std (X, [], 1);
        this.Sigma(this.Sigma == 0) = 1;  # predictor is constant
        this.Mu = mean (X, 1);
      else
        this.Standardize = false;
        this.Sigma = [];
        this.Mu = [];
      endif

      ## Handle Prior and Cost
      if (strcmpi ("uniform", Prior))
        this.Prior = ones (size (gnY)) ./ numel (gnY);
      elseif (isempty (Prior) || strcmpi ("empirical", Prior))
        pr = [];
        for i = 1:numel (gnY)
          pr = [pr; sum(gY==i)];
        endfor
        this.Prior = pr ./ sum (pr);
      elseif (isnumeric (Prior))
        if (numel (gnY) != numel (Prior))
          error (strcat (["ClassificationNeuralNetwork: the elements in"], ...
                         [" 'Prior' do not correspond to selected classes"], ...
                         [" in Y."]));
        endif
        this.Prior = Prior ./ sum (Prior);
      endif
      if (isempty (Cost))
        this.Cost = cast (! eye (numel (gnY)), "double");
      else
        if (numel (gnY) != sqrt (numel (Cost)))
          error (strcat (["ClassificationNeuralNetwork: the number of"], ...
                         [" rows and columns in 'Cost' must correspond to"], ...
                         [" the selected classes in Y."]));
        endif
        this.Cost = Cost;
      endif

      ## Generate default predictors and response variabe names (if necessary)
      if (isempty (PredictorNames))
        for i = 1:ndims_X
          PredictorNames {i} = strcat ("x", num2str (i));
        endfor
      endif
      if (isempty (ResponseName))
        ResponseName = "Y";
      endif

      ## Assign predictors and response variable names
      this.PredictorNames = PredictorNames;
      this.ResponseName = ResponseName;
      this.LayerSizes = LayerSizes;
      this.Activations = Activations;
      this.OutputLayerActivation = "softmax";
      this.Solver = "LBFGS";

      this = parameter_initializer(this,LayerWeightsInitializer,LayerBiasesInitializer);
## already trained weights(just for checking if forward propagation works or not. which it does work)
##this.LayerWeights{1} = [
##-2.9823, -3.8519, 7.1521, 9.9223;
##-0.4188, 0.1895, 0.0812, -0.1952;
##0.3027, 0.0646, -0.3976, -0.0660;
##-0.2450, -0.2422, -0.3497, -0.6926;
##0.8523, 4.5536, -6.7396, -3.5799;
##];
##this.LayerWeights{2} = [
##5.3509,	0.8036,	4.4741,	-0.9038,	-3.6919;
##3.8612,	-0.6853,	4.9577,	-0.3016,	-2.9650;
##];
##this.LayerWeights{3} = [
##-10.5846,	-7.5079;
##6.4736,	1.1391;
##3.0274,	6.4106;
## ];
##this.LayerBiases{1} = [
##-4.3681;
##0;
##0.5462;
##0;
##0.4710;
##];
##this.LayerBiases{2} = [
##0.4464;
##-6.2276;
##];
##this.LayerBiases{3} = [
##18.3889;
##-6.3130;
##-12.0759;
##];

     options = optimset('MaxIter', IterationLimit, 'TolFun', LossTolerance, 'TolX', StepTolerance);
     initialThetaVec = this.vectorize_parameters();
     initialThetaVec
##     [LayerWeights, LayerBiases] = reshape_parameters(this, initialThetaVec);
##     LayerWeights
##     LayerBiases
##     LayerWeights{1}
      [optThetaVec, cost] = fminunc(@(thetaVec) costFunction(thetaVec, this, X, Y), initialThetaVec, options);
      [this.LayerWeights, this.LayerBiases] = reshape_parameters(this, optThetaVec);

    endfunction

    ## -*- texinfo -*-
    ## @deftypefn  {ClassificationNeuralNetwork} {@var{labels} =} predict (@var{obj}, @var{X})
    ##
    ## Classify new data points into categories using the Neural Network
    ## classification object.
    ##
    ## @code{@var{labels} = predict (@var{obj}, @var{X})} returns the vector of
    ## labels predicted for the corresponding instances in @var{X}, using the
    ## predictor data in @code{obj.X} and corresponding labels, @code{obj.Y},
    ## stored in the Neural Network classification model, @var{obj}.
    ##
    ## @itemize
    ## @item
    ## @var{obj} must be a @qcode{ClassificationNeuralNetwork} class object.
    ## @item
    ## @var{X} must be an @math{MxP} numeric matrix with the same number of
    ## features @math{P} as the corresponding predictors of the SVM model in
    ## @var{obj}.
    ## @end itemize
    ##
    ## @seealso{fitcnet, ClassificationNeuralNetwork}
    ## @end deftypefn

    function labels = predict(this, XC)

      ## Check for sufficient input arguments
      if (nargin < 2)
        error ("ClassificationNeuralNetwork.predict: too few input arguments.");
      endif

      if (mod (nargin, 2) != 0)
        error (strcat(["ClassificationNeuralNetwork.predict: Name-Value"], ...
                     [" arguments must be in pairs."]));
      endif

      ## Check for valid XC
      if (isempty (XC))
        error ("ClassificationNeuralNetwork.predict: XC is empty.");
      elseif (columns(this.X) != columns(XC))
        error (strcat (["ClassificationNeuralNetwork.predict: XC must have the"], ...
                       [" same number of features as in the Neural Network model."]));
      endif

      ## Standardize (if necessary)
      if (this.Standardize)
        XC = (XC - this.Mu) ./ this.Sigma;
      endif

      ## Forward propagation
      A = XC;
      for i = 1:length(this.LayerSizes)+1
        Z = A * this.LayerWeights{i}' + this.LayerBiases{i}';
    ####printf("Z");
    ####disp(Z);
        if (i <= length(this.LayerSizes))
          [A, z] = this.Layer_Activation(Z);
        else
          A = this.softmax(Z);
        endif
    ####printf("A");
    ####disp(A);
      endfor

      # Get the predicted labels (class with highest probability)
      [~, labels] = max(A, [], 2);
      labels = this.ClassNames(labels);

    endfunction

   endmethods

  ## Helper functions
  methods (Access = private)
    ## Activation function
    function [A, z] = Layer_Activation(this,z)
      switch this.Activations
        case 'relu'
          A = max(0, z);
        case 'tanh'
          A = tanh(z);
        case 'sigmoid'
          A = 1 ./ (1 + exp(-z));
        case 'none'
          A = z;
      endswitch
    endfunction

    ## Activation Gradient
    function dz = Activation_Gradient(dA, z)
      switch this.Activations
        case 'relu'
          A = max(0, z);
          dz = dA .* (A > 0);
        case 'tanh'
          A = tanh(z);
          dz = dA .* (1 - A.^2);
        case 'sigmoid'
          A = 1 ./ (1 + exp(-z));
          dz = dA .* A .* (1 - A);
        case 'none'
          A = z;
          dz = dA;
      endswitch
    endfunction

    ## Softmax activation function
    function softmax = softmax(this,z)
      exp_z = exp(z - max(z, [], 2));  # Stability improvement
      softmax = exp_z ./ sum(exp_z, 2);
    endfunction

    ## Initialize weights and biases based on the specified initializers
    function this = parameter_initializer(this, LayerWeightsInitializer, LayerBiasesInitializer)

      numLayers = numel(this.LayerSizes);
      inputSize = this.NumPredictors;

      for i = 1:numLayers
        if (i == 1)
          prevLayerSize = inputSize;
        else
          prevLayerSize = this.LayerSizes(i-1);
        endif

        layerSize = this.LayerSizes(i);

        ## Initialize weights
        if (strcmpi(LayerWeightsInitializer, 'glorot'))
          limit = sqrt(6 / (prevLayerSize + layerSize));
          this.LayerWeights{i} = 2 * limit * (rand(layerSize, prevLayerSize) - 0.5);
        elseif (strcmpi(LayerWeightsInitializer, 'he'))
          limit = sqrt(2 / prevLayerSize);
          this.LayerWeights{i} = limit * randn(layerSize, prevLayerSize);
        endif

        ## Initialize biases
        if (strcmpi(LayerBiasesInitializer, 'zeros'))
          this.LayerBiases{i} = zeros(layerSize, 1);
        elseif (strcmpi(LayerBiasesInitializer, 'ones'))
          this.LayerBiases{i} = ones(layerSize, 1);
        endif
      endfor

      ## Initialize the weights and biases for the output layer
      outputLayerSize = numel(this.ClassNames);
      prevLayerSize = this.LayerSizes(end);

      ## Initialize output layer weights
      if (strcmpi(LayerWeightsInitializer, 'glorot'))
        limit = sqrt(6 / (prevLayerSize + outputLayerSize));
        this.LayerWeights{end+1} = 2 * limit * (rand(outputLayerSize, prevLayerSize) - 0.5);
      elseif (strcmpi(LayerWeightsInitializer, 'he'))
        limit = sqrt(2 / prevLayerSize);
        this.LayerWeights{end+1} = limit * randn(outputLayerSize, prevLayerSize);
      endif

      ## Initialize output layer biases
      if (strcmpi(LayerBiasesInitializer, 'zeros'))
        this.LayerBiases{end+1} = zeros(outputLayerSize, 1);
      elseif (strcmpi(LayerBiasesInitializer, 'ones'))
        this.LayerBiases{end+1} = ones(outputLayerSize, 1);
      endif

    endfunction

    ## One Hot Vector Encoder
    function one_hot_vector = one_hot_encoder(this, Y)
       ## one_hot_vector = sparse(1:numel(Y), Y,1); fastest and most memory efficient option but the output is sparse and I don't know how to work with it.
       one_hot_vector = bsxfun(@eq, Y(:), 1:max(Y));
    endfunction

    ## Cross Entropy Loss function
    function loss = compute_cross_entropy_loss(this, Y_pred, Y_true)

      ## One-hot encode the true labels
      one_hot_Y_true = this.one_hot_encoder(Y_true);

      ## Number of observations
      m = size(Y_true, 1);

      ## Adding a small value to Y_pred to avoid log(0)
      Y_pred = Y_pred + eps;

      ## Compute the cross-entropy loss
      loss = -sum(sum(one_hot_Y_true .* log(Y_pred))) / m;
    endfunction

    ## Vectorize the parameters so that they can be used for fminunc
    function thetaVec = vectorize_parameters(this)
      thetaVec = [];
      for i = 1:numel(this.LayerWeights)
        thetaVec = [thetaVec; this.LayerWeights{i}(:)];
        thetaVec = [thetaVec; this.LayerBiases{i}(:)];
      endfor
    endfunction

    ## Cost Function
    function [J, gradVec] = costFunction(thetaVec, this, X, Y)
      [LayerWeights, LayerBiases] = reshape_parameters(this, thetaVec);

      ## Forward Propagation
      A = X';
      Zs = cell(numel(LayerWeights), 1);
      As = cell(numel(LayerWeights), 1);

      for i = 1:numel(LayerWeights)
        ## Print dimensions for debugging
        printf("Layer %d\n", i);
        printf("LayerWeights{%d}: %dx%d\n", i, size(LayerWeights{i}, 1), size(LayerWeights{i}, 2));
        printf("A: %dx%d\n", size(A, 1), size(A, 2));

        Zs{i} = LayerWeights{i} * A + LayerBiases{i};
        ## After this line:
        ## Zs{i} should have dimensions: size(LayerWeights{i}, 1) x size(A, 2)
        printf("Zs{%d}: %dx%d\n", i, size(Zs{i}, 1), size(Zs{i}, 2));

        if i == numel(LayerWeights)
          A = this.softmax(Zs{i}');
        else
          [A, ~] = this.Layer_Activation(Zs{i});
          A = A';
        endif
        ## After activation:
        ## A should have the same dimensions as Zs{i} (transposed if softmax)
        printf("A (after activation): %dx%d\n", size(A, 1), size(A, 2));
        As{i} = A;
      endfor

      ## Compute Loss
      J = this.compute_cross_entropy_loss(A', Y);

      ## Backward Propagation
      m = size(X, 1);
      dA = A' - this.one_hot_encoder(Y);
      dWs = cell(numel(LayerWeights), 1);
      dBs = cell(numel(LayerWeights), 1);

      for i = numel(LayerWeights):-1:1
        if i == numel(LayerWeights)
          dZ = dA;
        else
          dA = LayerWeights{i+1}' * dZ;
          dZ = this.Activation_Gradient(dA, Zs{i});
        endif

        dWs{i} = dZ * As{i-1}' / m;
        dBs{i} = sum(dZ, 2) / m;
      endfor

      ## Vectorize Gradients
      gradVec = [];
      for i = 1:numel(dWs)
        gradVec = [gradVec; dWs{i}(:)];
        gradVec = [gradVec; dBs{i}(:)];
      endfor
    endfunction

    function [LayerWeights, LayerBiases] = reshape_parameters(this, thetaVec)
      LayerWeights = cell(numel(this.LayerSizes) + 1, 1);
      LayerBiases = cell(numel(this.LayerSizes) + 1, 1);

      offset = 0;
      inputSize = this.NumPredictors;

      for i = 1:numel(this.LayerSizes)
        layerSize = this.LayerSizes(i);

        if i == 1
          prevLayerSize = inputSize;
        else
          prevLayerSize = this.LayerSizes(i-1);
        endif

        w_size = layerSize * prevLayerSize;
        b_size = layerSize;

        LayerWeights{i} = reshape(thetaVec(offset + 1:offset + w_size), layerSize, prevLayerSize);
        offset = offset + w_size;
        LayerBiases{i} = reshape(thetaVec(offset + 1:offset + b_size), layerSize, 1);
        offset = offset + b_size;
      endfor

      outputLayerSize = numel(this.ClassNames);
      prevLayerSize = this.LayerSizes(end);
      w_size = outputLayerSize * prevLayerSize;
      b_size = outputLayerSize;

      LayerWeights{end} = reshape(thetaVec(offset + 1:offset + w_size), outputLayerSize, prevLayerSize);
      offset = offset + w_size;
      LayerBiases{end} = reshape(thetaVec(offset + 1:offset + b_size), outputLayerSize, 1);
    endfunction

  endmethods
endclassdef

## Test input validation for constructor
%!error<ClassificationNeuralNetwork: too few input arguments.> ...
%! ClassificationNeuralNetwork ()
%!error<ClassificationNeuralNetwork: too few input arguments.> ...
%! ClassificationNeuralNetwork (ones(10,2))
%!error<ClassificationNeuralNetwork: number of rows in X and Y must be equal.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (5,1))
%!error<ClassificationNeuralNetwork: 'Standardize' must be either true or false.> ...
%! ClassificationNeuralNetwork (ones (5,3), ones (5,1), "standardize", "a")
%!error<ClassificationNeuralNetwork: 'PredictorNames' must be supplied as a cellstring array.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "PredictorNames", ["A"])
%!error<ClassificationNeuralNetwork: 'PredictorNames' must be supplied as a cellstring array.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "PredictorNames", "A")
%!error<ClassificationNeuralNetwork: 'PredictorNames' must have the same number of columns as X.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "PredictorNames", {"A", "B", "C"})
%!error<ClassificationNeuralNetwork: 'ResponseName' must be a character vector.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "ResponseName", {"Y"})
%!error<ClassificationNeuralNetwork: 'ResponseName' must be a character vector.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "ResponseName", 1)
%!error<ClassificationNeuralNetwork: 'ClassNames' must be a cellstring, logical or numeric vector.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "ClassNames", @(x)x)
%!error<ClassificationNeuralNetwork: 'ClassNames' must be a cellstring, logical or numeric vector.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "ClassNames", ['a'])
%!error<ClassificationNeuralNetwork: not all 'ClassNames' are present in Y.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "ClassNames", [1, 2])
%!error<ClassificationNeuralNetwork: not all 'ClassNames' are present in Y.> ...
%! ClassificationNeuralNetwork (ones(5,2), {'a';'b';'a';'a';'b'}, "ClassNames", {'a','c'})
%!error<ClassificationNeuralNetwork: not all 'ClassNames' are present in Y.> ...
%! ClassificationNeuralNetwork (ones(10,2), logical (ones (10,1)), "ClassNames", [true, false])
%!error<ClassificationNeuralNetwork: 'Prior' must be either a numeric vector or a character vector.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "Prior", {"1", "2"})
%!error<ClassificationNeuralNetwork: 'Cost' must be a numeric square matrix.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "Cost", [1, 2])
%!error<ClassificationNeuralNetwork: 'Cost' must be a numeric square matrix.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "Cost", "string")
%!error<ClassificationNeuralNetwork: 'Cost' must be a numeric square matrix.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "Cost", {eye(2)})
%!error<ClassificationNeuralNetwork: LayerSizes must be a positive integer vector.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerSizes", -1)
%!error<ClassificationNeuralNetwork: LayerSizes must be a positive integer vector.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerSizes", 0.5)
%!error<ClassificationNeuralNetwork: LayerSizes must be a positive integer vector.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerSizes", [1,-2])
%!error<ClassificationNeuralNetwork: LayerSizes must be a positive integer vector.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerSizes", [10,20,30.5])
%!error<ClassificationNeuralNetwork: Activations must be a string.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "Activations", 123)
%!error<ClassificationNeuralNetwork: unsupported Activation function.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "Activations", "unsupported_type")
%!error<ClassificationNeuralNetwork: LayerWeightsInitializer must be a string.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerWeightsInitializer", 123)
%!error<ClassificationNeuralNetwork: unsupported LayerWeightsInitializer function.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerWeightsInitializer", "unsupported_type")
%!error<ClassificationNeuralNetwork: LayerBiasesInitializer must be a string.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerBiasesInitializer", 123)
%!error<ClassificationNeuralNetwork: unsupported LayerBiasesInitializer function.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LayerBiasesInitializer", "unsupported_type")
%!error<ClassificationNeuralNetwork: InitialStepSize must be a positive scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "InitialStepSize", -1)
%!error<ClassificationNeuralNetwork: InitialStepSize must be a positive scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "InitialStepSize", 0)
%!error<ClassificationNeuralNetwork: InitialStepSize must be a positive scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "InitialStepSize", [1, 2])
%!error<ClassificationNeuralNetwork: InitialStepSize must be a positive scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones (10,1), "InitialStepSize", "invalid")
%!error<ClassificationNeuralNetwork: IterationLimit must be a positive integer.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "IterationLimit", -1)
%!error<ClassificationNeuralNetwork: IterationLimit must be a positive integer.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "IterationLimit", 0.5)
%!error<ClassificationNeuralNetwork: IterationLimit must be a positive integer.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "IterationLimit", [1,2])
%!error<ClassificationNeuralNetwork: GradientTolerance must be a non-negative scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "GradientTolerance", -1)
%!error<ClassificationNeuralNetwork: GradientTolerance must be a non-negative scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "GradientTolerance", [1,2])
%!error<ClassificationNeuralNetwork: LossTolerance must be a non-negative scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LossTolerance", -1)
%!error<ClassificationNeuralNetwork: LossTolerance must be a non-negative scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "LossTolerance", [1,2])
%!error<ClassificationNeuralNetwork: StepTolerance must be a non-negative scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "StepTolerance", -1)
%!error<ClassificationNeuralNetwork: StepTolerance must be a non-negative scalar.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "StepTolerance", [1,2])
%!error<ClassificationNeuralNetwork: invalid parameter name in optional pair arguments.> ...
%! ClassificationNeuralNetwork (ones(10,2), ones(10,1), "some", "some")
%!error<ClassificationNeuralNetwork: invalid values in X.> ...
%! ClassificationNeuralNetwork ([1;2;3;'a';4], ones (5,1))
%!error<ClassificationNeuralNetwork: invalid values in X.> ...
%! ClassificationNeuralNetwork ([1;2;3;Inf;4], ones (5,1))
%!error<ClassificationNeuralNetwork: the elements in 'Prior' do not correspond to selected classes in Y.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "Prior", [1 2])
%!error<ClassificationNeuralNetwork: the number of rows and columns in 'Cost' must correspond to the selected classes in Y.> ...
%! ClassificationNeuralNetwork (ones (5,2), ones (5,1), "Cost", [1 2; 1 3])

## Test input validation for predict method
%!error<ClassificationNeuralNetwork.predict: too few input arguments.> ...
%! predict (ClassificationNeuralNetwork (ones (4,2), ones (4,1)))
%!error<ClassificationNeuralNetwork.predict: XC is empty.> ...
%! predict (ClassificationNeuralNetwork (ones (4,2), ones (4,1)), [])
%!error<ClassificationNeuralNetwork.predict: XC must have the same number of features> ...
%! predict (ClassificationNeuralNetwork (ones (4,2), ones (4,1)), 1)
