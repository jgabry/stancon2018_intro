# stancon2018_intro
Materials for the StanCon 2018 Intro class for both R and Python users (thanks to @amaloney). 
See below for how to install an environment
that can run the notebooks.

**Other resources:**       
* See the reading-list.html or reading-list.pdf in this repo
* Aki Vehtari's model selection tutorial from StanCon 2018: https://github.com/avehtari/modelselection_tutorial
* Bob Carpenter's slides on MCMC convergence from StanCon 2018: http://mc-stan.org/workshops/stancon2018_intro/diagnosing-convergence.pdf

# Installation (macOS using `brew`)
We will be using `conda` to facilitate the creation of virtual environments,
and the handling of dependencies used in the introduction class. Below outlines
how to create an environment that will run notebooks for Jupyter or RStudio on
a `macOS` system.

1. Install [brew](https://brew.sh) if you have not already done so. We will be
   using it as our package manager for installing `miniconda`. If you do not
   want to install `brew` on your system, then follow the instructions on
   [Anaconda](https://conda.io/miniconda.html) for how to install `miniconda`
   on your system.

1. Install `miniconda` and update your `PATH` environment variable so that you
   have access to the newly installed `conda` package manager. `conda` is
   different than `brew` in that `conda` can create virtual environments that
   are segregated from your system environment.

   1. `brew install miniconda`
   1. Update your path by adding
      `export PATH=/usr/local/miniconda3/bin:$PATH` to the end of your
      `~/.bashrc` or `~/.bash_profile` file, and then sourcing it.

1. Clone the **StanCon2018 Intro** repository someplace on your machine and
   change directories into it.

   1. `git clone https://github.com/jgabry/stancon2018_intro`
   1. `cd stancon2018_intro`

1. Next we will install the conda virtual environment, which includes several
   packages: RStudio, Jupyter, a Python3 kernel for Jupyter, and an R kernel
   for Jupyter. Once the dependencies have been installed, we will need to
   activate the new virtual environment, so that we can access the newly
   installed packages.

   1. `conda env create --file environment.yml`
   1. Activate the new environment with `source activate StanCon2018_Intro`.

1. Start the notebook environment you are familiar with.

   1. **Jupyter**

      1. `jupyter notebook`
      1. Your default browser should navigate you to a page with the folder
         structure of this repository. Select the `jupyter_notebooks` folder
         and open either the `StanCon2018 Intro-Python3.ipynb` or the
         `StanCon2018 Intro-R.ipynb` notebook. The Python3 notebook should
         start with the Python3 kernel, while the R notebook should start with
         the R kernel.

   1. **RStudio**

      1. `rstudio`
      1. This will open the familiar RStudio platform.
