# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Blymphocyte_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1395234","GSM2528066","GSM2528067","GSM2528068","GSM2528069","GSM3119575","GSM3119576","GSM3119577","GSM3119578","GSM3119579","GSM3119580","GSM3119581","GSM3119582","GSM3119583","GSM3119584","GSM3119585","GSM3119586","GSM3405812","GSM3405813","GSM3405814","GSM3405815","GSM3405816","GSM3405817","GSM3356771","GSM3356772","GSM3356773","GSM3356774","GSM3356775","GSM3356776","GSM3356777","GSM3356778",
"GSM3356779","GSM3356780","GSM3356781","GSM3356782","GSM3356783","GSM3356784","GSM3356785","GSM3356786","GSM3965499","GSM3965500","GSM3526456","GSM3526457","GSM3526458","GSM3526459","GSM3526460","GSM3526461","GSM3526462","GSM3526463","GSM4198779","GSM4198780","GSM4198781","GSM4198782","GSM4796772","GSM4796773","GSM4796774","GSM4796775","GSM4796776","GSM4796777","GSM4796778","GSM4796779",
"GSM4888716","GSM4888717","GSM4888718","GSM4888719","GSM4888720","GSM4888721","GSM4888722","GSM4888723","GSM4888724","GSM4888725","GSM4888726","GSM4888727","GSM4888728","GSM4888729","GSM4888730","GSM4888731","GSM4888732","GSM4888733","GSM4888734","GSM4888735","GSM4888736","GSM4888737","GSM4888738","GSM4888739","GSM4888740","GSM4888741","GSM4888742","GSM4888743","GSM4888744","GSM4888745",
"GSM4888746","GSM4888747","GSM2304965","GSM2304966","GSM2304967","GSM2304968","GSM2304969","GSM2304970","GSM4489547","GSM4489548","GSM4489549","GSM4489551","GSM4489552","")

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

