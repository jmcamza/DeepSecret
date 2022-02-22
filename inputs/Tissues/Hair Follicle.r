# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Hair Follicle_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2072459","GSM2072458","GSM2703811","GSM2703812","GSM2703813","GSM2703814","GSM2703815","GSM2703816","GSM3717034","GSM3717035","GSM3717036","GSM3717037","GSM3717038","GSM3731086","GSM3731087","GSM3731088","GSM3731089","GSM3731090","GSM3731091","GSM3731092","GSM3731093","GSM3731094","GSM4491915","GSM4491916","GSM4491917","GSM4491918","GSM4491919","GSM4491920","GSM4491921","GSM4491922","GSM4820197",
"GSM4820198","GSM4820199","GSM4820200","GSM4820201","GSM4820202","GSM4820203","GSM4820204","GSM4820205","GSM4820206","GSM4820207","GSM4820208","GSM4820209","GSM4820210","GSM4820211","GSM4820212","GSM4820213","GSM4820214","GSM4820215","GSM4820216","GSM4820217","GSM4820218","GSM4820219","GSM4820220","")

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

