# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "HACAT_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM2112564","GSM2112562","GSM2112561","GSM2112565","GSM2112566","GSM2112560","GSM2112559","GSM2112563","GSM2742745","GSM2742746","GSM2742747","GSM2742748","GSM2742749","GSM2742750","GSM2742751","GSM2742752","GSM2742753","GSM2742754","GSM2742755","GSM2742756","GSM2742757","GSM2742758","GSM2742759","GSM2742760","GSM2991615","GSM2991616","GSM2991617","GSM2991618","GSM2991619","GSM2991620","GSM2860269",
"GSM2860270","GSM2860271","GSM2860272","GSM2860273","GSM2860274","GSM2860275","GSM2860276","GSM2860277","GSM2860278","GSM2860279","GSM2860280","GSM2860281","GSM2860282","GSM2860283","GSM2860284","GSM2860285","GSM2860286","GSM2860287","GSM2860288","GSM2860289","GSM2860290","GSM2860291","GSM2860292","GSM2977290","GSM3656267","GSM3656268","GSM3656269","GSM3656270","GSM3473309","GSM3473310",
"GSM3473311","GSM3473312","GSM3985840","GSM3985841","GSM3985843","GSM3985844","GSM4093599","GSM4093600","GSM4093601","GSM4093602","GSM4202173","GSM4202175","GSM4202176","GSM4202177","GSM4202178","GSM4202179","GSM4202180","GSM4202181","GSM4202182","GSM4202183","GSM4568364","GSM4568365","GSM4568366","GSM4568367","GSM4568368","GSM4568369","GSM4568370","GSM4202174","GSM4563816","GSM4563817",
"GSM4563819","GSM5233839","GSM5233840","GSM5233841","GSM5233842","GSM5233843","GSM5233844","GSM5403668","GSM5403669","GSM5403671","GSM5403672","GSM5403673","GSM5403674","GSM5403675","GSM5403676","GSM5403677","GSM5403679","GSM5414249","GSM5414250","GSM5414251","GSM5414253","GSM5473909","GSM5473910","GSM5473911","GSM5473912","GSM5473913","GSM5473914","")

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

