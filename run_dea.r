library("Benchmarking");

setwd('/home/yolisses/IFPB/LabRedes/projeto final/'); # set work directory
data=read.csv("stats/stats.csv", header=TRUE) # read spreadsheet
print(data)

inputs = data[,c(
    'fractal',
    'time_per_req',
    'time_taken_for_tests'
)]
print(inputs)

outputs = data[,c(
    'hurst',
    'req_per_sec',
    'transfer_rate'
)]
print(outputs)

efficiencies = sdea(inputs, outputs, RTS="CRS", ORIENTATION="in")$eff
bestDMU = which.max(efficiencies)
worstDMU = which.min(efficiencies)

names = data[["dmu"]]
message("A DMU mais eficiente: ", names[bestDMU])
message("A DMU menos eficiente: ", names[worstDMU])

# dea.plot(inputs,outputs,RTS="crs",ORIENTATION="in");
# write.csv(efficiencies, file='efficiencies.csv')
