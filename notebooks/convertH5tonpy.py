import numpy as np
import pandas as pd
import h5py

# This is code from 1_tpm_to_gene_level.ipynb
# This requires an awful lot of memory and several hours.
# Using this script you could submit it to a big memory computer system instead of running it in jupyter
f=h5py.File("../inputs/human_tpm_v11.h5","r")
geo_accession_array = list(f["meta/samples/geo_accession"].asstr())
samples_types=pd.read_csv("../outputs/samples_types.csv",index_col=None)
samples_types.set_index("geo_id",drop=False,inplace=True)
geo_accession_array_as_dict = dict(zip(geo_accession_array,range(0,len(geo_accession_array))))
samples_index = samples_types.geo_id.map(geo_accession_array_as_dict.get).to_list()
np.save("/work1/laeb/selected_human_matrix_V11_tpm.npy",f["data/expression"][:,sorted(samples_index)])
f.close()
