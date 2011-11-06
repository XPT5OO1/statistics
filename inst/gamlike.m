## -*- texinfo -*-
## @deftypefn {Function File} {@var{X} =} gamlike ([@var{A} @var{B}], @var{R})
## Calculates the negative log-likelihood function for the Gamma
## distribution over vector @var{R}, with the given parameters @var{A} and @var{B}.
## @seealso{gampdf, gaminv, gamrnd, gamfit}
## @end deftypefn

## Written by Martijn van Oosterhout <kleptog@svana.org> (Nov 2006)
## This code is public domain

function res = gamlike(P,K)

  if (nargin != 2)
    print_usage;
  endif

  a=P(1);
  b=P(2);

  res = -sum( log( gampdf(K, a, b) ) );
endfunction
