# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Chondrocyte_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1914782","GSM1914779","GSM1556293","GSM1914777","GSM1914780","GSM1914781","GSM1914778","GSM2072460","GSM2072461","GSM2875106","GSM2875107","GSM2875108","GSM2875109","GSM2875110","GSM3004019","GSM3004020","GSM4240745","GSM4240746","GSM4240747","GSM4891061","GSM4891062","GSM4891063","GSM4891064","GSM4891065","GSM4891066","GSM4891067","GSM4891068","GSM4891069","GSM4891070","GSM4891071","GSM4891072",
"GSM4891073","GSM4891074","GSM4891075","GSM4891076","GSM4891077","GSM4891078","GSM4891079","GSM4891080","GSM4891081","GSM4891082","GSM4891083","GSM4891084","GSM4891115","GSM4891116","GSM4891117","GSM4891118","GSM4891119","GSM4891120","GSM4891121","GSM4891122","GSM4891123","GSM4891124","GSM4891126","GSM4891127","GSM4891128","GSM4891129","GSM4117951","GSM4602752","GSM4602753","GSM4602754",
"GSM4953163","GSM4953164","GSM4953165","GSM4953166","GSM4953167","GSM4953168","GSM4953169","GSM4953170","GSM4953171","GSM4953172","GSM4953173","GSM4953175","GSM4953176","GSM4953177","GSM4953178","GSM4953179","GSM4953180","GSM4953181","GSM4953182","GSM4953183","GSM4953184","GSM4953185","GSM4953186","GSM4953187","GSM4953188","GSM4953189","GSM4953190","GSM4953191","GSM4953192","GSM4953193",
"GSM4953194","GSM4953195","GSM4953196","GSM4953197","GSM4953198","GSM4953199","GSM4953200","GSM4953201","GSM4953202","GSM4953204","GSM4953205","GSM4953206","GSM4953207","GSM4953208","GSM4953210","GSM4953211","GSM4953212","GSM4953213","GSM4953214","GSM4953215","GSM4953216","GSM4953217","GSM4953218","GSM4953219","GSM4953220","GSM4953221","GSM4953222","GSM5252005","GSM5252006","GSM5252007",
"GSM5252008","GSM5252009","GSM5378689","GSM5378690","GSM5378691","")

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

