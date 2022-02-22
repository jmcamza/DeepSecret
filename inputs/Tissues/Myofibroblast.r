# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Myofibroblast_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1528137","GSM1528135","GSM1528139","GSM1528136","GSM1528138","GSM1528134","GSM2584709","GSM2584710","GSM2584711","GSM3673502","GSM3673503","GSM3673504","GSM3673505","GSM3673506","GSM3673507","GSM3673508","GSM3673509","GSM3673510","GSM3673511","GSM3673512","GSM3673513","GSM4162693","GSM4162694","GSM4162695","GSM4162696","GSM4162697","GSM4162698","GSM4861258","GSM4861259","GSM4861260","GSM4861261",
"GSM4861262","GSM4861263","GSM4861278","GSM4861279","GSM4861280","GSM4861281","GSM4861282","GSM4861283","GSM4861284","GSM4861285","GSM4861286","GSM4861287","GSM4861315","GSM4861316","GSM4861319","GSM4861320","GSM4861321","GSM4861322","GSM4861323","GSM4861324","GSM4861325","GSM5283747","GSM5283748","GSM5283749","GSM5283751","")

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

