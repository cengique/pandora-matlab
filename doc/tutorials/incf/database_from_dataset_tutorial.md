Creating a Generic Pandora Database from Files
==============================================

---

In this tutorial, we will cover how to create a generic database object. The scope of this tutorial assumes that you've already downloaded and setup the Pandora Toolbox with your version of MatLab. If that is not the case, please see [Installing Pandora](https://github.com/cengique/pandora-matlab/blob/master/README.md).

 # 1.Creating the DataSet Object
 

 1.1. The Necessary Files
 --


 ``pandora-matlab\doc\tutorials\incf\file.txt``
 
 In pandora there are several methods for creating a DataSet object. we will be using the ``>>params_tests_fileset`` object method. This object uses raw data from a grouping of files using any number of files you'd like. We will be using the following command to create the dataset.
 
``>> params_tests_fileset(file-pattern, dt, dy, id, props)``

First Let's identify our parameter variables.


- file-pattern: A file-format string notation used to establish which files to pull raw data from.
- dt: time resolution of the data.
- dy: The y-axis resolution of the data.
- id: identification string for your dataset object.
- props: A structure array object.

Now lets assign their values.

- `file-pattern = '*.txt'` 
This indicates that we want all `.txt` files only.  See ``>>help trace`` for a list of file formats  
- `dt = 1e-4;   % recorded @ 10 khz`
- `dy = 1e-3;   % in mV`
- `id = 'dataset1';`
- `props = struct;`

Now that we've gotten our parameter values, we are going to need some data.

We will be using the `ASCII` file format for our data.

Now call: `>>load('file.txt')` in the command window. 

(For more practice with data, please see [Loading Intracellular Data](load-trace.markdown) )

All thats left to do now is to call the following command to create and store your dataset in a variable:
 
 ``my_data_set = params_tests_fileset( '*.txt',  1e-4, 1e-3, 'dataset1', struct) ``
 
 2.Creating the Database Object
 --
 
 creating a database is now pretty simple using the following line:

 
 ``my_db = params_tests_db(my_data_set)``




