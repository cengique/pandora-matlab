function tests = addPages_test

  tests = functiontests( localfunctions );

function setup( testCase )
    testCase.TestData.a_3_db = tests_3D_db([1 2 3], {'a', 'b', 'c'}, {'one'}, {'page0'}, 'test3D');
    testCase.TestData.a_3_pageless_db = tests_3D_db([1 2 3], {'a', 'b', 'c'}, {'one'}, {}, 'test3D');
    testCase.TestData.a_db = tests_db([4 5 6], {'a', 'b', 'c'}, {'one'}, 'test');
  
function testValue( testCase )

    b_db = addPages(testCase.TestData.a_3_db, {'page2'}, [4 5 6]);
  
    assert(b_db.data(1, 1, 1) == 1);
    assert(b_db.data(1, 1, 2) == 4);
    assert(b_db(1, 2, 'page2') == 5);
  
function testObj( testCase )
  
    b_db = addPages(testCase.TestData.a_3_db, testCase.TestData.a_3_db);
    
    assert(b_db.data(1, 1, 1) == 1);
    assert(b_db.data(1, 1, 2) == 1);
    assert(b_db.data(1, 3, 2) == 3);
    %assert(b_db(1, 2, 'page0') == 2); % TODO: undefined because same name repeated
  
function testPageless( testCase )
  
    b_db = addPages(testCase.TestData.a_3_db, testCase.TestData.a_3_pageless_db);
    
    assert(b_db.data(1, 1, 1) == 1);
    assert(b_db.data(1, 1, 2) == 1);
    assert(b_db.data(1, 3, 2) == 3);
    assert(b_db(1, 2, 'page0') == 2);
    assert(b_db(1, 2, 'page2') == 2);

function testNameless( testCase )
  
    b_db = addPages(testCase.TestData.a_3_pageless_db, testCase.TestData.a_3_pageless_db);
    assert(b_db.data(1, 1, 1) == 1);
    assert(b_db.data(1, 1, 2) == 1);
    assert(b_db.data(1, 3, 2) == 3);
    assert(b_db(1, 2, 'page1') == 2); 
    assert(b_db(1, 2, 'page2') == 2); 
  
function testNon3DObj( testCase )
   
    b_db = addPages(testCase.TestData.a_3_db, testCase.TestData.a_db);

    assert(b_db.data(1, 1, 1) == 1);
    assert(b_db.data(1, 1, 2) == 4);
    assert(b_db(1, 2, 'page0') == 2);
    assert(b_db(1, 2, 'page2') == 5);
  

  
