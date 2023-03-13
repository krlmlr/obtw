<!-- README.md is generated from README.Rmd. Please edit that file -->

# obtw

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

Oh, by the way: the goal of this package is to offer a set of lightweight tools to simplify data checks in a pipeline.

This package provides two convenience features for working with data transformation pipelines:

- A stack, for pushing the current result and retrieving it for later use

- A validation framework, for reporting multiple failures in a pipeline

## Installation

You can install the development version of obtw like so:

<pre class='chroma'>
<span><span class='nf'>pak</span><span class='nf'>::</span><span class='nf'><a href='http://pak.r-lib.org/reference/pak.html'>pak</a></span><span class='o'>(</span><span class='s'>"krlmlr/obtw"</span><span class='o'>)</span></span></pre>

(Follow the [installation instructions](https://pak.r-lib.org/#arrow_down-installation) to install pak.)

## Checking one or multiple conditions

<pre class='chroma'>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/krlmlr/obtw'>obtw</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>test_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>a <span class='o'>=</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>3</span>, b <span class='o'>=</span> <span class='m'>2</span><span class='o'>:</span><span class='m'>4</span>, c <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span></span>
<span><span class='c'># Success returns the input unchanged:</span></span>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>a</span> <span class='o'>&lt;=</span> <span class='m'>3</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;   a b c</span></span>
<span><span class='c'>#&gt; 1 1 2 1</span></span>
<span><span class='c'>#&gt; 2 2 3 1</span></span>
<span><span class='c'>#&gt; 3 3 4 1</span></span>
<span></span>
<span><span class='c'># Failure triggers an error:</span></span>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>a</span> <span class='o'>&lt;</span> <span class='m'>3</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> 1 rows failed check: a &lt; 3</span></span>
<span></span>
<span><span class='c'># Multiple failures are collected and reported together:</span></span>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>a</span> <span class='o'>&lt;</span> <span class='m'>3</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>b</span> <span class='o'>&gt;</span> <span class='m'>0</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>b</span> <span class='o'>&lt;</span> <span class='m'>4</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> 1 rows failed check: a &lt; 3</span></span>
<span><span class='c'>#&gt; 1 other failing check(s):</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> 1 rows failed check: b &lt; 4</span></span></pre>

## Integrate with other pipe-friendly checking packages

<pre class='chroma'>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>a</span> <span class='o'>&lt;</span> <span class='m'>3</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>dm</span><span class='nf'>::</span><span class='nv'><a href='https://dm.cynkra.com/reference/check_key.html'>check_key</a></span><span class='o'>)</span><span class='o'>(</span><span class='nv'>c</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>ensurer</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/ensurer/man/ensures_that.html'>ensure</a></span><span class='o'>)</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='nv'>.</span><span class='o'>)</span> <span class='o'>==</span> <span class='m'>4</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>pointblank</span><span class='nf'>::</span><span class='nv'><a href='https://rich-iannone.github.io/pointblank/reference/col_is_factor.html'>col_is_factor</a></span><span class='o'>)</span><span class='o'>(</span><span class='nv'>b</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>assertr</span><span class='nf'>::</span><span class='nv'><a href='https://docs.ropensci.org/assertr/reference/verify.html'>verify</a></span><span class='o'>)</span><span class='o'>(</span><span class='nv'>a</span> <span class='o'>&gt;</span> <span class='m'>7</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>assertive</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/assertive.properties/man/is_empty.html'>assert_is_of_length</a></span><span class='o'>)</span><span class='o'>(</span><span class='m'>2</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; verification [a &gt; 7] failed! (3 failures)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt;     verb redux_fn predicate column index value</span></span>
<span><span class='c'>#&gt; 1 verify       NA     a &gt; 7     NA     1    NA</span></span>
<span><span class='c'>#&gt; 2 verify       NA     a &gt; 7     NA     2    NA</span></span>
<span><span class='c'>#&gt; 3 verify       NA     a &gt; 7     NA     3    NA</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> 1 rows failed check: a &lt; 3</span></span>
<span><span class='c'>#&gt; 5 other failing check(s):</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> (`c`) not a unique key of `x`.</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> conditions failed for call 'rmarkdown::render(" .. encoding = "UTF-8")':</span></span>
<span><span class='c'>#&gt;   * nrow(.) == 4</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> Failure to validate that column `b` is of type: factor.</span></span>
<span><span class='c'>#&gt; The `col_is_factor()` validation failed beyond the absolute threshold level (1).</span></span>
<span><span class='c'>#&gt; * failure level (1) &gt;= failure threshold (1)</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> assertr stopped execution</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> is_of_length : x has length 3, not 2.</span></span></pre>

## Perform destructive tests on your data

<pre class='chroma'>
<span><span class='c'># Push with obtw_push(), continue working on your original data with obtw_pop():</span></span>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_push</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>assertive</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/assertive.numbers/man/is_equal_to.html'>assert_all_are_greater_than</a></span><span class='o'>)</span><span class='o'>(</span><span class='m'>1</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_pop</span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;   a b c</span></span>
<span><span class='c'>#&gt; 1 1 2 1</span></span>
<span><span class='c'>#&gt; 2 2 3 1</span></span>
<span><span class='c'>#&gt; 3 3 4 1</span></span>
<span></span>
<span><span class='c'># Report all failing checks:</span></span>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_push</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/nrow.html'>nrow</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>assertive</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/assertive.numbers/man/is_equal_to.html'>assert_all_are_greater_than</a></span><span class='o'>)</span><span class='o'>(</span><span class='m'>3</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>assertive</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/assertive.numbers/man/is_equal_to.html'>assert_all_are_less_than</a></span><span class='o'>)</span><span class='o'>(</span><span class='m'>7</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw</span><span class='o'>(</span><span class='nf'>assertive</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/assertive.numbers/man/is_divisible_by.html'>assert_all_are_even</a></span><span class='o'>)</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_pop</span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> is_greater_than : x are not all greater than 3.</span></span>
<span><span class='c'>#&gt; There was 1 failure:</span></span>
<span><span class='c'>#&gt;   Position Value                   Cause</span></span>
<span><span class='c'>#&gt; 1        1     3 less than or equal to 3</span></span>
<span><span class='c'>#&gt; 1 other failing check(s):</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB; font-weight: bold;'>&lt;error/obtw_error&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> is_even : x are not all even (tol = 2.22045e-14).</span></span>
<span><span class='c'>#&gt; There was 1 failure:</span></span>
<span><span class='c'>#&gt;   Position Value       Cause</span></span>
<span><span class='c'>#&gt; 1        1     3 indivisible</span></span>
<span></span>
<span><span class='c'># Combine with obtw_check_df():</span></span>
<span><span class='nv'>test_df</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_push</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>dplyr</span><span class='nf'>::</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarize</a></span><span class='o'>(</span>b <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>b</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_check_df</span><span class='o'>(</span><span class='nv'>b</span> <span class='o'>==</span> <span class='m'>2</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'>obtw_pop</span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> 1 rows failed check: b == 2</span></span></pre>
