# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Motor Neuron_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1024416","GSM1024417","GSM1024418","GSM1261108","GSM1261111","GSM1261110","GSM1261105","GSM1314597","GSM1314596","GSM1314598","GSM1314599","GSM1261106","GSM1261109","GSM1261112","GSM1599013","GSM1599011","GSM1599012","GSM1599014","GSM1261107","GSM1314595","GSM2326820","GSM2326818","GSM2326822","GSM2326816","GSM2326819","GSM2326821","GSM2326817","GSM2496034","GSM2496035","GSM2496033","GSM2496036",
"GSM2590534","GSM2590524","GSM2590521","GSM2590535","GSM2590522","GSM2590531","GSM2590523","GSM2590536","GSM2590533","GSM2590525","GSM2590530","GSM2590532","GSM2590526","GSM2287020","GSM2287021","GSM2287022","GSM2287023","GSM2287024","GSM2287025","GSM2287026","GSM2287027","GSM2287028","GSM2287029","GSM2287030","GSM2287031","GSM2287032","GSM2287033","GSM2287034","GSM2287035","GSM2287036",
"GSM2287037","GSM2287038","GSM2287039","GSM2287040","GSM2287041","GSM2287042","GSM2287043","GSM2287044","GSM2287045","GSM2287046","GSM2287047","GSM2287048","GSM2287049","GSM2287050","GSM2287051","GSM2287052","GSM2287053","GSM2287054","GSM2287055","GSM2287056","GSM2287057","GSM2287058","GSM2287059","GSM2287060","GSM2287061","GSM2287062","GSM2287063","GSM2287064","GSM2287065","GSM2287066",
"GSM2287067","GSM2287068","GSM2287069","GSM2287070","GSM2287071","GSM2287074","GSM2287075","GSM2287076","GSM2287077","GSM2287078","GSM2287079","GSM2287080","GSM2287081","GSM2287082","GSM2287083","GSM2287084","GSM2287085","GSM2287086","GSM2287087","GSM2287088","GSM2287089","GSM2287090","GSM2287091","GSM2287092","GSM2287093","GSM2287094","GSM2590542","GSM2500595","GSM2500596","GSM3017282",
"GSM3017283","GSM3017284","GSM3017285","GSM3017286","GSM3017287","GSM3017288","GSM3017289","GSM3017290","GSM3017291","GSM3017292","GSM3017293","GSM3017294","GSM3017295","GSM3017296","GSM3425489","GSM3425491","GSM3425492","GSM3425493","GSM3425494","GSM3425495","GSM3425496","GSM3425497","GSM3425498","GSM3425499","GSM3425500","GSM3425501","GSM3425502","GSM3425503","GSM3425504","GSM3425505",
"GSM3425506","GSM3425507","GSM3425508","GSM3425509","GSM3425510","GSM3425511","GSM3425512","GSM3425513","GSM3425514","GSM3425515","GSM3425516","GSM3425517","GSM3425518","GSM3425519","GSM3425520","GSM3425521","GSM3425522","GSM3425523","GSM3425524","GSM3425525","GSM3425526","GSM3425527","GSM3425528","GSM3425529","GSM3425530","GSM3425531","GSM3425532","GSM3425533","GSM3425534","GSM3425535",
"GSM3425536","GSM3425537","GSM3425538","GSM3425539","GSM3425540","GSM3597692","GSM3597693","GSM3615519","GSM3615520","GSM3615521","GSM3615522","GSM3615523","GSM3615525","GSM3615526","GSM3615501","GSM3615502","GSM3615503","GSM3615504","GSM3615505","GSM3615506","GSM3615507","GSM3615508","GSM3615509","GSM3615510","GSM3615511","GSM3615512","GSM3615513","GSM3615514","GSM3615515","GSM3615516",
"GSM3615517","GSM3615518","GSM3615524","GSM3615527","GSM3615528","GSM3615529","GSM3615530","GSM3615531","GSM3615532","GSM3984340","GSM3984341","GSM3984342","GSM3984343","GSM3984344","GSM3984345","GSM2465363","GSM2465364","GSM2465365","GSM2465366","GSM2465367","GSM2465368","GSM2465369","GSM2465370","GSM2465371","GSM2465372","GSM2465385","GSM2465386","GSM2465387","GSM2465388","GSM4131935",
"GSM4131936","GSM4131937","GSM4131938","GSM4131939","GSM4131940","GSM4131941","GSM4131942","GSM4131943","GSM4131944","GSM4131945","GSM4131946","GSM4232905","GSM4232906","GSM4232907","GSM4232908","GSM4232909","GSM4232910","GSM4232911","GSM4232912","GSM4232913","GSM4232914","GSM4232915","GSM4232916","GSM4232917","GSM4232919","GSM4232920","GSM4273603","GSM4273604","GSM4273605","GSM4273606",
"GSM4273607","GSM4273608","GSM4273609","GSM4273610","GSM4273611","GSM4433049","GSM4433050","GSM4433051","GSM4433052","GSM4433053","GSM4433054","GSM4433055","GSM4433056","GSM4433057","GSM4433058","GSM3965157","GSM3965159","GSM3965161","GSM3965162","GSM3965164","GSM3965166","GSM3965167","GSM3965169","GSM3965171","GSM3965173","GSM3965175","GSM3965176","GSM4090811","GSM4090812","GSM4090813",
"GSM4090814","GSM4090815","GSM4090816","GSM4090817","GSM4090818","GSM4090819","GSM4090820","GSM4090821","GSM4090822","GSM4090823","GSM4090824","GSM4090825","GSM4090826","GSM4100678","GSM4100679","GSM4100680","GSM4100681","GSM4100682","GSM4100683","GSM4100684","GSM4100685","GSM4100686","GSM4100687","GSM4100688","GSM4100689","GSM4100690","GSM4100691","GSM4100692","GSM4100693","GSM4100694",
"GSM4100695","GSM4100696","GSM4100697","GSM4100698","GSM4100699","GSM4100700","GSM4100701","GSM4232918","GSM4432558","GSM4432559","GSM4432560","GSM4432561","GSM4432562","GSM4432563","GSM4432564","GSM4432565","GSM4432566","GSM4432567","GSM4432568","GSM4432569","GSM4432570","GSM4432571","GSM4432572","GSM4432573","GSM4432574","GSM4432575","GSM4432576","GSM4432577","GSM4432578","GSM4432579",
"GSM2385557","GSM2385558","GSM2385559","GSM2385560","GSM2385563","GSM2385564","GSM2385565","GSM2385566","GSM2385567","GSM3230540","GSM3230543","GSM4766660","GSM4766661","GSM4766662","GSM4766663","GSM4766664","GSM4766665","GSM4766666","GSM4766667","GSM4766668","GSM4766669","GSM4766670","GSM4766671","GSM4766680","GSM4766681","GSM4766682","GSM4766683","GSM4766684","GSM4766685","GSM4766686",
"GSM4766687","GSM4766688","GSM4766689","GSM4766690","GSM4766691","GSM4766692","GSM4766693","GSM4766694","GSM4766695","GSM4766696","GSM4766697","GSM4766698","GSM4766699","GSM4766700","GSM4766701","GSM4766702","GSM4766703","GSM4766708","GSM4766709","GSM4766710","GSM4766711","GSM4766712","GSM4766713","GSM4766714","GSM4766715","GSM4766717","GSM4766718","GSM4766719","GSM4766720","GSM4766721",
"GSM4766722","GSM4766723","GSM4766724","GSM4766725","GSM4766726","GSM4766727","GSM4766728","GSM4766729","GSM4766730","GSM4766731","GSM4766733","GSM4766734","GSM4766735","GSM4766736","GSM4766737","GSM4766738","GSM4766739","GSM4766740","GSM4766741","GSM4766742","GSM4766743","GSM4766744","GSM4766745","GSM4766746","GSM4766747","GSM4766748","GSM4766749","GSM4766750","GSM4766751","GSM4766752",
"GSM4766753","GSM4766754","GSM4766755","GSM4766756","GSM4766757","GSM4766758","GSM4766759","GSM5171065","GSM5171066","GSM5171067","GSM5171068","GSM5171069","GSM5171070","GSM5171071","GSM5171072","GSM5171073","GSM5171074","GSM5171075","GSM5171076","GSM5171077","GSM5171078","GSM5171080","GSM5171081","GSM5171082","")

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
