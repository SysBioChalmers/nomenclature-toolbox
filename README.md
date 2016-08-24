Nomenclature Script for HMR: A Matlab Toolbox for Assigning InChi and ChEBI identifiers to the metabolites in a Genom Scale Metabolic model

	FUNCTIONALITY: i) The Nomenclature.m script takes all the metabolites found in HMR genome-scale metabolic model and assigns annotation from ChEBI and InChI databases based on their name or chemical composition. The script locates all the possible annotation identifiers that one can have given these metabolites name and chemical composition.

	ii) Convert The metabolite ids according to SysBio standards

		-- Minor conversion of the reaction ids  from “HMR_xxxx” to “HMR_000xxxx”
		-- Minor conversion of the internal metabolite ids  from “m_xxxx” to “m_000xxxx”
	iii) The flat files compounds.tsv, ChEBI_KEGG_conversion_list-tsv, are necessary for the program to create dictionaries for linking the metabolites name and chemical composition to the ids.

	INPUT: A GEM model file in this folder you can use

	OUTPUT: An updated version of the model, including metabolites ids, CHeBI and InChi Identifiers

	EXECUTION: command line Matlab:
		Nomenclature

	PROGRAMMING LANGUAGE/Version:
		You need a functional Matlab installation of Matlab_R_2011_Rb>= 

	DEPENDENCIES (modules, libraries):
		cprintf Matlab Library
