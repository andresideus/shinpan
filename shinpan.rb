#!/usr/bin/ruby

require 'pp'

# have a scoreboard data structure
scoreboard = {
  "red" => {
    "men" => 0,
    "kote" => 0,
    "do" => 0,
    "tsuki" => 0,
    "hansoku" => {
      "current" => 0,
      "total" => 0
    },
    "points" => 0
  },
  "white" => {
    "men" => 0,
    "kote" => 0,
    "do" => 0,
    "tsuki" => 0,
    "hansoku" => {
      "current" => 0,
      "total" => 0
    },
    "points" => 0
  },
  "time" => false,
  "game_over" => false
}

# generate events in match
def shiai_event
 result = {}

 # some affect the score
 score_events = ["hansoku", "men", "kote", "do", "tsuki"]

 # some don't
 misc_events = ["time", "stoppage"]

 # generate an event
 event = (score_events + misc_events).sample

 # specify if scoring and colour
 result['event'] = event
 if score_events.include?(event)
   result['colour'] = ["red", "white"].sample
   result['score'] = true
 else
   result['score'] = false
 end
 result
end


# parse an event to write to scoreboard
def write_score (event, scoreboard)

  # if a scoring event the log the waza/points to the player
  if event['score']

     # process hansoku
     if event['event'] == "hansoku"
       scoreboard[event['colour']]["hansoku"]["current"] += 1
       scoreboard[event['colour']]["hansoku"]["total"] += 1

       # if 2 hansoku, log point and reset counter
       if scoreboard[event['colour']]["hansoku"]["current"] == 2
         scoreboard[event['colour']]["points"] += 1
         scoreboard[event['colour']]["hansoku"]["current"] = 0
       end

     # log point and scoring current
     else
       scoreboard[event['colour']]["points"] += 1
       scoreboard[event['colour']][event["event"]] += 1
     end
  else
    # is time over?
    scoreboard["time"] = true if event['event'] == "time"
  end
  scoreboard
end

# parse the scoreboard to see if match finishes
def evaluate_score (scoreboard)

  # anyone have 2 points or time over?
  if scoreboard["red"]["points"] == 2 || scoreboard["white"]["points"] == 2 || scoreboard["time"] == true

    # over to you hudson
    scoreboard["game_over"] = true
  end
  puts scoreboard.pretty_inspect
end

# generate events until game over
while scoreboard["game_over"] == false
  step = shiai_event
  write_score(step,scoreboard)
  evaluate_score(scoreboard)
  puts "\nPress enter to continue."
  gets
end
puts "Shobu ari!"
