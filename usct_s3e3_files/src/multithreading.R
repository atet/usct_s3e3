library(parallel)
parallel::detectCores() # Very generous for free account, Posit Cloud <3

sleep = function(seconds){
  cat("Sleeping for", seconds, "second(s)...\n")
  for(x in seconds:1){
    cat(x,"...\n", sep = "")
    Sys.sleep(1)
  }
  cat("Waking up!\n")
  return(seconds)
}

sleep(1)
sleep(2)
sleep(3)

system.time({
  sleep(4)
}) # ~4 seconds

# Singlethreaded sequential execution
system.time({
  single = lapply(1:4, sleep)
}) # ~10 seconds

# Multithreading in R for Linux (Posit Cloud is hosted on Linux)
system.time({
  multi = mclapply(1:4, sleep, mc.cores = 4)
}) # ~4 seconds!

identical(single, multi) # TRUE, identical results

###

# Multithreading in R for Windows (also works in Linux)
cluster = makePSOCKcluster(c(rep("localhost", 4)))
system.time({
  multi_windows = parLapplyLB(cluster, 1:4, sleep)
}) # ~4 seconds!

identical(multi, multi_windows) # TRUE, identical results
