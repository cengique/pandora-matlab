Creating a Generic Pandora Database
===================================

In this tutorial, we will cover how to create a generic database object. The scope of this tutorial assumes that you'e already downloaded and setup the Pandora Toolbox with your version of Mat Lab. If that is not the case, please see [insert link here](link.com)

 # 1.Creating the DataSet Object
 

 1.1. Necessary Files
 --
 ``pandora-matlab\doc\tutorials\incf\supp_mat_2_dat``
 
 In pandora there are several methods for creating a DataSet object. we will be using the ``>>params_tests_fileset`` object method. This object uses raw data from a grouping of files using any number of files you'd like. We will be using the following command to create the dataset.
 
``>> params_tests_fileset(file-pattern, dt, dy, id, props)``

```
file-pattern: A string notation used to establish which files to pull raw data from.
```
see ``>>help trace`` for a list of file formats
`file-pattern = '*.txt'` 
This indicates that we want all `.txt` files only.

```
dt: time resolution of the data.
dy: The y-axis resolution of the data.
```

`dt = 1e-4;   % recorded @ 10 khz`
`dy = 1e-3;   % in mV`

```
id: identification string for your dataset object.
props: A structure array object.
```

`id = 'dataset1';`
`props = struct;`

 First call `>>load('test_data')` in the command window. This will create a variable `test_data`. This variable will be in the `.mat` format.  We will be using the `ASCII` file format for our data. To convert the data to a text file, call: `>>  save -ASCII file.txt test_data` in the command window. This saves `test_data` to `file.txt`. All thats left to do now is to call the following command to create and store your data set in a variable.
 
 ``my_data_set = params_tests_fileset(file-pattern, dt, dy, id, props) ``
 
 2.Creating the Database Object
 --
 
 creating a database is now pretty simple using the following line.
 
 ``my_db = params_tests_db(my_data_set)``




