//=============================================================================
// Logger: Logs a message when triggered.
// This probably isn't very useful to most mappers.
// Also has a pass-through on its event.
//=============================================================================
class Logger extends Triggers nousercreate;

var() string logMessage;

function trigger(Actor other, Pawn eventInstigator) {
  if (logMessage != "") log(logMessage);
  if (event != '') triggerEvent(event, self, eventInstigator); 
}