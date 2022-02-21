# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "DAOY_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1440299","GSM1440298","GSM1440297","GSM1440296","GSM1440301","GSM1440300","GSM2072517","GSM2072518","GSM2752676","GSM2752677","GSM2752678","GSM2752679","GSM3104156","GSM3104157","GSM3104158","GSM3104159","GSM3104160","GSM3104161","GSM3104162","GSM3104163","GSM3104164","GSM3104165","GSM3104166","GSM3104167","GSM3179791","GSM3179792","GSM3179793","GSM3179794","GSM3179795","GSM3179796","GSM3179797",
"GSM3179798","GSM3179799","GSM3977068","GSM3977069","GSM3977070","GSM3977071","GSM4471963","GSM4471964","GSM4471965","GSM4471966","GSM4471967","GSM4471968","GSM4561051","GSM4561052","GSM4561053","GSM4561054","GSM4561055","GSM4561056","GSM4548310","GSM4548311","GSM4548313","GSM4815806","GSM4815807","GSM4815808","GSM4815809","GSM4570163","")

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

