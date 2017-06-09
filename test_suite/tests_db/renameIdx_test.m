function tests = renameIdx_test

tests = functiontests( localfunctions );

function setup( testCase )

testCase.TestData.a_db = tests_db([4 5 6], {'a', 'b', 'c'}, {'one'}, 'test');
testCase.TestData.a_db_norows = tests_db([4 5 6], {'a', 'b', 'c'}, {}, 'test');
testCase.TestData.a_3_db = tests_3D_db([1 2 3], {'a', 'b', 'c'}, {'one'}, {'page0'}, 'test3D');
testCase.TestData.a_3_pageless_db = tests_3D_db([1 2 3], {'a', 'b', 'c'}, {'one'}, {}, 'test3D');

function testName( testCase )

b_db = renameColumns(testCase.TestData.a_db, 'a', 'aa');

assert(b_db.col_idx.aa == 1);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testDup( testCase )

b_db = renameColumns(testCase.TestData.a_db, 'a', 'a');

assert(b_db.col_idx.a == 1);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testDupNum( testCase )

b_db = renameColumns(testCase.TestData.a_db, 1, 'a');

assert(b_db.col_idx.a == 1);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testIdx( testCase )

b_db = renameColumns(testCase.TestData.a_db, 1, 'aa');

assert(b_db.col_idx.aa == 1);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testIdx2( testCase )
  
b_db = renameColumns(testCase.TestData.a_db, 3, 'aa');

assert(b_db.col_idx.aa == 3);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testRegexp( testCase )
  
b_db = renameColumns(testCase.TestData.a_db, '/a/', 'aa');

assert(b_db.col_idx.aa == 1);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testRegexpReplace( testCase )
  
b_db = renameColumns(testCase.TestData.a_db, '/(.)/', '$1_add');

assert(b_db.col_idx.a_add == 1);
assert(b_db.col_idx.c_add == 3);
assert(length(fieldnames(b_db.col_idx)) == 3);

function testRowNum( testCase )

b_db = renameRows(testCase.TestData.a_db_norows, 1, 'row1');

assert(b_db.row_idx.row1 == 1);
assert(length(fieldnames(b_db.row_idx)) == 1);

function testRow( testCase )

b_db = renameRows(testCase.TestData.a_db, 'one', 'row1');

assert(b_db.row_idx.row1 == 1);
assert(length(fieldnames(b_db.row_idx)) == 1);

function testPage( testCase )

b_db = renamePages(testCase.TestData.a_3_db, 'page0', 'pp');

assert(b_db.page_idx.pp == 1);
assert(length(fieldnames(b_db.page_idx)) == 1);

function testPageNum( testCase )

b_db = renamePages(testCase.TestData.a_3_db, 1, 'pp');

assert(b_db.page_idx.pp == 1);
assert(length(fieldnames(b_db.page_idx)) == 1);

function testPageNumNameless( testCase )

b_db = renamePages(testCase.TestData.a_3_pageless_db, 1, 'pp');

assert(b_db.page_idx.pp == 1);
assert(length(fieldnames(b_db.page_idx)) == 1);

