# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Granulocyte_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1726439","GSM1726472","GSM1726455","GSM1726441","GSM2112213","GSM1726461","GSM1726447","GSM1726471","GSM1726442","GSM1726467","GSM1726465","GSM1726474","GSM1726443","GSM1726476","GSM1726450","GSM1726470","GSM1726473","GSM1726458","GSM2112216","GSM1726444","GSM1726459","GSM1726475","GSM1726445","GSM1726449","GSM1726463","GSM1726454","GSM1726452","GSM2112214","GSM2112217","GSM1726456","GSM1726466",
"GSM1726462","GSM1726440","GSM1726457","GSM2112212","GSM1726468","GSM2112211","GSM1726451","GSM2112215","GSM1726464","GSM1726453","GSM1726460","GSM1726446","GSM1726448","GSM1726469","GSM3405604","GSM3405605","GSM3405606","GSM3405607","GSM3405608","GSM3335818","GSM3335819","GSM3335820","GSM3335821","GSM3335822","GSM3335823","GSM3335824","GSM3335825","GSM3335826","GSM3335827","GSM3335828",
"GSM3335829","GSM3335830","GSM3335831","GSM3335832","GSM3335833","GSM3335834","GSM3335835","GSM3335836","GSM3335837","GSM3335838","GSM3335839","GSM3307565","GSM3307569","GSM3386918","GSM3386919","GSM4117948","GSM4117949","")

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

