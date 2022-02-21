# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Sensory Neuron_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1511120","GSM1511118","GSM1511119","GSM2862288","GSM2862289","GSM2862290","GSM2862291","GSM2862292","GSM2862293","GSM3496100","GSM3496101","GSM3496102","GSM3496103","GSM3496104","GSM3496105","GSM3496106","GSM3496107","GSM3496108","GSM3496109","GSM3496110","GSM3496111","GSM3496112","GSM3496113","GSM3496114","GSM3496115","GSM4135904","GSM4135905","GSM4135906","GSM4135907","GSM4135908","GSM4135909",
"GSM4135910","GSM4135911","GSM4135912","GSM4282811","GSM4282812","GSM4282813","GSM4282814","GSM4282815","GSM4282816","GSM4282817","GSM4282818","GSM4282819","GSM4282820","GSM4282821","GSM4282822","GSM4282823","GSM4282824","GSM4282825","GSM4282826","GSM4282830","GSM4282831","GSM4282832","GSM4282833","GSM4282834","GSM4282835","GSM4282836","GSM4282837","GSM4282838","GSM4282839","GSM4282840",
"GSM4282841","")

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

