# R script to download selected samples
# Copy code and run on a local machine to initiate download

library("rhdf5")    # can be installed using Bioconductor

destination_file = "human_matrix_v10.h5"
extracted_expression_file = "Stromal Cell_expression_matrix.tsv"
url = "https://s3.amazonaws.com/mssm-seq-matrix/human_matrix_v10.h5"

# Check if gene expression file was already downloaded, if not in current directory download file form repository
if(!file.exists(destination_file)){
    print("Downloading compressed gene expression matrix.")
    download.file(url, destination_file, quiet = FALSE, mode = 'wb')
}

# Selected samples to be extracted
samp = c("GSM1534558","GSM1649160","GSM1649159","GSM1376804","GSM1884741","GSM1376808","GSM1884733","GSM1884754","GSM1534563","GSM1534561","GSM1884735","GSM1376807","GSM1376809","GSM1884738","GSM1534560","GSM1884736","GSM1884757","GSM1884749","GSM1649161","GSM1649154","GSM1884751","GSM1884767","GSM1376810","GSM1884764","GSM1534562","GSM1884734","GSM1884746","GSM1649158","GSM1534559","GSM1884759","GSM1884762",
"GSM1376806","GSM1649162","GSM1884770","GSM1973964","GSM1973963","GSM1973962","GSM1973965","GSM1973958","GSM1973966","GSM1973961","GSM1973959","GSM1973960","GSM1376811","GSM1376805","GSM1884743","GSM2640581","GSM2773985","GSM2773986","GSM2773987","GSM2773988","GSM2773989","GSM2773990","GSM2806612","GSM2806613","GSM2806614","GSM2806615","GSM2806616","GSM2806617","GSM2806618","GSM2806619",
"GSM2806620","GSM2806621","GSM2806622","GSM2806623","GSM2374573","GSM2374575","GSM2374577","GSM2374578","GSM2374579","GSM2374580","GSM2374581","GSM2374582","GSM2374583","GSM2374584","GSM2374585","GSM2374586","GSM2374587","GSM2374588","GSM2374590","GSM2374591","GSM2374592","GSM2374593","GSM2374594","GSM2374595","GSM2374596","GSM2374602","GSM2374603","GSM2374604","GSM2374606","GSM2374607",
"GSM2374608","GSM2374609","GSM2374610","GSM2374611","GSM2374612","GSM2374613","GSM2374614","GSM2374615","GSM2374616","GSM2374617","GSM2374618","GSM2374619","GSM2374620","GSM2374621","GSM2374622","GSM2374623","GSM2374625","GSM2374627","GSM2374629","GSM2374630","GSM2374632","GSM2374633","GSM2374634","GSM2374635","GSM2374636","GSM2374637","GSM2374638","GSM2374639","GSM2374641","GSM2374643",
"GSM2374644","GSM2374645","GSM2374646","GSM2374647","GSM2374648","GSM2374649","GSM2374650","GSM2374651","GSM2374655","GSM2374656","GSM2374657","GSM2374658","GSM2374659","GSM2374660","GSM3175942","GSM3175943","GSM3175954","GSM3175955","GSM3175966","GSM3175967","GSM3175986","GSM3175987","GSM3176022","GSM3176023","GSM3176040","GSM3176041","GSM3176080","GSM3176081","GSM3176100","GSM3176101",
"GSM3239710","GSM3239714","GSM3239715","GSM3239717","GSM3239718","GSM3239719","GSM3239720","GSM2894834","GSM2894835","GSM3439685","GSM3439686","GSM3439687","GSM3439688","GSM3439689","GSM3439690","GSM3439692","GSM3439695","GSM3439698","GSM3439701","GSM3439704","GSM3439707","GSM3692317","GSM3692318","GSM3822041","GSM3822042","GSM3822043","GSM3822044","GSM3822045","GSM3822046","GSM3822047",
"GSM3822048","GSM3822049","GSM3822050","GSM3822051","GSM3822052","GSM4128688","GSM4128689","GSM4128690","GSM4128691","GSM4128692","GSM4128693","GSM4128694","GSM4128695","GSM4128696","GSM4128697","GSM4128698","GSM4128699","GSM4128700","GSM4128701","GSM4128702","GSM4128703","GSM4128704","GSM4128705","GSM4128706","GSM4128707","GSM4128708","GSM4128709","GSM4128710","GSM4128711","GSM4128712",
"GSM4128713","GSM4128714","GSM4128715","GSM4128716","GSM4128717","GSM4128718","GSM4128719","GSM4128720","GSM4128721","GSM4128722","GSM4128723","GSM4128724","GSM4128725","GSM4128726","GSM3356787","GSM3356788","GSM3356789","GSM3356790","GSM3387235","GSM3387236","GSM3387237","GSM3387238","GSM3387239","GSM3387240","GSM3387241","GSM3387242","GSM3387243","GSM4037628","GSM4037629","GSM4037630",
"GSM4037631","GSM4037632","GSM4037633","GSM4037634","GSM4037635","GSM4037636","GSM4037637","GSM4037638","GSM4128727","GSM4330931","GSM4330932","GSM4330933","GSM4330934","GSM4330935","GSM4330936","GSM4577169","GSM4577170","GSM4577171","GSM4577172","GSM4577173","GSM4577174","GSM4577175","GSM4577176","GSM3670628","GSM3670629","GSM3670630","GSM3670631","GSM3670632","GSM3670633","GSM3670634",
"GSM3670635","GSM3670636","GSM3673767","GSM3673768","GSM3673769","GSM3673770","GSM3673771","GSM3673772","GSM3673773","GSM3673774","GSM3673775","GSM3673776","GSM3673777","GSM3673778","GSM3986294","GSM3986296","GSM3986298","GSM3986301","GSM3986305","GSM3986306","GSM3986308","GSM3986310","GSM3986311","GSM3986317","GSM3986318","GSM3986319","GSM3986320","GSM3986322","GSM3986323","GSM3986325",
"GSM3986326","GSM3986329","GSM3986331","GSM3986332","GSM4473088","GSM4473089","GSM4473090","GSM4473091","GSM4473092","GSM4473093","GSM4824525","GSM4824526","GSM4824527","GSM4824528","GSM4824532","GSM4824533","GSM4824534","GSM4824535","GSM4824539","GSM4824540","GSM4824541","GSM4824542","GSM4877895","GSM4877896","GSM4877898","GSM4877899","GSM4877901","GSM4877902","GSM4877903","GSM4877904",
"GSM4877905","GSM4877906","GSM4877908","GSM4877909","GSM4877910","GSM4877912","GSM4877913","GSM4877914","GSM4877915","GSM4877916","GSM4877917","GSM4877918","GSM4990851","GSM4117870","GSM4117871","GSM4117872","GSM4117873","GSM4117874","GSM4117875","GSM4783531","GSM4783532","GSM4783533","GSM4783534","GSM4783535","GSM4783536","GSM4783537","GSM4783538","GSM4783539","GSM4859799","GSM4859800",
"GSM4859802","GSM4859803","GSM4859804","GSM5226380","GSM5226381","GSM5226382","GSM5226383","GSM5226384","GSM5226385","GSM5226386","GSM5226387","GSM5226388","GSM5226389","GSM5226390","GSM5226391","GSM5226392","GSM5226393","GSM5226394","GSM5226395","GSM5226396","GSM5226397","GSM5226398","GSM5226399","GSM5226400","GSM5226401","GSM5226402","GSM5226403","GSM5226404","GSM5226405","GSM5226406",
"GSM5226407","GSM5226408","GSM5226409","GSM5226410","GSM5226411","GSM5226412","GSM5226413","GSM5226414","GSM5226415","GSM5226416","GSM5226417","GSM5226418","GSM5226419","GSM5226420","GSM5226421","GSM5226422","GSM5226423","GSM5226424","GSM5226425","GSM5226426","GSM5226427","GSM5226428","GSM5226429","GSM5226430","GSM5226431","GSM5226432","GSM5226433","GSM5226434","GSM5226435","GSM5226436",
"GSM5226437","GSM5226438","GSM5226439","GSM5226440","GSM5226441","GSM5226442","GSM5226443","GSM5226444","GSM5226445","GSM5226446","GSM5226447","GSM5226448","GSM5226449","GSM5226450","GSM5226451","GSM5252384","GSM5252385","GSM5252386","GSM5252387","GSM5252388","GSM5252389","GSM5252390","GSM5252391","GSM5252392","GSM5252393","GSM5348159","GSM5348160","GSM5348161","GSM5348163","GSM5348164",
"GSM5348165","GSM5403777","GSM5403778","GSM5403779","GSM5403780","GSM5403781","")

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

