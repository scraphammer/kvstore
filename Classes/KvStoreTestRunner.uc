class KvStoreTestRunner extends Actor;

//** Spawns actors and runs them as a test, logging the test results. This probably isn't the actor you want to place in your map. Or maybe it is. You do you. */


var bool bPostBPInitialized;
var array<name> testEvents;

function PostBeginPlay() {
  if (!bPostBPInitialized) {
    bPreBPInitialized = True;

    //spawn all the crap
  }
}

function trigger(Actor other, Pawn eventInstigator) {
  local int i;
  local int testEventSize;
  testEventSize = array_size(testEvents);
  for (i = 0; i < testEventSize; i++) {
    triggerEvent(testEvents[i], other, eventInstigator); 
  }
}
