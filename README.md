![logo](https://github.com/jmcamza/CHOMan/blob/master/turbocho.png)

**turboCHO** is a tool created to help in the design of cell engineering strategies to improve the secretion capacity of Chinese Hamster Ovary (CHO) cells for the production of biologics. **turboCHO** leverages the availability of masive amounts of transcriptome data from cells with different secretory phenotypes and train a neural network that captures the relation between the transcription profile and the secretion potential. **turboCHO** generates potential genetic targets for further analysis and/or cell line development.

How to run the code:
Run the following command:
python turboCHO.py <name_of_RNAseq_file> <secreted_genes_file> <number_of_samples> <output_file>

Example:
- name_of_RNAseq_file = results_clean_qnorm.csv
- secreted_genes_file = secreted_genes_included.npy
- number_of_samples = 10 //This is the number of samples to be picked randomly as templates to perform in-silico overexpressions
- output_file = predictions.csv



> **Note:** The **files** used in the examples will be available separately


>Files can be found in:
>smb://dtu-storage.win.dtu.dk/department/cfb/CFB-CHO/CLED/Personal/Manuel/CHOMan_data
