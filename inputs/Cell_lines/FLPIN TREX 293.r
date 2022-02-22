# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "FLPIN TREX 293_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2026223","GSM2026222","GSM2026232","GSM2026229","GSM2026225","GSM2026227","GSM2026224","GSM2026230","GSM2026226","GSM2026228","GSM2026221","GSM2026231","GSM2098536","GSM2098537","GSM2098538","GSM2098539","GSM2098540","GSM2098541","GSM2098542","GSM2098543","GSM2098544","GSM2454445","GSM2454446","GSM2454447","GSM2454448","GSM2454449","GSM2454450","GSM2454451","GSM2454452","GSM2454453","GSM2454454",
"GSM2454455","GSM2454456","GSM2643803","GSM2643804","GSM2643805","GSM2643806","GSM2643807","GSM2643808","GSM2838588","GSM2838589","GSM2838590","GSM2838591","GSM2838592","GSM2838593","GSM2838594","GSM2838595","GSM2838596","GSM2838597","GSM2838598","GSM2836657","GSM2836658","GSM2836659","GSM2836660","GSM2836661","GSM2836662","GSM2836663","GSM2836664","GSM2836665","GSM2644764","GSM2644765",
"GSM2644769","GSM2644770","GSM2644772","GSM2836644","GSM2836645","GSM2836646","GSM2836654","GSM2836669","GSM2836672","GSM2836674","GSM3474011","GSM3474012","GSM3474013","GSM3474014","GSM3474015","GSM3474016","GSM3474017","GSM3474018","GSM3474019","GSM3474020","GSM3474021","GSM3474022","GSM3509448","GSM3509449","GSM3509450","")

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

