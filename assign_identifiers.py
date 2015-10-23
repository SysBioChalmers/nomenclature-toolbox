#!/usr/bin/env python


# Importing all the neccessary packages
import xml.etree.ElementTree as ET
import os,sys,zipfile,re,itertools,xlrd, csv, itertools
from collections import defaultdict

# Intitialising variables

mets_name=Chebi_metabolite_name=[]
mets_id=mets_composition=Chebi_id=Inchi_id=[]


#-------------------------------------------------------------------------------------------
'''DEFINING FUNCTIONS '''


'''Function to get ChEBI id from a tsv file'''
def get_Chebi(filename,col):
 	lines=[]
 	element=[]
	a='CHEBI:'
 	with open(filename) as tsv:
		for line in ([line for line in csv.reader(tsv, delimiter="\t")]):
			lines.append(line)
		
		for line in lines[1:]:
			char=a + str(line[col])
			element.append(char)
		return element


'''Function to get element from a column of tsv file'''
def get_element(filename,col):
 	lines=[]
 	element=[]
 	with open(filename) as tsv:
		for line in ([line for line in csv.reader(tsv, delimiter="\t")]):
			lines.append(line)
		
		for line in lines[1:]:
			element.append(line[col])
		return element



#-------------------------------------------------------------------------------------------
'''MAIN '''


''' Get metabolites names and ids'''
mets_name = get_element("mets.tsv",2)
mets_id = get_element("mets.tsv",8)
mets_composition = get_element("mets.tsv",5)

''' Get Chebi metabolites names and ids'''
Chebi_metabolite_name = get_element("compounds.tsv",5)
Chebi_id = get_Chebi("compounds.tsv",0)

'''MAP Chebi Metabolite name to Chebi ID'''
Chebi_dictionary = dict(zip(Chebi_metabolite_name,Chebi_id))

Chebi_inverse_dictionary =  dict((v,k) for k,v in Chebi_dictionary.items())




''' Get Chebi metabolites names and ids'''
formula = get_element("ChEBI_KEGG_conversion_list.tsv",4)
Chebi_id_formula = get_Chebi("ChEBI_KEGG_conversion_list.tsv",0)

'''MAP Chemical composition to Chebi ID '''
Chemical_map= dict(zip(Chebi_id_formula, formula))



''' Get InChi metabolites  ids'''
Chebi_to_Inchi_id=get_Chebi("ChEBI_InChI_conversion_list.tsv",0)
Inchi_id= get_element("ChEBI_InChI_conversion_list.tsv",1)

'''MAP Chebi ID to Inchi id'''
InChi_dictionary = dict(zip(Chebi_to_Inchi_id,Inchi_id))


''' Assign Chebi and Inchi identifiers and print output in a file'''
for index, metabolite in enumerate(mets_name):
	composition=mets_composition[index]
	if metabolite in Chebi_dictionary:
		chebiid=Chebi_dictionary.get(metabolite)
		if chebiid in InChi_dictionary:
			print mets_id[index], "\t", metabolite, "\t", chebiid, "\t", InChi_dictionary.get(chebiid), "\t", composition
		else:
			print mets_id[index], "\t", metabolite, "\t", chebiid
	if composition in formula:				#Take the metabolites Chemical Composition
		print "Aternative Nomenclature Choices"
		for chebi,form in zip(Chebi_id_formula, formula):
			if composition == form:		#If the composition has a CHhEBI Id, return all the possible ids for this composition
					if chebi in InChi_dictionary:	#If the composition has an InChi Id, return InChi string
						print mets_id[index], "\t", metabolite, "\t", chebi, "\t",InChi_dictionary.get(chebi), "\t", form
					else:
						if chebi in Chebi_inverse_dictionary:
							chebi_metabolite_name=Chebi_inverse_dictionary.get(chebi)						
							print mets_id[index], "\t", metabolite, "\t", chebi, "\t", chebi_metabolite_name, "\t", form
		print mets_id[index], "\t", metabolite, "\t", "Potential candidate metabolite  of lipid metabolism"				
	else:
		print mets_id[index], "\t", metabolite, "\t", "Unidentified metabolite-potential candidate for lipid metabolism"
	print "\n"
	
	
	
	
	
	
#''' Output function  for elements and metabolites in tsv format'''
##for name,ids in itertools.izip_longest(mets_name,mets_id):
##	print name,"\t",ids



#''' Output function for Chebi in tsv format'''
##for metname,chebiids in itertools.izip_longest(Chebi_metabolite_name,Chebi_id):
##	print metname,"\t",chebiids


#''' Output function for InChi in tsv format'''
##for inchiids in itertools.izip_longest(Inchi_id):
##	print inchiids

