library("Benchmarking");library("downloader");library("xlsx");library(ggplot2);
setwd("/home/klinsman/DEA"); # set work directory
data=read.xlsx("dados.xlsx",header=TRUE,startRow=1, sheetIndex=1) # read spreadsheet
Names=as.character(data[["DMUs"]]) # DMU names
FractalDim=data[["FractalDim"]] #Fractal Dimension - Rodogram method
TimeTakenForTests = data[["TimeTakenForTests"]]
TimePerRequest =  data[["TimePerRequest"]]
TransferRate = data[["TransferRate"]]
Hurst = data[["Hurst"]]
RequestsPerSecond = data[["RequestsPerSecond"]]

dataMatrix=cbind(FractalDim,TimeTakenForTests,TimePerRequest,TransferRate,Hurst,RequestsPerSecond) # creates the data matrix
rownames(dataMatrix)=Names # drop the no data rows in dataMatrix
delete.na <- function(DF, n=0) {
DF[rowSums(is.na(DF)) <= n,]
}
data_dea = delete.na(dataMatrix) #creates the data_dea table
inputs = data_dea[,c(1,6,2,3)] # select only input variables values
outputs = data_dea[,c(4,5)] # select only output variables values, SLACK=TRUE
CCR_I=dea(inputs,outputs,RTS="CRS",ORIENTATION="IN", SLACK=TRUE)
# runs input-oriented CCR DEA model
SCCR_I=sdea(inputs,outputs,RTS="CRS",ORIENTATION="IN")
# runs super-efficiency input-oriented CCR DEA model
CCR_O=dea(inputs,outputs,RTS="CRS",ORIENTATION="OUT", SLACK=TRUE)

bestDMU = which.max(SCCR_I$eff)
badDMU = which.min(SCCR_I$eff)

print("A DMU mais eficiente segundo o modelo DEA:")
print(bestDMU)
print("A DMU menos eficiente segundo o modelo DEA:")
print(badDMU)

# data.frame(SCCR_I$eff)
dea.plot(inputs,outputs,RTS="crs",ORIENTATION="in");
# write.xlsx2(SCCR_I$eff, file='eficiencia.xlsx') #exporta os dados de eficiencia
