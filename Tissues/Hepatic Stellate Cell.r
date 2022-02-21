# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Hepatic Stellate Cell_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1663082","GSM1663088","GSM1663079","GSM1663087","GSM1663080","GSM1663090","GSM1663089","GSM1663081","GSM2470222","GSM2470221","GSM2470220","GSM2470223","GSM2701558","GSM2701559","GSM2701560","GSM2701561","GSM2701562","GSM2042148","GSM2042149","GSM2042150","GSM2042151","GSM2042152","GSM2042153","GSM2079611","GSM2079612","GSM2079613","GSM2079614","GSM2079615","GSM2079616","GSM2079617","GSM2079618",
"GSM3378746","GSM3378747","GSM3378748","GSM3378749","GSM3378750","GSM3378751","GSM3378752","GSM3378753","GSM3378754","GSM3378755","GSM3378756","GSM3378757","GSM3378758","GSM3378759","GSM3378760","GSM3532161","GSM3532162","GSM3532163","GSM3532164","GSM3357028","GSM3357029","GSM3357030","GSM3357031","GSM3357032","GSM3357033","GSM3357034","GSM3357035","GSM3357036","GSM3357037","GSM3357038",
"GSM3357039","GSM3357040","GSM3357041","GSM3357042","GSM3357043","GSM3357044","GSM3357045","GSM3357046","GSM3357047","GSM3357048","GSM3291091","GSM3291092","GSM3291093","GSM3291094","GSM3291095","GSM3291096","GSM3291097","GSM3291098","GSM3291099","GSM3291100","GSM3291101","GSM3291102","GSM3291103","GSM3291104","GSM3291105","GSM3291106","GSM3291107","GSM3291108","GSM3291109","GSM3291110",
"GSM3291111","GSM3291112","GSM3291113","GSM3291114","GSM3291115","GSM3291116","GSM3291117","GSM3291118","GSM3291119","GSM3291120","GSM3688678","GSM3688679","GSM3688680","GSM3688681","GSM3688682","GSM3688683","GSM3658064","GSM3658065","GSM3658066","GSM3658067","GSM3658068","GSM3658069","GSM3658070","GSM3658071","GSM3658072","GSM3658073","GSM3658074","GSM3658075","GSM4117775","GSM4117776",
"GSM4117777","")

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

