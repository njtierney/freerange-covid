
# freerange-covid-drake

<!-- badges: start -->
<!-- badges: end -->

This is a repository based on [Peter Ellis's](http://freerangestats.info/covid-tracking/index.html) excellent blog post on tracking covid19 in Australia. It is being wrapped up in `capsule`, and `drake`, to demonstrate the process of converting an existing R project into a reproducible workflow.

To run the project with the same versions of R packages as me, I recommend using `capsule` - you can install it like so:

```r
# install.packages("remotes")
remotes::install_github("milesmcbain/capsule")
```

Then run:

```r
capsule::reproduce_lib()
```

This reproduces the libraries from the `renv.lock` file

Then you run

```r
capsule::run(drake::r_make())
```

You can view the output of the models in the `doc` folder. Note that the number of iterations, chains, and computer cores might need to be specified by you - currently the number of iterations is set to be low to make it easy to check it works.

To run the drake workflow using the same R package versions.

You can alternatively just run

```r
drake::r_make()
```

However, this might fail due to things like different R package versions.