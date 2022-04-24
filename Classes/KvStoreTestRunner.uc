class KvStoreTestRunner extends Actor;

/** Spawns actors and runs them as a test, logging the test results. This probably isn't the actor you want to place in your map. Or maybe it is. You do you. */


var bool bPostBPInitialized;
var array<name> testEvents;
var int testEventSize;
var int numTestsPassed;
var bool testInProgress;

function PostBeginPlay() {
  local Logger logger;
  local KvStoreChecker kvStoreChecker;
  local KvStoreSetter kvStoreSetter;
  local Dispatcher dispatcher;
  local KvStoreTestRunner kvStoreTestRunner;
  if (!bPostBPInitialized) {
    bPostBPInitialized = true;

    log("Initializing KvStoreTestRunner..." @ name);

    foreach allactors(class'KvStoreTestRunner', kvStoreTestRunner) {
      if (kvStoreTestRunner != self) {
        kvStoreTestRunner.bPostBPInitialized = true;
      }
    }

    logger = spawn(class'Logger');
    logger.tag = 'test1Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 1 - Happy path for local key if present";
    logger = spawn(class'Logger');
    logger.tag = 'test1Log2_';
    logger.logMessage = "FAIL - Test 1 - Happy path for local key if present";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test1Key1_" $ name;
    kvStoreSetter.newValue = "test1Key1Value_" $ name;
    kvStoreSetter.tag = 'test1Set1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_SET;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test1Key1_" $ name;
    kvStoreChecker.tag = 'test1Check1_';
    kvStoreChecker.event = 'test1Log1_';
    kvStoreChecker.eventOnCheckFailure = 'test1Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_PRESENT;
    dispatcher = spawn(class'Dispatcher');
    dispatcher.tag = 'test1Dispatcher1_';
    dispatcher.outEvents[0] = 'test1Set1_';
    dispatcher.outEvents[1] = 'test1Check1_';
    testEvents[testEventSize++] = 'test1Dispatcher1_';

    logger = spawn(class'Logger');
    logger.tag = 'test2Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 2 - Happy path for global key if present";
    logger = spawn(class'Logger');
    logger.tag = 'test2Log2_';
    logger.logMessage = "FAIL - Test 2 - Happy path for global key if present";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test2Key1_" $ name;
    kvStoreSetter.newValue = "test2Key1Value_" $ name;
    kvStoreSetter.tag = 'test2Set1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_SET;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_GLOBAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test2Key1_" $ name;
    kvStoreChecker.tag = 'test2Check1_';
    kvStoreChecker.event = 'test2Log1_';
    kvStoreChecker.eventOnCheckFailure = 'test2Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_GLOBAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_PRESENT;
    dispatcher = spawn(class'Dispatcher');
    dispatcher.tag = 'test2Dispatcher1_';
    dispatcher.outEvents[0] = 'test2Set1_';
    dispatcher.outEvents[1] = 'test2Check1_';
    testEvents[testEventSize++] = 'test2Dispatcher1_';

    logger = spawn(class'Logger');
    logger.tag = 'test3Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 3 - Happy path for checking cascading key value";
    logger = spawn(class'Logger');
    logger.tag = 'test3Log2_';
    logger.logMessage = "FAIL - Test 3 - Happy path for checking cascading key value";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test3Key1_" $ name;
    kvStoreSetter.newValue = "test3Key1Value_" $ name;
    kvStoreSetter.tag = 'test3Set1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_SET;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_GLOBAL;
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test3Key1_" $ name;
    kvStoreSetter.newValue = "test3Key1Value2_" $ name;
    kvStoreSetter.tag = 'test3Set2_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_SET;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test3Key1_" $ name;
    kvStoreChecker.expectedValue = "test3Key1Value2_" $ name;
    kvStoreChecker.tag = 'test3Check1_';
    kvStoreChecker.event = 'test3Log1_';
    kvStoreChecker.eventOnCheckFailure = 'test3Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_CASCADING;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_MATCH_VALUE;
    dispatcher = spawn(class'Dispatcher');
    dispatcher.tag = 'test3Dispatcher1_';
    dispatcher.outEvents[0] = 'test3Set1_';
    dispatcher.outEvents[0] = 'test3Set2_';
    dispatcher.outEvents[2] = 'test3Check1_';
    testEvents[testEventSize++] = 'test3Dispatcher1_';

    logger = spawn(class'Logger');
    logger.tag = 'test4Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 4 - Checking for value NOT present in local, expecting failure in check (test should not report fail)";
    logger = spawn(class'Logger');
    logger.tag = 'test4Log2_';
    logger.logMessage = "FAIL - Test 4 - Checking for value NOT present in local, expecting failure in check (test should not report fail)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test4Key1_" $ name;
    kvStoreSetter.newValue = "test4Key1Value_" $ name;
    kvStoreSetter.tag = 'test4Set1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_SET;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test4Key1_" $ name;
    kvStoreChecker.tag = 'test4Check1_';
    kvStoreChecker.event = 'test4Log2_';
    kvStoreChecker.eventOnCheckFailure = 'test4Log1_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_NOT_PRESENT;
    dispatcher = spawn(class'Dispatcher');
    dispatcher.tag = 'test4Dispatcher1_';
    dispatcher.outEvents[0] = 'test4Set1_';
    dispatcher.outEvents[1] = 'test4Check1_';
    testEvents[testEventSize++] = 'test4Dispatcher1_';

    logger = spawn(class'Logger');
    logger.tag = 'test5Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 5 - Testing increment from 0 to 1 and then 1 to 2";
    logger = spawn(class'Logger');
    logger.tag = 'test5Log2_';
    logger.logMessage = "FAIL - Test 5 - Testing increment from 0 to 1 and then 1 to 2 (failed first check)";
    logger = spawn(class'Logger');
    logger.tag = 'test5Log3_';
    logger.logMessage = "FAIL - Test 5 - Testing increment from 0 to 1 and then 1 to 2 (failed second check)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test5Key1_" $ name;
    kvStoreSetter.tag = 'test5Set1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_INCREMENT;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test5Key1_" $ name;
    kvStoreSetter.tag = 'test5Set2_';
    kvStoreSetter.event = 'test5Check2_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_INCREMENT;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test5Key1_" $ name;
    kvStoreChecker.expectedValue = "1";
    kvStoreChecker.tag = 'test5Check1_';
    kvStoreChecker.event = 'test5Set2_';
    kvStoreChecker.eventOnCheckFailure = 'test5Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_MATCH_VALUE;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test5Key1_" $ name;
    kvStoreChecker.expectedValue = "2";
    kvStoreChecker.tag = 'test5Check2_';
    kvStoreChecker.event = 'test5Log1_';
    kvStoreChecker.eventOnCheckFailure = 'test5Log3_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_MATCH_VALUE;
    dispatcher = spawn(class'Dispatcher');
    dispatcher.tag = 'test5Dispatcher1_';
    dispatcher.outEvents[0] = 'test5Set1_';
    dispatcher.outEvents[1] = 'test5Check1_';
    testEvents[testEventSize++] = 'test5Dispatcher1_';

    logger = spawn(class'Logger');
    logger.tag = 'test6Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 6 - Testing decrement from 0 to -1 and then -1 to -2";
    logger = spawn(class'Logger');
    logger.tag = 'test6Log2_';
    logger.logMessage = "FAIL - Test 6 - Testing decrement from 0 to -1 and then -1 to -2 (failed first check)";
    logger = spawn(class'Logger');
    logger.tag = 'test6Log3_';
    logger.logMessage = "FAIL - Test 6 - Testing decrement from 0 to -1 and then -1 to -2 (failed second check)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test6Key1_" $ name;
    kvStoreSetter.tag = 'test6Set1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_DECREMENT;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test6Key1_" $ name;
    kvStoreSetter.tag = 'test6Set2_';
    kvStoreSetter.event = 'test6Check2_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_DECREMENT;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test6Key1_" $ name;
    kvStoreChecker.expectedValue = "-1";
    kvStoreChecker.tag = 'test6Check1_';
    kvStoreChecker.event = 'test6Set2_';
    kvStoreChecker.eventOnCheckFailure = 'test6Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_MATCH_VALUE;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test6Key1_" $ name;
    kvStoreChecker.expectedValue = "-2";
    kvStoreChecker.tag = 'test6Check2_';
    kvStoreChecker.event = 'test6Log1_';
    kvStoreChecker.eventOnCheckFailure = 'test6Log3_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_MATCH_VALUE;
    dispatcher = spawn(class'Dispatcher');
    dispatcher.tag = 'test6Dispatcher1_';
    dispatcher.outEvents[0] = 'test6Set1_';
    dispatcher.outEvents[1] = 'test6Check1_';
    testEvents[testEventSize++] = 'test6Dispatcher1_';

    logger = spawn(class'Logger');
    logger.tag = 'test7Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 7 - Greater, Less, Greater Equal, Less Equal";
    logger = spawn(class'Logger');
    logger.tag = 'test7Log2_';
    logger.logMessage = "FAIL - Test 7 - Greater, Less, Greater Equal, Less Equal";
    kvStoreSetter = spawn(class'KvStoreSetter');
    kvStoreSetter.keyToSet = "test7Key1_" $ name;
    kvStoreSetter.newValue = "227";
    kvStoreSetter.tag = 'test7Set1_';
    kvStoreSetter.event = 'test7Check1_';
    kvStoreSetter.setOperation = KvStoreSetter.SetOperationType.SOT_SET;
    kvStoreSetter.setting = KvStoreSetter.SetType.ST_LOCAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "225";
    kvStoreChecker.tag = 'test7Check1_';
    kvStoreChecker.event = 'test7Check2_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_GREATER;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "436";
    kvStoreChecker.tag = 'test7Check2_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.eventOnCheckFailure = 'test7Check3_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_GREATER;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "436";
    kvStoreChecker.tag = 'test7Check3_';
    kvStoreChecker.event = 'test7Check4_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_LESS;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "225";
    kvStoreChecker.tag = 'test7Check4_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.eventOnCheckFailure = 'test7Check5_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_LESS;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "225";
    kvStoreChecker.tag = 'test7Check5_';
    kvStoreChecker.event = 'test7Check6_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_GREATEREQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "227";
    kvStoreChecker.tag = 'test7Check6_';
    kvStoreChecker.event = 'test7Check7_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_GREATEREQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "469";
    kvStoreChecker.tag = 'test7Check7_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.eventOnCheckFailure = 'test7Check8_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_GREATEREQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "436";
    kvStoreChecker.tag = 'test7Check8_';
    kvStoreChecker.event = 'test7Check9_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_LESSEQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "227";
    kvStoreChecker.tag = 'test7Check9_';
    kvStoreChecker.event = 'test7Check10_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log2_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_LESSEQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    kvStoreChecker.keyToCheck = "test7Key1_" $ name;
    kvStoreChecker.expectedValue = "225";
    kvStoreChecker.tag = 'test7Check10_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.eventOnCheckFailure = 'test7Log1_';
    kvStoreChecker.checking = KvStoreChecker.CheckType.CT_LOCAL_ONLY;
    kvStoreChecker.checkAction = KvStoreChecker.CheckActionType.CA_LESSEQUAL;
    testEvents[testEventSize++] = 'test7Set1_';
  }
}

static function printSummary(int numTestsPassed, int totalTests) {
  log("---------------------- Tests Passed:"$numTestsPassed);
  log("---------------------- Total Tests: "$totalTests);
}

event timer() {
  printSummary(numTestsPassed, testEventSize);
  testInProgress = false;
}

function trigger(Actor other, Pawn eventInstigator) {
  local int i;

  if (KvStoreChecker(other) != none || Logger(other) != none) {
    numTestsPassed++;
    return;
  }

  if (testInProgress) {
    log("Test already in progress, please wait until tests are completed before running again with the same actor...");
    return;
  }

  testInProgress = true;

  log("---------------------- KvStoreTestRunner ");

  if (eventInstigator == none) {
    log("Event instigator is none, cannot run tests...");
    printSummary(numTestsPassed, testEventSize);
    return;
  }

  for (i = 0; i < testEventSize; i++) {
    triggerEvent(testEvents[i], other, eventInstigator); 
  }

  setTimer(0.5, false);
}

defaultproperties {
  numTestsPassed=0
  testInProgress=false;
  bHidden=true
}