# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "MRC5_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1085706","GSM1085707","GSM1574111","GSM1574110","GSM1915575","GSM1574106","GSM1574093","GSM1915577","GSM1574112","GSM1553086","GSM1574108","GSM1574109","GSM1574107","GSM1915571","GSM1574103","GSM1915576","GSM1915569","GSM1492879","GSM1574092","GSM1574101","GSM1574099","GSM1574089","GSM1574100","GSM1492877","GSM1915574","GSM1574095","GSM1574105","GSM1574091","GSM1915572","GSM1908513","GSM1574096",
"GSM1574094","GSM1574104","GSM1574098","GSM1574102","GSM1553087","GSM1574097","GSM1574090","GSM1908512","GSM1915570","GSM2056019","GSM2056020","GSM1492880","GSM2056021","GSM1492882","GSM1492881","GSM1492878","GSM1553085","GSM1915573","GSM2419222","GSM2419218","GSM2419223","GSM2419220","GSM2419221","GSM2419219","GSM2419226","GSM2419227","GSM2419229","GSM2419228","GSM2419225","GSM2419224",
"GSM2419230","GSM2443399","GSM2443400","GSM2443401","GSM2443402","GSM2443403","GSM2443404","GSM2443405","GSM2443406","GSM2443407","GSM2443408","GSM2443409","GSM2443410","GSM2443395","GSM2443396","GSM2443397","GSM2443398","GSM2152263","GSM2579109","GSM2579110","GSM2579111","GSM2579112","GSM2579113","GSM2579114","GSM4718629","GSM4718630","GSM4718631","GSM4718633","GSM4718635","GSM4718636",
"GSM4718637","GSM4718638","GSM4718639","GSM4718640","GSM4718641","GSM4718642","GSM4718643","GSM5360749","GSM5360751","GSM5360753","GSM5360755","")

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

