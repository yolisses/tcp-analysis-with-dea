library(fractaldim);
library(pracma);
pathStart = '/home/yolisses/IFPB/LabRedes/projeto final/treated/stats'
setwd(pathStart)
files = list.files(path=pathStart, pattern='timeseries')

for(file in files){
    readed = scan(file)

    # Hurst
    hurst = hurstexp(readed, display=FALSE)[["Hs"]]
    message("Hurst ", file, ': ', hurst)
    hurst_filename = paste("hurst", file, sep="_")

    # Fractal
    fractal = fd.estimate(readed, methods='madogram')[["fd"]][1]
    message("Fractal ", file, ': ', fractal)
    fractal_filename = paste("fractal", file, sep="_")
    writeLines(toString(fractal), fractal_filename)
}
