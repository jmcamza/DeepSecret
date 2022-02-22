# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Granulosa_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1131197","GSM1131193","GSM1131192","GSM1131195","GSM1215102","GSM1215105","GSM1131194","GSM1215104","GSM1215106","GSM1131196","GSM1215103","GSM1519571","GSM1519563","GSM1519568","GSM1519566","GSM1519562","GSM1519560","GSM1519567","GSM1519570","GSM1519564","GSM1519565","GSM1519561","GSM1519569","GSM2877888","GSM2877889","GSM2877890","GSM2877891","GSM2877892","GSM2877893","GSM2877895","GSM2877896",
"GSM2877897","GSM2877898","GSM2877899","GSM2877900","GSM2877901","GSM2877902","GSM2877903","GSM2877904","GSM2877905","GSM2877906","GSM2877907","GSM2877908","GSM2877909","GSM2877910","GSM2877911","GSM2877912","GSM2877913","GSM2877914","GSM2877915","GSM2877916","GSM2877917","GSM2877918","GSM2877919","GSM2877920","GSM2877921","GSM2877922","GSM2877923","GSM2877924","GSM2877925","GSM2877926",
"GSM2877927","GSM2877928","GSM2877929","GSM2877930","GSM2877931","GSM2877932","GSM2877933","GSM2877934","GSM2877935","GSM2877936","GSM2877937","GSM2877938","GSM2877939","GSM2877940","GSM2877941","GSM2877942","GSM2877943","GSM2877944","GSM2877945","GSM2877946","GSM2877947","GSM2877948","GSM2877949","GSM2877950","GSM2877951","GSM2877952","GSM2877953","GSM2877954","GSM2877955","GSM2877956",
"GSM2877957","GSM2877958","GSM3560280","GSM3560281","GSM4162514","GSM4162515","GSM4162516","GSM4162517","GSM4162518","GSM4162519","GSM4162520","GSM4162521","GSM4162522","GSM4162523","GSM4162524","GSM4162525","GSM4905064","GSM4905065","GSM4905066","GSM5071253","GSM5071254","GSM5071255","GSM5071256","GSM5071257","GSM5071258","GSM5071259","GSM5071260","GSM5134106","GSM5134108","GSM5134110",
"GSM5134111","")

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

