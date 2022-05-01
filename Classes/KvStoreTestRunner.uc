//=============================================================================
// KvStoreTestRunner: Internal developer class for testing.
// Spawns actors and runs them as a test, logging the test results.
// This probably isn't the actor you want to place in your map. Or maybe it is. You do you.
//=============================================================================
class KvStoreTestRunner extends Actor nousercreate;

var bool bPostBPInitialized;
var array<name> testEvents;
var array<Actor> testActors;
var int testActorsSize;
var int testEventSize;
var int numTestsPassed;
var bool testInProgress;

event tick(float delta) {
  local PlayerPawn p;
  if (!bPostBPInitialized) {
    initialize();

    foreach allactors(class'PlayerPawn', p) {
      //congrats player p! you are now the test instigator :^)
      log("Running tests as Player"@p);
      break;
    }

    if (p != none) trigger(p, p);
  }
}

function initialize() {
  local Logger logger;
  local KvStoreChecker kvStoreChecker;
  local KvStoreSetter kvStoreSetter;
  local Dispatcher dispatcher;
  local KvStoreTestRunner kvStoreTestRunner;
  local EventInstigatorFunger eventInstigatorFunger;
  if (!bPostBPInitialized) {
    bPostBPInitialized = true;
    tag = 'testTagToRunTests';

    log("Initializing KvStoreTestRunner..." @ name);

    foreach allactors(class'KvStoreTestRunner', kvStoreTestRunner) {
      if (kvStoreTestRunner != self) {
        kvStoreTestRunner.bPostBPInitialized = true;
      }
    }

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test1Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 1 - Happy path for personal key if present";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test1Log2_';
    logger.logMessage = "FAIL - Test 1 - Happy path for personal key if present";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test1Key1_" $ name;
    kvStoreSetter.TargetValue = "test1Key1Value_" $ name;
    kvStoreSetter.tag = 'test1Set1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test1Key1_" $ name;
    kvStoreChecker.tag = 'test1Check1_';
    kvStoreChecker.event = 'test1Log1_';
    kvStoreChecker.EventOnFail = 'test1Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_PRESENT;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test1Dispatcher1_';
    dispatcher.outEvents[0] = 'test1Set1_';
    dispatcher.outEvents[1] = 'test1Check1_';
    testEvents[testEventSize++] = 'test1Dispatcher1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test2Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 2 - Happy path for global key if present";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test2Log2_';
    logger.logMessage = "FAIL - Test 2 - Happy path for global key if present";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test2Key1_" $ name;
    kvStoreSetter.TargetValue = "test2Key1Value_" $ name;
    kvStoreSetter.tag = 'test2Set1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_GLOBAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test2Key1_" $ name;
    kvStoreChecker.tag = 'test2Check1_';
    kvStoreChecker.event = 'test2Log1_';
    kvStoreChecker.EventOnFail = 'test2Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_GLOBAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_PRESENT;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test2Dispatcher1_';
    dispatcher.outEvents[0] = 'test2Set1_';
    dispatcher.outEvents[1] = 'test2Check1_';
    testEvents[testEventSize++] = 'test2Dispatcher1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test3Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 3 - Happy path for checking cascading key value";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test3Log2_';
    logger.logMessage = "FAIL - Test 3 - Happy path for checking cascading key value";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test3Key1_" $ name;
    kvStoreSetter.TargetValue = "test3Key1Value_" $ name;
    kvStoreSetter.tag = 'test3Set1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_GLOBAL;
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test3Key1_" $ name;
    kvStoreSetter.TargetValue = "test3Key1Value2_" $ name;
    kvStoreSetter.tag = 'test3Set2_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test3Key1_" $ name;
    kvStoreChecker.TargetValue = "test3Key1Value2_" $ name;
    kvStoreChecker.tag = 'test3Check1_';
    kvStoreChecker.event = 'test3Log1_';
    kvStoreChecker.EventOnFail = 'test3Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_CASCADING;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test3Dispatcher1_';
    dispatcher.outEvents[0] = 'test3Set1_';
    dispatcher.outEvents[0] = 'test3Set2_';
    dispatcher.outEvents[2] = 'test3Check1_';
    testEvents[testEventSize++] = 'test3Dispatcher1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test4Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 4 - Checking for value NOT present in local, expecting failure in check (test should not report fail)";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test4Log2_';
    logger.logMessage = "FAIL - Test 4 - Checking for value NOT present in local, expecting failure in check (test should not report fail)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test4Key1_" $ name;
    kvStoreSetter.TargetValue = "test4Key1Value_" $ name;
    kvStoreSetter.tag = 'test4Set1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test4Key1_" $ name;
    kvStoreChecker.tag = 'test4Check1_';
    kvStoreChecker.event = 'test4Log2_';
    kvStoreChecker.EventOnFail = 'test4Log1_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_NOT_PRESENT;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test4Dispatcher1_';
    dispatcher.outEvents[0] = 'test4Set1_';
    dispatcher.outEvents[1] = 'test4Check1_';
    testEvents[testEventSize++] = 'test4Dispatcher1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test5Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 5 - Testing increment from 0 to 1 and then 1 to 3";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test5Log2_';
    logger.logMessage = "FAIL - Test 5 - Testing increment from 0 to 1 and then 1 to 3 (failed first check)";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test5Log3_';
    logger.logMessage = "FAIL - Test 5 - Testing increment from 0 to 1 and then 1 to 3 (failed second check)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test5Key1_" $ name;
    kvStoreSetter.tag = 'test5Set1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_INCREMENT;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test5Key1_" $ name;
    kvStoreSetter.targetValue = "2";
    kvStoreSetter.tag = 'test5Set2_';
    kvStoreSetter.event = 'test5Check2_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_INCREMENT;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test5Key1_" $ name;
    kvStoreChecker.TargetValue = "1";
    kvStoreChecker.tag = 'test5Check1_';
    kvStoreChecker.event = 'test5Set2_';
    kvStoreChecker.EventOnFail = 'test5Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test5Key1_" $ name;
    kvStoreChecker.TargetValue = "3";
    kvStoreChecker.tag = 'test5Check2_';
    kvStoreChecker.event = 'test5Log1_';
    kvStoreChecker.EventOnFail = 'test5Log3_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test5Dispatcher1_';
    dispatcher.outEvents[0] = 'test5Set1_';
    dispatcher.outEvents[1] = 'test5Check1_';
    testEvents[testEventSize++] = 'test5Dispatcher1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test6Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 6 - Testing decrement from 0 to -1 and then -1 to -3";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test6Log2_';
    logger.logMessage = "FAIL - Test 6 - Testing decrement from 0 to -1 and then -1 to -3 (failed first check)";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test6Log3_';
    logger.logMessage = "FAIL - Test 6 - Testing decrement from 0 to -1 and then -1 to -3 (failed second check)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test6Key1_" $ name;
    kvStoreSetter.tag = 'test6Set1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_DECREMENT;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test6Key1_" $ name;
    kvStoreSetter.tag = 'test6Set2_';
    kvStoreSetter.event = 'test6Check2_';
    kvStoreSetter.targetValue = "2";
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_DECREMENT;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test6Key1_" $ name;
    kvStoreChecker.TargetValue = "-1";
    kvStoreChecker.tag = 'test6Check1_';
    kvStoreChecker.event = 'test6Set2_';
    kvStoreChecker.EventOnFail = 'test6Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test6Key1_" $ name;
    kvStoreChecker.TargetValue = "-3";
    kvStoreChecker.tag = 'test6Check2_';
    kvStoreChecker.event = 'test6Log1_';
    kvStoreChecker.EventOnFail = 'test6Log3_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test6Dispatcher1_';
    dispatcher.outEvents[0] = 'test6Set1_';
    dispatcher.outEvents[1] = 'test6Check1_';
    testEvents[testEventSize++] = 'test6Dispatcher1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test7Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 7 - Greater, Less, Greater Equal, Less Equal";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test7Log2_';
    logger.logMessage = "FAIL - Test 7 - Greater, Less, Greater Equal, Less Equal";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test7Key1_" $ name;
    kvStoreSetter.TargetValue = "227";
    kvStoreSetter.tag = 'test7Set1_';
    kvStoreSetter.event = 'test7Check1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_PERSONAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "225";
    kvStoreChecker.tag = 'test7Check1_';
    kvStoreChecker.event = 'test7Check2_';
    kvStoreChecker.EventOnFail = 'test7Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_GREATER;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "436";
    kvStoreChecker.tag = 'test7Check2_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.EventOnFail = 'test7Check3_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_GREATER;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "436";
    kvStoreChecker.tag = 'test7Check3_';
    kvStoreChecker.event = 'test7Check4_';
    kvStoreChecker.EventOnFail = 'test7Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_LESS;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "225";
    kvStoreChecker.tag = 'test7Check4_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.EventOnFail = 'test7Check5_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_LESS;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "225";
    kvStoreChecker.tag = 'test7Check5_';
    kvStoreChecker.event = 'test7Check6_';
    kvStoreChecker.EventOnFail = 'test7Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_GREATEREQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "227";
    kvStoreChecker.tag = 'test7Check6_';
    kvStoreChecker.event = 'test7Check7_';
    kvStoreChecker.EventOnFail = 'test7Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_GREATEREQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "469";
    kvStoreChecker.tag = 'test7Check7_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.EventOnFail = 'test7Check8_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_GREATEREQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "436";
    kvStoreChecker.tag = 'test7Check8_';
    kvStoreChecker.event = 'test7Check9_';
    kvStoreChecker.EventOnFail = 'test7Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_LESSEQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "227";
    kvStoreChecker.tag = 'test7Check9_';
    kvStoreChecker.event = 'test7Check10_';
    kvStoreChecker.EventOnFail = 'test7Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_LESSEQUAL;
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test7Key1_" $ name;
    kvStoreChecker.TargetValue = "225";
    kvStoreChecker.tag = 'test7Check10_';
    kvStoreChecker.event = 'test7Log2_';
    kvStoreChecker.EventOnFail = 'test7Log1_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_PERSONAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_LESSEQUAL;
    testEvents[testEventSize++] = 'test7Set1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test8Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 8 - Setting a value here, then checking it elsewhere";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test8Log2_';
    logger.logMessage = "FAIL - Test 8 - Setting a value here, then checking it elsewhere";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test8Log3_';
    logger.logMessage = "FAIL - Test 8 - Setting a value here, then checking it elsewhere (Only one player, cannot run test)";
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test8Key1_" $ name;
    kvStoreSetter.TargetValue = "test8Key1Value_" $ name;
    kvStoreSetter.tag = 'test8Set1_';
    kvStoreSetter.event = 'test8Funger1_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_GLOBAL;
    eventInstigatorFunger = spawn(class'EventInstigatorFunger');
    testActors[testActorsSize++] = eventInstigatorFunger;
    eventInstigatorFunger.tag = 'test8Funger1_';
    eventInstigatorFunger.event = 'test8Check1_';
    eventInstigatorFunger.eventOnlyOnePawn = 'test8Log3_';
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test8Key1_" $ name;
    kvStoreChecker.TargetValue = "test8Key1Value_" $ name;
    kvStoreChecker.tag = 'test8Check1_';
    kvStoreChecker.event = 'test8Log1_';
    kvStoreChecker.EventOnFail = 'test8Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_GLOBAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    testEvents[testEventSize++] = 'test8Set1_';

    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test9Log1_';
    logger.event = tag;
    logger.logMessage = "PASS - Test 9 - Setting a value elsewhere, then checking it here";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test9Log2_';
    logger.logMessage = "FAIL - Test 9 - Setting a value elsewhere, then checking it here";
    logger = spawn(class'Logger');
    testActors[testActorsSize++] = logger;
    logger.tag = 'test9Log3_';
    logger.logMessage = "FAIL - Test 9 - Setting a value elsewhere, then checking it here (Requires more than 1 player to run test. Not assured to work if more than 2 players.)";
    eventInstigatorFunger = spawn(class'EventInstigatorFunger');
    testActors[testActorsSize++] = eventInstigatorFunger;
    eventInstigatorFunger.tag = 'test9Funger1_';
    eventInstigatorFunger.event = 'test9Set1_';
    eventInstigatorFunger.eventOnlyOnePawn = 'test9Log3_';
    kvStoreSetter = spawn(class'KvStoreSetter');
    testActors[testActorsSize++] = kvStoreSetter;
    kvStoreSetter.TargetKey = "test9Key1_" $ name;
    kvStoreSetter.TargetValue = "test9Key1Value_" $ name;
    kvStoreSetter.tag = 'test9Set1_';
    kvStoreSetter.event = 'test9Funger2_';
    kvStoreSetter.OperationType = KvStoreSetter.EOperationType.OT_SET;
    kvStoreSetter.OperationScope = KvStoreSetter.EOperationScope.OS_GLOBAL;
    eventInstigatorFunger = spawn(class'EventInstigatorFunger');
    testActors[testActorsSize++] = eventInstigatorFunger;
    eventInstigatorFunger.tag = 'test9Funger2_';
    eventInstigatorFunger.event = 'test9Dispatcher1_';
    eventInstigatorFunger.eventOnlyOnePawn = 'test9Log3_';
    kvStoreChecker = spawn(class'KvStoreChecker');
    testActors[testActorsSize++] = kvStoreChecker;
    kvStoreChecker.TargetKey = "test9Key1_" $ name;
    kvStoreChecker.TargetValue = "test9Key1Value_" $ name;
    kvStoreChecker.tag = 'test9Check1_';
    kvStoreChecker.event = 'test9Log1_';
    kvStoreChecker.EventOnFail = 'test9Log2_';
    kvStoreChecker.CheckScope = KvStoreChecker.ECheckScope.CS_GLOBAL;
    kvStoreChecker.CheckOperation = KvStoreChecker.ECheckOperation.CO_EQUAL;
    dispatcher = spawn(class'Dispatcher');
    testActors[testActorsSize++] = dispatcher;
    dispatcher.tag = 'test9Dispatcher1_';
    dispatcher.outEvents[0] = 'test9Check1_';
    dispatcher.outDelays[0] = 0.5;
    testEvents[testEventSize++] = 'test9Funger1_';

    log("Initialized KvStoreTestRunner" @ name @ "with" @ testActorsSize @ "actors and" @ testEventSize @ "events!");
  }
}

static function printSummary(int numTestsPassed, int totalTests) {
  log("---------------------- Tests Passed:"$numTestsPassed);
  log("---------------------- Total Tests: "$totalTests);
}

event timer() {
  local int i;
  printSummary(numTestsPassed, testEventSize);
  testInProgress = false;
  for (i = 0; i < testActorsSize; i++) {
    testActors[i].destroy();
  }
  destroy();
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
  numTestsPassed = 0;

  log("---------------------- KvStoreTestRunner ");

  if (eventInstigator == none) {
    log("Event instigator is none, cannot run tests...");
    printSummary(numTestsPassed, testEventSize);
    return;
  }

  for (i = 0; i < testEventSize; i++) {
    triggerEvent(testEvents[i], other, eventInstigator); 
  }

  setTimer(1, false);
}

defaultproperties {
  numTestsPassed=0
  testInProgress=false;
  bHidden=true
}