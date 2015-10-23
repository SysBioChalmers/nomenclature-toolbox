List of files that can be found in this repository:

--assign_identifiers.py:		python script to break down GEM model to its basic components
--names.tsv:				all the metabolite names in ChEBI database
--mets.tsv				A .tsv format file, parsed from a GEM model, containing Metabolites(In this case Metabolites from the original HMR2 model)
—-compounds.tsv				flat file including all the metabolites' standard names in ChEBI database
--ChEBI_KEGG_conversion_list.tsv:	flat file including all the metabolites' chemical formulas annotations in ChEBI database
--ChEBI_InChI_conversion_list.tsv:       flat file including all the metabolites' ChEBI ids and their respective InChi ids	

FUNCTIONALITY: 
	i)	The assign_identifiers.py program takes all the metabolites found in the mets.tv file and assigns annotation from ChEBI and InChI databases based on their name or chemical composition, The current output is all the possible annotation that one can have given these metabolites name and chemical composition.
	ii)	The mets.tsv file in this case is a test file that includes metabolites and their features and is the result from parsing GEM file
	iii)	The flat files compounds.tsv, ChEBI_KEGG_conversion_list-tsv, are not to be used by the user but they are necessary for the program to create dictionaries for linking the metabolites name and chemical composition to the ids. 

INPUT:  A .tsv format file, parsed from a GEM model, containing Metabolites—in this folder you can use mets.tsv
OUTPUT: A .tsv file containg metabolites ids, CHeBI and InChi Identifiers


EXECUTION: command line for Linux/Mac Terminal, OR command prompt Windows:

	1. make the file executable:	chmod +x assign_identifiers.py
	2. type the command:		./assign_identifiers.py						# The nomenclature assignment can be seen in your screen
	4. type the command:		./assign_identifiers.py > <filename_for_model_components>.tsv	# The nomenclature assignment can be stored in a .tsv file


PROGRAMMING LANGUAGE/Version:

	Python 2.7.10, you need a functional python installation of Python 2.7>= 

DEPENDENCIES (modules, libraries):
	- csv module (imported in script)
	- xml.etree.ElementTree (imported in script)
	- zipfile (imported in script)
	- re (imported in script)
	- itertools (imported in script)
	- collections (imported in script)
	- sys
	- os 
	- xlrd 0.9.4 module,	download and install from : https://pypi.python.org/pypi/xlrd
			
			there are four ways to download and install python packages:
			1. using easy_install:

					Make sure the destination directory exists. Enter mkdir -p $HOME/lib/pythonX.Y, where X.Y is the Python version, and press Enter.
Install the package. Enter easy_install-X.Y package, where package is the name of the package to install, and press Enter.
To use easy_install to install a package to a specific web application which makes use of the Python interpreter, enter PYTHONPATH=$HOME/webapps/app_name/lib/pythonX.Y easy_install-X.Y --install-dir=$HOME/webapps/app_name/lib/pythonX.Y --script-dir=$HOME/webapps/app_name/bin module_name, where app_name is the name of the web application as it appears in the control panel and press Enter.
								
			2. using setup.py:

					Make sure the destination directory exists. Enter mkdir -p $HOME/lib/pythonX.Y, where X.Y is the Python version, and press Enter.
Switch to the directory of setup.py. Enter cd path, where path is the path to the directory which contains setup.py, and press Enter.
Run setup.py. Enter PYTHONPATH=$HOME/lib/pythonX.Y pythonX.Y setup.py install --install-lib=$HOME/lib/pythonX.Y --install-scripts=$HOME/bin --install-data=$HOME/lib/pythonX.Y and press Enter.

			3. using pip :

					Create the destination directory, if it does not already exist: Enter mkdir -p $HOME/lib/pythonX.Y, where X.Y is the Python version, and press Enter.
Install pip. Enter easy_install-X.Y pip, where X.Y is the version of Python you wish to use, and press Enter.
To use pip to install packages in your home directory, enter pipX.Y install --user package, where package is the name of the package, and press Enter. To upgrade an existing package, enter pipX.Y install --user --upgrade package and press Enter.
			
			4. form  source:

					Make sure the destination directory exists. Enter mkdir -p $HOME/lib/pythonX.Y, where X.Y is the Python version, and press Enter.
Copy the source files to $HOME/lib/pythonX.Y. Alternatively, you may symbolically link to those files.
Alternatively, you can install packages directly to a web application which makes use of the Python interpreter by copying files to $HOME/webapps/app_name/lib/pythonX.Y, where app_name is the name of the web application as it appears in the control panel and press Enter.



	 
	
	
	
	

  
