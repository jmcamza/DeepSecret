# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "RPMI8226_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2375019","GSM2375018","GSM2375020","GSM2375026","GSM2375027","GSM2375025","GSM2375028","GSM2375017","GSM2334826","GSM2334827","GSM2334828","GSM2718776","GSM2718777","GSM2718778","GSM2718779","GSM4156298","GSM4156299","GSM4156300","GSM4156301","GSM4891342","GSM4891343","GSM4891344","GSM4891346","GSM4891347","GSM4891348","GSM4891349","GSM4891350","GSM4891351","GSM4891352","GSM4891353","GSM4891354",
"GSM4798742","GSM4798743","GSM4798744","GSM4798745","GSM4798746","GSM4798747","GSM4798748","GSM4798749","GSM4798750","GSM4798751","GSM4798752","GSM4798753","GSM4798754","GSM4798755","GSM4798756","GSM4798757","GSM4798758","GSM4798759","GSM4798760","GSM4798761","GSM4798762","GSM4798763","GSM4798764","GSM4798765","GSM4798766","GSM4798767","GSM4798768","GSM4798769","GSM4798770","GSM4798771",
"GSM4798772","GSM4798773","GSM4798774","GSM4798775","GSM4798776","")

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

