# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "HT29_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1019741","GSM1019735","GSM1019738","GSM1019739","GSM1019742","GSM1019740","GSM1019736","GSM1019737","GSM1019743","GSM2042937","GSM1398738","GSM2042930","GSM1398732","GSM2042934","GSM2042941","GSM2042946","GSM1398741","GSM1398736","GSM1398737","GSM1398734","GSM1890692","GSM2042916","GSM1700896","GSM2042920","GSM1398733","GSM1700902","GSM1398740","GSM1700900","GSM2042919","GSM1398739","GSM2042921",
"GSM2042926","GSM1890691","GSM1398742","GSM2042922","GSM1700897","GSM1890707","GSM1890687","GSM1890711","GSM2042932","GSM1398731","GSM2042917","GSM2042947","GSM1890709","GSM1890706","GSM2042948","GSM1890686","GSM2042933","GSM2042943","GSM1700903","GSM1700898","GSM1700899","GSM2042931","GSM2042936","GSM2042924","GSM1890685","GSM1890690","GSM1890693","GSM2042923","GSM2042945","GSM2042927",
"GSM1890708","GSM2042942","GSM1890688","GSM2042918","GSM2042944","GSM2042935","GSM1890710","GSM2042939","GSM2042938","GSM2042940","GSM2042929","GSM1890689","GSM1700901","GSM1528204","GSM1528201","GSM1528203","GSM1432898","GSM1528198","GSM1432895","GSM1528212","GSM1432897","GSM1528213","GSM1528200","GSM1528206","GSM1528209","GSM1528205","GSM1528207","GSM1528210","GSM1528202","GSM1432896",
"GSM1528208","GSM1528211","GSM1528199","GSM1398735","GSM1700895","GSM2042928","GSM2072613","GSM2072614","GSM2071575","GSM2071574","GSM2152360","GSM2152357","GSM2152359","GSM2152358","GSM2517978","GSM2517977","GSM2414778","GSM2458808","GSM2458809","GSM2458810","GSM2458811","GSM3102847","GSM3102848","GSM3102849","GSM3102850","GSM3102851","GSM3102852","GSM3102853","GSM3102854","GSM3102855",
"GSM3102856","GSM3102857","GSM3102858","GSM2885018","GSM2885019","GSM2885020","GSM2885021","GSM2885022","GSM2885023","GSM2417927","GSM2417928","GSM2417929","GSM2417930","GSM2417931","GSM2417932","GSM3615707","GSM3615708","GSM3615709","GSM3615710","GSM3109276","GSM3109277","GSM3109278","GSM3109279","GSM3109280","GSM3109281","GSM3109282","GSM3109283","GSM3109284","GSM3109285","GSM3109286",
"GSM3109287","GSM3109288","GSM3109289","GSM3109290","GSM4149671","GSM4149672","GSM4149673","GSM4149674","GSM4149675","GSM4149676","GSM4191898","GSM4191899","GSM4191900","GSM4191901","GSM4191902","GSM4191903","GSM4191904","GSM4191905","GSM4191906","GSM4191907","GSM4191908","GSM4191909","GSM3426984","GSM3426985","GSM3426986","GSM3978319","GSM3978320","GSM3978322","GSM3978324","GSM3978325",
"GSM3978327","GSM3978328","GSM3978330","GSM4005530","GSM4005531","GSM4005532","GSM4005533","GSM4005534","GSM4005535","GSM4005536","GSM4005537","GSM4005538","GSM4005539","GSM4684617","GSM4684618","GSM4684619","GSM4684620","GSM4684621","GSM4684622","GSM3510399","GSM3510400","GSM3510401","GSM3510402","GSM3510403","GSM3510404","GSM3510405","GSM3510406","GSM3674029","GSM3674030","GSM3674031",
"GSM3674032","GSM3674033","GSM3674035","GSM3674036","GSM3674037","GSM3674038","GSM3674039","GSM3674040","GSM3674041","GSM3674042","GSM3674043","GSM3674044","GSM3674045","GSM3674046","GSM3674047","GSM3674048","GSM3674049","GSM3674050","GSM3674051","GSM3674052","GSM3674053","GSM3674054","GSM3674055","GSM3674056","GSM3674057","GSM3674058","GSM3674059","GSM3674060","GSM3674061","GSM3674062",
"GSM3674063","GSM3674064","GSM3674065","GSM3674066","GSM3674067","GSM3674068","GSM3674069","GSM3674070","GSM3674071","GSM3674072","GSM3674073","GSM3674074","GSM3674075","GSM3674076","GSM3674077","GSM3674078","GSM3674079","GSM3674080","GSM3674081","GSM3674082","GSM3674083","GSM3674084","GSM3674085","GSM3674086","GSM3674087","GSM3674088","GSM3674089","GSM3674090","GSM3674091","GSM3674092",
"GSM3674093","GSM3674094","GSM3674095","GSM3674096","GSM3674097","GSM3674098","GSM3674099","GSM3674100","GSM3674101","GSM3674102","GSM3674103","GSM3674104","GSM3674105","GSM3674106","GSM3674107","GSM4225130","GSM4225131","GSM4225132","GSM4225133","GSM4225134","GSM4225135","GSM4225136","GSM4225137","GSM4225138","GSM4225139","GSM4225140","GSM4225141","GSM4699528","GSM4699529","GSM4699530",
"GSM2640705","GSM2640706","GSM2640707","GSM2640708","GSM2640709","GSM2640710","GSM2640711","GSM2640712","GSM2907088","GSM2907089","GSM2907090","GSM2907091","GSM2907092","GSM2907093","GSM2907094","GSM2907095","GSM2907096","GSM2907097","GSM2907098","GSM2907099","GSM3019778","GSM3074552","GSM3074554","GSM3074556","GSM3074557","GSM4117306","GSM4117308","GSM4156489","GSM4156490","GSM4156491",
"GSM4156492","GSM4156493","GSM4156494","GSM4156495","GSM4156496","GSM4407706","GSM4407707","GSM4407709","GSM4407711","GSM4407713","GSM4407714","GSM4407715","GSM4407716","GSM4407717","GSM4633149","GSM4633151","GSM4633152","GSM4721836","GSM4721837","GSM4721840","GSM4721841","GSM5057875","GSM5057876","GSM5057877","GSM5057878","GSM5057879","GSM5057880","GSM5057881","GSM5057882","GSM5057883",
"GSM5066133","GSM5066134","GSM5066135","GSM5066136","GSM5066137","GSM5066138","GSM5572855","GSM5572856","GSM5572857","GSM5572858","GSM5572859","GSM5572860","GSM5572861","GSM5572862","")

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

