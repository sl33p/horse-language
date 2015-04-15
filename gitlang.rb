# Quick command line app to check your predominant language on GitHub
# Nicklas Persson April 14, 2015

require "json"
require 'open-uri'

# Enter a username to get started
puts 'Hello. Please enter a GitHub username:'
user_name = gets.chomp

# Search GitHub for the users public repos
url =  "https://api.github.com/users/#{user_name}/repos"
begin
repos = open(url).read
rescue 
  # could do more thorough checking but it's likely not a valid user / 404
  puts "We can't find #{user_name}. Good bye."
  exit
end

# parse the repos from the left hand side
json = JSON.parse(repos)

system("clear")

# if there are no repos we'll exit. Could fix this up a little
if json.length < 1 then 
  puts "#{user_name} has no public repos. Sorry. I'm leaving now"
  exit
else
  puts "#{user_name} has #{json.length} public repos. Here are the top ones:
---------------------------------
"  
# run through the repos and check for top language 
json.each do |repo|
  unless repo['language'].nil? then
    puts "| #{repo['name']} : #{repo['language']}"

    # add to array so we can check the frequency
    @langs = @langs.to_a.push repo['language']
  end
end

# output the results
puts " ---------------------------------"
most_frequent_item = @langs.uniq.max_by{ |i| @langs.count( i ) }

# suspense
sleep 1
puts "
The winner is…" 
sleep 1
if most_frequent_item == 'Ruby' then
puts "
██████╗ ██╗   ██╗██████╗ ██╗   ██╗
██╔══██╗██║   ██║██╔══██╗╚██╗ ██╔╝
██████╔╝██║   ██║██████╔╝ ╚████╔╝ 
██╔══██╗██║   ██║██╔══██╗  ╚██╔╝  
██║  ██║╚██████╔╝██████╔╝   ██║   
╚═╝  ╚═╝ ╚═════╝ ╚═════╝    ╚═╝

not bad.
"
else
puts "#{most_frequent_item }. Ah well."
end
end