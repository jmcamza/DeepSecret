# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "REH_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1695888","GSM1695880","GSM1649160","GSM1649159","GSM1695891","GSM1695889","GSM1695883","GSM1695884","GSM1695896","GSM1695902","GSM1649157","GSM1383566","GSM1649155","GSM1383565","GSM1695904","GSM1649156","GSM1695897","GSM1695885","GSM1695899","GSM1695903","GSM1649161","GSM1695881","GSM1695894","GSM1695887","GSM1695882","GSM1695893","GSM1695901","GSM1649158","GSM1695895","GSM1695886","GSM1695892",
"GSM1695900","GSM1695898","GSM1649162","GSM1695890","GSM2107714","GSM1320483","GSM2584723","GSM2584724","GSM2864660","GSM2864661","GSM2864662","GSM2864663","GSM2864664","GSM2864665","GSM2107716","GSM2107717","GSM2107718","GSM2107719","GSM2107720","GSM2107721","GSM2107722","GSM2107723","GSM2107724","GSM2107725","GSM2107726","GSM2107727","GSM2107728","GSM2107729","GSM2107730","GSM2107731",
"GSM2107732","GSM2107733","GSM2107734","GSM2107735","GSM2107736","GSM2107737","GSM2107738","GSM2107739","GSM2107740","GSM2107741","GSM2107742","GSM2373685","GSM2373686","GSM2373687","GSM2373688","GSM2373689","GSM2373690","GSM2901697","GSM2699689","GSM2699690","GSM2971580","GSM2971581","GSM2971582","GSM2971583","GSM2971584","GSM2971585","GSM2971586","GSM3517494","GSM3517495","GSM3517496",
"GSM3517497","GSM3517498","GSM3517499","GSM3692515","GSM3892277","GSM3892278","GSM3892279","GSM3892280","GSM3892281","GSM3892282","GSM3892283","GSM3892284","GSM3892285","GSM3892286","GSM3892287","GSM4626012","GSM4626013","GSM4627142","GSM4627143","GSM4627144","GSM4627145","GSM4627146","GSM4627147","GSM4191861","GSM4117213","GSM4117215","GSM4191856","GSM4191857","GSM4191858","GSM4191859",
"GSM4191860","GSM4473094","GSM4473095","GSM4473096","GSM4473097","GSM4473098","GSM4473099","GSM4473100","GSM4473101","GSM4473102","GSM4473103","GSM4473104","GSM4473105","GSM4928803","GSM4928804","GSM4928805","GSM4928806","GSM4928807","GSM4928808","GSM4995553","GSM4995554","GSM4995555","GSM4995556","GSM4995557","GSM4995558","GSM4995559","GSM4995566","GSM4995567","GSM4995570","GSM4995573",
"GSM4995574","GSM4996075","GSM4996076","GSM4996079","GSM4996080","GSM4996081","GSM4996082","GSM5444414","GSM5444415","GSM5444416","GSM5444417","")

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

