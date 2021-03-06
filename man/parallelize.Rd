% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parallelize.R
\name{parallelize}
\alias{parallelize}
\title{Setup parallel processing, either multinode or multicore.}
\usage{
parallelize(type = "any", max_cores = NULL, allow_multinode = T,
  machine_list = Sys.getenv("SLURM_NODELIST"),
  cpus_per_node = as.numeric(Sys.getenv("SLURM_CPUS_ON_NODE")),
  outfile = "", verbose = F)
}
\arguments{
\item{type}{"any", "cluster"/"doSNOW", "doParallel", "doMC", or "seq"}

\item{max_cores}{Restrict to this many cores, even if more are available.}

\item{allow_multinode}{If T will use multiple nodes if detected. If F will
not use multiple machines even if they are available.}

\item{machine_list}{List of networked computers for multinode computation.}

\item{cpus_per_node}{Number of processes to run on each node, if using
multinode parallelization.}

\item{outfile}{File to collect output across workers. IF "" then results are
printed to the console.}

\item{verbose}{If TRUE display additional output during execution.}
}
\value{
obj Cluster object that can be passed to stop_cluster().
}
\description{
By default it uses a multinode cluster if available, otherwise sets up multicore via doMC.
Libraries required: parallel, doSNOW, doMC, RhpcBLASctl, foreach
}
\seealso{
stop_cluster
}
