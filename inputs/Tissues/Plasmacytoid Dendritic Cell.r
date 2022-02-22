# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Plasmacytoid Dendritic Cell_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2090439","GSM2090443","GSM2090448","GSM2090447","GSM2090440","GSM2090433","GSM2090442","GSM2090437","GSM2090435","GSM2090441","GSM2090434","GSM2090445","GSM2090432","GSM2090444","GSM2090446","GSM2090436","GSM2090438","GSM2228986","GSM2228987","GSM2228988","GSM2228989","GSM2228990","GSM2228991","GSM2228992","GSM2228993","GSM2228994","GSM2228995","GSM2228996","GSM2228997","GSM2228998","GSM2228999",
"GSM2229000","GSM2902781","GSM2902782","GSM2902783","GSM2902784","GSM2902785","GSM2902786","GSM2902787","GSM2902788","GSM2902789","GSM2902790","GSM2902791","GSM2902792","GSM2902793","GSM2902794","GSM2902795","GSM2902796","GSM2902797","GSM2902798","GSM2902799","GSM2902800","GSM2902801","GSM2902802","GSM2902803","GSM2902804","GSM2902805","GSM2902806","GSM2902807","GSM2902808","GSM2902809",
"GSM2902810","GSM3177889","GSM3177890","GSM3177891","GSM3177892","GSM3177893","GSM3177894","GSM3177895","GSM2859435","GSM2859464","GSM2859493","GSM2859527","GSM3506331","GSM3506332","GSM3506333","GSM4024061","GSM4024062","GSM4024063","GSM4024064","GSM4024065","GSM4024066","GSM4024067","GSM4024068","GSM4024069","GSM4024070","GSM4024071","GSM4024072","GSM4024073","GSM4024074","GSM4024075",
"GSM4024076","GSM4024077","GSM4024078","GSM4024079","GSM4024080","GSM4024081","GSM4024082","GSM4024083","GSM4024084","GSM4024085","GSM4024086","GSM4024087","GSM4024088","GSM4024089","GSM4024090","GSM4024091","GSM4024030","GSM4024031","GSM4024032","GSM4024033","GSM4024034","GSM4024035","GSM4024036","GSM4024037","GSM4024038","GSM4024039","GSM4024040","GSM4024041","GSM4024042","GSM4024043",
"GSM4024044","GSM4024045","GSM4024046","GSM4024047","GSM4024048","GSM4024049","GSM4024050","GSM4024051","GSM4024052","GSM4024053","GSM4024054","GSM4024055","GSM4024056","GSM4024057","GSM4024058","GSM4024059","GSM4024060","GSM4647991","GSM4647992","GSM4647994","GSM4647996","GSM4648002","GSM4648005","GSM4648008","GSM4648009","GSM4648036","GSM4648037","GSM4648039","GSM4648040","GSM4648041",
"GSM4648042","GSM4648043","GSM4648047","GSM4648048","GSM4715389","GSM4715390","GSM4715391","GSM4715392","")

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

