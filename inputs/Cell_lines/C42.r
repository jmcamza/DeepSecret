# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "C42_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1328164","GSM1863099","GSM2041041","GSM1863098","GSM1328163","GSM1863100","GSM2041042","GSM1863101","GSM1887293","GSM2432783","GSM2432781","GSM2080901","GSM2080902","GSM2080903","GSM2080904","GSM2080905","GSM2080906","GSM2080907","GSM2080908","GSM2080909","GSM2757490","GSM2757491","GSM2757492","GSM2757493","GSM2757494","GSM2757495","GSM2757496","GSM2757497","GSM2757498","GSM2757499","GSM2757500",
"GSM2757501","GSM2757502","GSM2757503","GSM2757504","GSM2757505","GSM2757506","GSM2757507","GSM2806793","GSM2806794","GSM2806795","GSM2806796","GSM2806797","GSM2256088","GSM2256126","GSM2256127","GSM2741781","GSM2741782","GSM2741783","GSM2741784","GSM2741785","GSM2741786","GSM3391626","GSM3391627","GSM3391628","GSM3145572","GSM3145590","GSM3145591","GSM3625570","GSM3625571","GSM3625572",
"GSM3625612","GSM3625613","GSM3625614","GSM2966327","GSM2966328","GSM2966329","GSM2966330","GSM2966331","GSM2966332","GSM2966333","GSM2966334","GSM2966335","GSM2966698","GSM3320204","GSM3371098","GSM3261462","GSM3261463","GSM3261464","GSM3261465","GSM3261466","GSM3261467","GSM3261468","GSM3261469","GSM3261470","GSM3261471","GSM3261472","GSM3261473","GSM3261474","GSM3261475","GSM3261476",
"GSM3261477","GSM3261478","GSM3261479","GSM3261480","GSM3261481","GSM3261482","GSM3261483","GSM3261484","GSM3261485","GSM3564281","GSM3564282","GSM3564283","GSM3590965","GSM3590966","GSM3590967","GSM3590968","GSM4118666","GSM4118667","GSM4118668","GSM4118669","GSM3017004","GSM3017005","GSM3017006","GSM3017007","GSM3017008","GSM3017009","GSM3315349","GSM3315350","GSM3315351","GSM3315352",
"GSM3315353","GSM3315354","GSM3315363","GSM3315364","GSM3315365","GSM3315366","GSM4562431","GSM4562432","GSM4562433","GSM4562434","GSM4562435","GSM4562436","GSM4562437","GSM4562438","GSM4562439","GSM4562440","GSM4562441","GSM4562442","GSM4301497","GSM4301498","GSM4301499","GSM4301500","GSM4301501","GSM4301502","GSM4301503","GSM4301504","GSM4640679","GSM4640680","GSM4640682","GSM4640683",
"GSM4640684","GSM4832424","GSM4832425","GSM4903843","GSM4903844","GSM4903845","GSM4903846","GSM4903847","GSM4903848","GSM4903849","GSM4903850","GSM4903851","GSM4903852","GSM4912744","GSM4912745","GSM4560352","GSM4560354","GSM4566097","GSM4566098","GSM4566099","GSM4566100","GSM4566101","GSM4566102","GSM4579505","GSM4579506","GSM4579507","GSM4579508","GSM4579509","GSM4579510","GSM4646343",
"GSM4646344","GSM4646345","GSM4646346","GSM4665713","GSM4665714","GSM4665715","GSM4665716","GSM4665717","GSM4665718","GSM4698170","GSM4698172","GSM4698173","GSM4698174","GSM4698175","GSM4802778","GSM4802779","GSM4802780","GSM4803672","GSM4803673","GSM4803674","GSM4803675","GSM4803676","GSM4803677","GSM4803678","GSM4803679","GSM4816379","GSM4816380","GSM4816381","GSM4816382","GSM4816383",
"GSM5517376","GSM5517377","GSM5517378","")

# Retrieve information from compressed data
samples = h5read(destination_file, "meta/samples/geo_accession")
genes = h5read(destination_file, "meta/genes/genes")

# Identify columns to be extracted
sample_locations = which(samples %in% samp)

# extract gene expression from compressed data
expression = t(h5read(destination_file, "data/expression", index=list(sample_locations, 1:length(genes))))
H5close()
rownames(expression) = genes
colnames(expression) = samples[sample_locations]

# Print file
write.table(expression, file=extracted_expression_file, sep="\t", quote=FALSE, col.names=NA)
print(paste0("Expression file was created at ", getwd(), "/", extracted_expression_file))
